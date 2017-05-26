//
//  SellerModel.m
//  Legend
//
//  Created by 梅毅 on 2017/5/25.
//  Copyright © 2017年 my. All rights reserved.
//

#import "SellerModel.h"

@implementation SellerModel

@end
@implementation SellerModel (NetworkParser)

+ (SellerModel *)paraseResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [SellerModel mj_objectWithKeyValues:[response objectForKey:@"selller_info"]];
    }
    return nil;
}
+ (NSArray<SellerModel *> *)paraseSellerList:(id)response
{
    NSArray *arr = [SellerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"shop_collect_list"]];
    return arr;
}
+ (NSInteger)paraseCollectCountResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [[response objectForKey:@"collect_count"] integerValue];
    }
    return 0;
}
@end
