//
//  GoodsModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsAttrModel.h"

@interface GoodsModel : NSObject

@property (nonatomic, strong) NSString  *goods_id;
@property (nonatomic, strong) NSString  *goods_name;
@property (nonatomic, strong) NSString  *shop_price;
@property (nonatomic, strong) NSString  *goods_thumb;
@property (nonatomic, strong) NSString  *sell_count;
@property (nonatomic, strong) NSString  *is_endorse;
@property (nonatomic, strong) NSString  *collect_id;
@property (nonatomic, strong) NSString  *recommend_reward;

//购物车
@property (nonatomic, assign) NSInteger cart_id;
@property (nonatomic, assign) NSInteger goods_number;
@property (nonatomic, assign) NSInteger attr_id;
@property (nonatomic, strong) NSString  *attr_name;
@property (nonatomic, strong) NSString  *price;
@property (nonatomic, assign) NSInteger stock;//库存
@property (nonatomic, assign) BOOL      is_display;//1:未下架，0:已下架
@property (nonatomic, assign) BOOL      is_customize;//是否可定制化
@property (nonatomic ,strong) NSArray<GoodsAttrModel *>*attributes;

//售后
@property (nonatomic, strong) NSString  *after_id;
@property (nonatomic, assign) NSInteger after_status;
@property (nonatomic, strong) NSString  *apply_time;
@property (nonatomic, strong) NSString  *complete_time;
@property (nonatomic, assign) NSInteger is_complete;
@property (nonatomic, assign) NSInteger complete_type;
@property (nonatomic, assign) BOOL      is_tocard;
@property (nonatomic, strong) NSString  *size_id;

@end

@interface GoodsModel (NetworkParser)

+ (NSArray<GoodsModel *> *)parseResponse:(id)response;
+ (NSArray<GoodsModel *> *)parseCollectResponse:(id)response;
+ (GoodsModel *)parsePOSResponse:(id)response;
@end
