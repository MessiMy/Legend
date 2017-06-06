//
//  CommodityCollectionViewCell.m
//  Legend
//
//  Created by 梅毅 on 2017/5/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import "CommodityCollectionViewCell.h"

@implementation CommodityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 1;
    self.clipsToBounds = NO;
}

@end
