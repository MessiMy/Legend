//
//  ShoppingCarBottomView.m
//  Legend
//
//  Created by 梅毅 on 2017/6/1.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ShoppingCarBottomView.h"

@implementation ShoppingCarBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.caculateBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.caculateBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor]] forState:UIControlStateDisabled];
}

@end
