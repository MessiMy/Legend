//
//  TitleTableViewCell.m
//  Legend
//
//  Created by 梅毅 on 2017/5/3.
//  Copyright © 2017年 my. All rights reserved.
//

#import "TitleTableViewCell.h"

@implementation TitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.orengeBar.hidden = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.orengeBar.hidden = YES;
        self.contentView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    }
}

@end
