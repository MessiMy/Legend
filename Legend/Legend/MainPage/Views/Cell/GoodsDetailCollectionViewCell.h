//
//  GoodsDetailCollectionViewCell.h
//  Legend
//
//  Created by 梅毅 on 2017/3/28.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView       *productImg; //代言图片
@property (nonatomic, strong) UILabel           *name;      //代言产品名称
@property (nonatomic, strong) UILabel           *price;     //代言产品价格
@property (nonatomic, strong) UILabel           *saleNumber;//销量
@property (nonatomic, strong) UILabel           *markLable; //代言标签
@property (nonatomic, strong) UIView            *markView;  //推荐代言的标签

@end
