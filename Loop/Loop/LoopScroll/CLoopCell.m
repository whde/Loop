//
//  CLoopCell.m
//  eCarry
//
//  Created by whde on 16/1/11.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "CLoopCell.h"
@interface CLoopCell() {
    
}
@end

@implementation CLoopCell
// 根据每个Frame和model创建视图
- (instancetype)initWith:(id)model withScrollViewFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    return self;
}
// 根据model刷新试图
- (void)reloadWith:(id)model {
    
}

@end
