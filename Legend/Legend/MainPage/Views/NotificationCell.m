//
//  NotificationCell.m
//  Legend
//
//  Created by 梅毅 on 2017/3/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.image = [UIImage imageNamed:@"home_Solar_system"];
    self.title.text = @"系统消息";
    self.dateLab.text = [NSString stringWithFormat:@"%@",[NSDate date]];
    self.detailText.text = @"hsihfhih";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
