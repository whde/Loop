//
//  CLoopScrollView.h
//
//  Created by Whde on 15-11-27.
//  Copyright (c) 2013年 Whde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLoopCell;
typedef NS_ENUM(NSInteger, LoopScrollViewScrollDirection){
    // 水平滚动
    LoopScrollViewScrollDirectionLandscape,
    // 垂直滚动
    LoopScrollViewScrollDirectionPortait
};

@interface CLoopScrollView : UIScrollView
// scrollView滚动的方向
@property (nonatomic, assign) LoopScrollViewScrollDirection scrollDirection;
// 滚动间隔
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;

- (id _Nonnull)initWithFrame:(CGRect)frame scrollDirection:(LoopScrollViewScrollDirection)direction models:(NSArray * _Nonnull)models ofCellClass:(Class _Nonnull)cellClass;
@property (nonatomic, strong, readonly) NSArray * _Nonnull models;
// 更换
- (void)reloadLoopWithData:(NSArray * _Nonnull)models;
// 设置圆角半径
- (void)setSquare:(NSInteger)asquare;
// 开始滚动
- (void)startRolling;
// 停止滚动
- (void)stopRolling;
// 滚动
- (void)rollingScrollAction;

#pragma mark - -Block
typedef void(^LoopScrollViewSelectBlock)(CLoopScrollView * _Nonnull loopScrollView, CLoopCell * _Nonnull view, NSInteger index, id _Nonnull model);
typedef void(^LoopScrollViewScrollToIndexBlock)(CLoopScrollView * _Nonnull loopScrollView, NSInteger index, id _Nonnull model);
- (void)setSelectBlock:(LoopScrollViewSelectBlock _Nonnull)selectBlock;
- (void)setScrollBlock:(LoopScrollViewScrollToIndexBlock _Nonnull)scrollBlock;
@end
