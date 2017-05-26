//
//  MyOrderTableViewCell.m
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.checkDetail setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.checkDetail addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)btnAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myOrderCell:didClickedActionBtn:)]) {
        [self.delegate myOrderCell:self didClickedActionBtn:button];
    }
}
@end
