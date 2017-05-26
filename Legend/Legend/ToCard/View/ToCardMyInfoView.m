//
//  ToCardMyInfoView.m
//  Legend
//
//  Created by 梅毅 on 2017/5/9.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ToCardMyInfoView.h"

@implementation ToCardMyInfoView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = 40;
    self.avatar.layer.masksToBounds = YES;
}

@end
