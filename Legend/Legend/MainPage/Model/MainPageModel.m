//
//  MainPageModel.m
//  Legend
//
//  Created by 梅毅 on 2017/3/28.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MainPageModel.h"


@implementation MainPageModel

+(void)loadDataWithHomePage:(NSDictionary *)parameter success:(void (^)(MainPageModel *))mainPageModel failed:(void (^)(NSDictionary *))errorInfo
{
    NSLog(@"%@",PATHShop(@"api/Goods/getHomeInfo"));
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getHomeInfo") parameters:parameter success:^(id responseData){
        MainPageModel *returnModel = [MainPageModel mj_objectWithKeyValues:responseData];
        returnModel.banner_goods_list = [BannerModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"banner_goods_list"]];
        returnModel.goods_category_list = [responseData objectForKey:@"goods_category_list"];
        returnModel.goods_recommand_list = [GoodsRecommendModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"goods_recommend_list"]];
        mainPageModel(returnModel);
    } failed:^(NSDictionary *error){
        errorInfo(error);
    }];
}

@end
@implementation BannerModel

@end

@implementation GoodsCategoryModel

@end

@implementation GoodsRecommendModel

@end
