//
//  CommodityTableViewCell.h
//  Legend
//
//  Created by 梅毅 on 2017/5/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end
