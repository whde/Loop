## Loop
无限滚动视图, 适用于Banner的滚动

## 使用说明:
- 1.下载项目,打开项目
- 2.command+B打包Loop.Framework
- 3.将Loop.Framework导入到自己的项目中
<p align="center" >
<img src="https://raw.githubusercontent.com/whde/Alert/master/Alert/CA246576-E925-4195-B0D6-072E7FC1F3D6.jpeg">
</p>
- 4.导入头文件
```objective-c
#import <Loop/CLoopScrollView.h>
#import <Loop/CLoopCell.h>
```
- 5.创建一个继承于CLoopCell的Cell
- 6.实现CLoopCell中的两个方法
例如简单的Banner:
```objective-c
#import "CBannerLoopCell.h"
#import "CTopModel.h"
@interface CBannerLoopCell() {
UIImageView *imgView;
}
@end

@implementation CBannerLoopCell

- (id)initWith:(id)model withScrollViewFrame:(CGRect)rect{
self = [super initWith:model withScrollViewFrame:rect];
imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
imgView.contentMode = UIViewContentModeScaleAspectFill;
imgView.clipsToBounds = YES;
[self addSubview:imgView];
[self reloadWith:model];
return self;
}

- (void)reloadWith:(id)model{
[super reloadWith:model];
NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", ((CTopModel *)model).imageUrl]];
[imgView setImageWithURL:url placeholderImage:nil];
}

@end
```
- 7.创建LoopScrollView并addSubView
```objective-c
_topView = [[CLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.5) scrollDirection:LoopScrollViewScrollDirectionLandscape models:_mainModel.topArray ofCellClass:[CBannerLoopCell class]];
[_topView setRollingDelayTime:4.0];
[_topView setSquare:0];
[header addSubview:_topView];

__block UILabel *weekTopPage = _topPage;
[_topView setScrollBlock:^(CLoopScrollView *loopScrollView, NSInteger index, id model) {
NSLog(@"%d/%lu", (int)index+1, (unsigned long)[loopScrollView.models count]);
}];
__block CViewController *weekSelf = self;
[_topView setSelectBlock:^(CLoopScrollView *loopScrollView, CLoopCell *view, NSInteger index, id model) {
}];
```

