//
//  ShoppingCarItemModel.h
//  Legend
//
//  Created by 梅毅 on 2017/6/1.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SellerModel;
@class GoodsModel;


@interface ShoppingCarItemModel : NSObject

@property (nonatomic, strong)SellerModel *seller;
@property (nonatomic, strong)NSArray<GoodsModel *>     *goods_list;

@end
@interface ShoppingCarItemModel (NetworkParser)

+ (NSArray<ShoppingCarItemModel *> *)parseResponse:(id)response;

@end
