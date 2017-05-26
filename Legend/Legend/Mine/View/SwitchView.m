//
//  SwitchView.m
//  Legend
//
//  Created by 梅毅 on 2017/5/23.
//  Copyright © 2017年 my. All rights reserved.
//

#import "SwitchView.h"

@interface SwitchView ()

@property (nonatomic, copy)  NSArray      *titles;
@property (nonatomic, strong)UIImageView  *bottomView;
@property (nonatomic, strong)UIImageView  *seperateLine;
//@property (nonatomic, assign)NSInteger    currentIndex;

@end

@implementation SwitchView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles pageIndex:(NSInteger)pageIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = pageIndex;
        _titles = titles;
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
        _seperateLine.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255.0 blue:220.0/255.0 alpha:0.65];
        //_seperateLine.alpha = 0.5;
        //_currentIndex = 0;
        [self addSubview:_seperateLine];
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width/self.titles.count, 1)];
        _bottomView.backgroundColor = [UIColor redColor];
        [self addSubview:_bottomView];
        
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    for (int index = 0; index < self.titles.count; index++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.bounds.size.width/self.titles.count*index, 0, self.bounds.size.width/self.titles.count, self.bounds.size.height-1);
        btn.tag = 10 + index;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:self.titles[index] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    UIButton *btn = [self viewWithTag:10 + self.currentIndex];
    [self headBtnClicked:btn];
}
- (void)scrollViewDidScrollPercent:(CGFloat)percent {
    if (percent >= 0 && percent <= (1.0/self.titles.count) * (self.titles.count - 1)) {
        CGRect frame = self.bottomView.frame;
        frame.origin.x = percent * CGRectGetWidth(self.bounds);
        self.bottomView.frame = frame;
    }
}
- (void)headBtnClicked:(UIButton *)button
{
    _currentIndex = button.tag - 10;
    UIButton *btn = nil;
    for (int i = 0; i < self.titles.count; i++) {
        btn = [self viewWithTag:10+i];
        if (_currentIndex == i) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _bottomView.frame;
        rect.origin.x = rect.size.width * self.currentIndex;
        _bottomView.frame = rect;
    }];
    [self.delegate switchView:self didSelectAtIndex:self.currentIndex];
}
@end
