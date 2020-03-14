//
//  CLoopCell.h
//  eCarry
//
//  Created by whde on 16/1/11.
//  Copyright © 2016年 whde. All rights reserved.
//
// GitHub:https://github.com/whde/Loop
#import <UIKit/UIKit.h>

@interface CLoopCell : UIControl
// 根据每个Frame和model创建视图
- (instancetype)initWith:(id)model withScrollViewFrame:(CGRect)rect;
// 根据model刷新试图
- (void)reloadWith:(id)model;
@end
