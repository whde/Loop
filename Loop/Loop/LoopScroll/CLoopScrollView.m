//
//  CLoopScrollView.m
//
//  Created by Whde on 15-11-27.
//  Copyright (c) 2013年 Whde. All rights reserved.
//

#import "CLoopScrollView.h"
#define Banner_StartTag     8768
#import "CLoopCell.h"
@interface CLoopScrollView ()<UIScrollViewDelegate>{
    NSInteger totalPage;
    NSInteger curPage;
}
// 是否支持滚动
@property (nonatomic, assign) BOOL enableRolling;
@property (nonatomic, copy, readonly) LoopScrollViewSelectBlock selectBlock;
@property (nonatomic, copy, readonly) LoopScrollViewScrollToIndexBlock scrollBlock;
@end


@implementation CLoopScrollView
@synthesize scrollDirection;
- (void)dealloc{
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}
- (void)setFrame:(CGRect)frame {
    for (UIView *loopItem in [self subviews]) {
        if ([loopItem isKindOfClass:[CLoopCell class]]) {
            CGRect rec = loopItem.frame;
            rec.size.width = frame.size.width;
            rec.size.height = frame.size.height;
            loopItem.frame = rec;
        }
    }
    [super setFrame:frame];
}
- (id)initWithFrame:(CGRect)frame scrollDirection:(LoopScrollViewScrollDirection)direction models:(NSArray *)models ofCellClass:(Class)cellClass{
    if (![cellClass isSubclassOfClass:[CLoopCell class]]) {
#if DEBUG
        NSLog(@"%@", cellClass);
#endif
    }
    self = [super initWithFrame:frame];
    if (self) {
        _models = [[NSArray alloc] initWithArray:models];
        self.scrollDirection = direction;
        totalPage = models.count;
        // 和数组是+1关系
        curPage = 1;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        // 在水平方向滚动
        if(scrollDirection == LoopScrollViewScrollDirectionLandscape) {
            self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        } else if (scrollDirection == LoopScrollViewScrollDirectionPortait) {
            // 在垂直方向滚动
            self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3);
        }
        for (NSInteger i = 0; i < 3; i++) {
            CLoopCell *itemView = [[cellClass alloc] initWith:nil withScrollViewFrame:self.bounds];
            itemView.tag = Banner_StartTag+i;
            [itemView addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
            // 水平滚动
            if(scrollDirection == LoopScrollViewScrollDirectionLandscape) {
                itemView.frame = CGRectOffset(itemView.frame, self.frame.size.width * i, 0);
            } else if(scrollDirection == LoopScrollViewScrollDirectionPortait) {
                // 垂直滚动
                itemView.frame = CGRectOffset(itemView.frame, 0, self.frame.size.height * i);
            }
            [self addSubview:itemView];
        }
    }
    return self;
}
- (void)setRollingDelayTime:(NSTimeInterval)rollingDelayTime{
    _rollingDelayTime = rollingDelayTime;
    [self refreshScrollView];
    [self startRolling];
}

- (void)reloadLoopWithData:(NSArray *)models {
    if (self.enableRolling) {
        [self stopRolling];
    }
    _models = [[NSArray alloc] initWithArray:models];
    totalPage = _models.count;
    curPage = 1;
}

- (void)setSquare:(NSInteger)asquare {
    if (self) {
        self.layer.cornerRadius = asquare;
        if (asquare == 0) {
            self.layer.masksToBounds = NO;
        } else {
            self.layer.masksToBounds = YES;
        }
    }
}

#pragma mark - Custom Method
- (void)refreshScrollView {
    NSArray *curModels = [self getDisplayModelsWithPageIndex:curPage];
    
    for (NSInteger i = 0; i < 3; i++){
        CLoopCell *itemView = (CLoopCell *)[self viewWithTag:Banner_StartTag+i];
        id model = [curModels objectAtIndex:i];
        if (itemView && [itemView isKindOfClass:[CLoopCell class]]) {
            [itemView reloadWith:model];
        }
    }
    
    // 水平滚动
    if (scrollDirection == LoopScrollViewScrollDirectionLandscape){
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
    } else if (scrollDirection == LoopScrollViewScrollDirectionPortait) {
        // 垂直滚动
        self.contentOffset = CGPointMake(0, self.frame.size.height);
    }
    
}

- (NSArray *)getDisplayModelsWithPageIndex:(NSInteger)page {
    NSInteger pre = [self getPageIndex:curPage-1];
    NSInteger last = [self getPageIndex:curPage+1];
    NSMutableArray *curModels = [NSMutableArray arrayWithCapacity:0];
    [curModels addObject:[_models objectAtIndex:pre-1]];
    [curModels addObject:[_models objectAtIndex:curPage-1]];
    [curModels addObject:[_models objectAtIndex:last-1]];
    return curModels;
}

- (NSInteger)getPageIndex:(NSInteger)index {
    // value＝1为第一张，value = 0为前面一张
    if (index == 0) {
        index = totalPage;
    }
    if (index == totalPage + 1) {
        index = 1;
    }
    return index;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_scrollBlock) {
            _scrollBlock(self, curPage-1, [_models objectAtIndex:curPage-1]);
        }
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    
    //取消已加入的延迟线程
    if (_enableRolling) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }
    
    // 水平滚动
    if(scrollDirection == LoopScrollViewScrollDirectionLandscape)
    {
        // 往下翻一张
        if (x >= self.frame.size.width) {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }
        
        if (x <= 0) {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    } else if(scrollDirection == LoopScrollViewScrollDirectionPortait) {
        // 垂直滚动
        // 往下翻一张
        if (y >= self.frame.size.height) {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }
        
        if (y <= 0) {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 水平滚动
    if (scrollDirection == LoopScrollViewScrollDirectionLandscape) {
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
    } else if (scrollDirection == LoopScrollViewScrollDirectionPortait) {
        // 垂直滚动
        self.contentOffset = CGPointMake(0, self.frame.size.height);
    }
    
    if (self.enableRolling) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:_rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}


#pragma mark -
#pragma mark Rolling

- (void)startRolling {
    if (![_models isKindOfClass:[NSArray class]] || _models.count == 1) {
        return;
    }
    
    [self stopRolling];
    
    self.enableRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:_rollingDelayTime];
}

- (void)stopRolling {
    self.enableRolling = NO;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction {
    [UIView animateWithDuration:0.25 animations:^{
        // 水平滚动
        if (scrollDirection == LoopScrollViewScrollDirectionLandscape) {
            self.contentOffset = CGPointMake(1.999*self.frame.size.width, 0);
        } else if (scrollDirection == LoopScrollViewScrollDirectionPortait) {
            // 垂直滚动
            self.contentOffset = CGPointMake(0, 1.999*self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
            
            if (self.enableRolling) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
                [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:_rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
        }
    }];
}


#pragma mark -
#pragma mark action
- (void)handleTap:(CLoopCell *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_selectBlock) {
            _selectBlock(self, view, curPage-1, [_models objectAtIndex:curPage-1]);
        }
    });
}



#pragma mark - --Block
- (void)setSelectBlock:(LoopScrollViewSelectBlock)selectBlock{
    _selectBlock = [selectBlock copy];
}
- (void)setScrollBlock:(LoopScrollViewScrollToIndexBlock)scrollBlock{
    _scrollBlock = [scrollBlock copy];
}
@end
