//
//  CBannerLoopCell.m
//  WhdeLoopDemo
//
//  Created by whde on 16/5/16.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "CBannerLoopCell.h"
@interface CBannerLoopCell() {
    UIImageView *_imgView;
}
@end

@implementation CBannerLoopCell

- (id)initWith:(id)model withScrollViewFrame:(CGRect)rect{
    self = [super initWith:model withScrollViewFrame:rect];
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    [self addSubview:_imgView];
    [self reloadWith:model];
    return self;
}

- (void)reloadWith:(id)model{
    [super reloadWith:model];
    [_imgView setImage:[UIImage imageNamed:@"240913726461444096.jpg"]];
}

@end
