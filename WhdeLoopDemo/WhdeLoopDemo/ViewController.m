//
//  ViewController.m
//  WhdeLoopDemo
//
//  Created by whde on 16/5/16.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "ViewController.h"

#import "CLoopScrollView.h"
#import "CBannerLoopCell.h"
@interface ViewController ()
@property (nonatomic, strong) CLoopScrollView *topView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Banner滚动视图
    _topView = [[CLoopScrollView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*0.5) scrollDirection:LoopScrollViewScrollDirectionLandscape models:@[@"",@"",@"",@"",@"",@""] ofCellClass:[CBannerLoopCell class]];
    [_topView setRollingDelayTime:4.0];
    [_topView setSquare:0];
    [self.view addSubview:_topView];
    [_topView setBackgroundColor:[UIColor lightGrayColor]];
    
    /*// 页数展示
    _topPage = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, CGRectGetHeight(_topView.frame)-50, 45, 45)];
    _topPage.backgroundColor = [UIColor clearColor];
    _topPage.layer.masksToBounds = YES;
    _topPage.font = Content_Sub_Font_12;
    _topPage.textAlignment = NSTextAlignmentCenter;
    _topPage.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)[_model.topArr count]];
    _topPage.textColor = [UIColor colorWithHexString:SYSTEM_COLOR_WHITE];
    [header addSubview:_topPage];
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:_topPage.frame];// 页数背景
    bgImg.image = [UIImage imageNamed:@"hslx_main_黑色菱形.png"];
    bgImg.contentMode = UIViewContentModeScaleToFill;
    bgImg.backgroundColor = [UIColor clearColor];
    bgImg.alpha = 0.7;
    [header insertSubview:bgImg belowSubview:_topPage];*/
    
    /*maxY = CGRectGetMaxY(_topView.frame);*/
    /*__block UILabel *weekTopPage = _topPage;*/
    [_topView setScrollBlock:^(CLoopScrollView *loopScrollView, NSInteger index, id model) {
        /*weekTopPage.text = [NSString stringWithFormat:@"%d/%lu", (int)index+1, (unsigned long)[loopScrollView.models count]];*/
    }];// 滚动
    /*__block ViewController *weekSelf = self;*/
    [_topView setSelectBlock:^(CLoopScrollView *loopScrollView, CLoopCell *view, NSInteger index, id model) {
        /*[weekSelf openTopWithModel:model];*/
    }];// 点击

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
