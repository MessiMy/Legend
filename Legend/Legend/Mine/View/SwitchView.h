//
//  SwitchView.h
//  Legend
//
//  Created by 梅毅 on 2017/5/23.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchView;
@protocol SwitchViewDelegate <NSObject>

- (void)switchView:(SwitchView *)switchView didSelectAtIndex:(NSInteger)index;

@end

@interface SwitchView : UIView

@property (nonatomic, assign)NSInteger             currentIndex;
@property (nonatomic, weak)  id<SwitchViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles pageIndex:(NSInteger)pageIndex;
- (void)scrollViewDidScrollPercent:(CGFloat)percent;
- (void)headBtnClicked:(UIButton *)button;
@end
