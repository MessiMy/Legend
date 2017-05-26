//
//  CategoryModel.m
//  Legend
//
//  Created by 梅毅 on 2017/5/3.
//  Copyright © 2017年 my. All rights reserved.
//

#import "CategoryModel.h"
#import "MainRequest.h"

@implementation CategoryModel
+(void)loadDataWithOrderDetail:(NSInteger)category_id success:(void (^)(NSMutableArray *))shoppingMallList failed:(void (^)(NSDictionary *))errorInfo
{
    NSDictionary *parameters = [NSDictionary dictionary];
    if (category_id == 0) {
        parameters = @{@"device_id":[MyTools getDeviceUUID]};
    }
    else
    {
        parameters = @{@"device_id":[MyTools getDeviceUUID],@"category_id":[NSNumber numberWithInteger:category_id]};
    }
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getShopHomeInfo") parameters:parameters success:^(id response) {
        NSArray *titleList = [CategoryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"goods_one_list"]];
        NSArray *contentList = [CategoryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"goods_two_list"]];
        NSMutableArray *arrs = [NSMutableArray array];
        [arrs addObject:titleList];
        [arrs addObject:contentList];
        if (shoppingMallList) {
            shoppingMallList(arrs);
        }
    } failed:^(NSDictionary *errorDic) {
        errorInfo(errorDic);
    }];
}
@end
