//
//  MyWalletHeadView.m
//  Legend
//
//  Created by 梅毅 on 2017/5/25.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyWalletHeadView.h"

@implementation MyWalletHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.getMoneyBtn.layer.cornerRadius = 4;
    self.getMoneyBtn.layer.masksToBounds = YES;
    self.getMoneyBtn.layer.borderWidth = 1;
    self.getMoneyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
