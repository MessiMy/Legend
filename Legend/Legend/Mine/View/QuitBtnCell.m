//
//  QuitBtnCell.m
//  Legend
//
//  Created by 梅毅 on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import "QuitBtnCell.h"

@implementation QuitBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.QuitBtn.layer.cornerRadius = 6;
    self.QuitBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)QuitBtnClicked:(id)sender
{
    [self.delegate QuitBtnClicked];
}

@end
