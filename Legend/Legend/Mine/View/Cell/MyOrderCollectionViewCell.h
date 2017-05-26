//
//  MyOrderCollectionViewCell.h
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UILabel *noOrderLab;
@property (weak, nonatomic) IBOutlet UIImageView *noOrderImg;

@end
