//
//  MyOrderTableViewCell.h
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderTableViewCell;

@protocol MyOrderTableViewDelegate <NSObject>

- (void)myOrderCell:(MyOrderTableViewCell *)cell didClickedActionBtn:(UIButton *)button;

@end

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsState;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoney;
@property (weak, nonatomic) IBOutlet UIButton *checkDetail;

@property (nonatomic, weak) id<MyOrderTableViewDelegate>delegate;

@end
