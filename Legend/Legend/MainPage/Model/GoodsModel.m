//
//  GoodsModel.m
//  Legend
//
//  Created by 梅毅 on 2017/5/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

@end
@implementation GoodsModel (NetworkParser)

+(NSArray<GoodsModel *> *)parseResponse:(id)response
{
    NSArray *goodsListArr = [GoodsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"goods_list"]];
    return goodsListArr;
}
+(NSArray<GoodsModel *> *)parseCollectResponse:(id)response
{
    NSArray *goodsListArr = [GoodsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"collect_list"]];
    return goodsListArr;
}
+ (GoodsModel *)parsePOSResponse:(id)response {
    GoodsModel *goods = [GoodsModel mj_objectWithKeyValues:response];
    goods.shop_price = [response objectForKey:@"market_price"];
    goods.price = [response objectForKey:@"apply_price"];
    return goods;
}
@end
