//
//  MainPageModel.h
//  Legend
//
//  Created by 梅毅 on 2017/3/28.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property (nonatomic, strong)NSString   *goods_id;
@property (nonatomic, strong)NSString   *goods_img;
@property (nonatomic, assign)BOOL       is_endorse;
@property (nonatomic, strong)NSString   *banner_img;
@property (nonatomic, strong)NSString   *target_url;

@end

@interface GoodsCategoryModel : NSObject

@property (nonatomic, strong)NSString   *cat_id;
@property (nonatomic, strong)NSString   *cat_name;
@property (nonatomic, strong)NSString   *parent_id;
@property (nonatomic, strong)NSString   *path;
@property (nonatomic, strong)NSString   *category_img;
@property (nonatomic, strong)NSString   *sell_count;

@end

@interface GoodsRecommendModel : NSObject

@property (nonatomic, strong) NSString  *goods_id;
@property (nonatomic, strong) NSString  *goods_name;
@property (nonatomic, strong) NSString  *goods_thumb;
@property (nonatomic, strong) NSString  *shop_price;
@property (nonatomic, strong) NSString  *sell_count;
@property (nonatomic, strong) NSString  *is_endorse;

@end

@interface MainPageModel : NSObject

@property (nonatomic, strong) NSString   *unread_num;
@property (nonatomic, strong) NSString   *goods_recommand_total_page;
@property (nonatomic, strong) NSString   *add_income;
@property (nonatomic, strong) NSArray <BannerModel *> *banner_goods_list;
@property (nonatomic, strong) NSArray <GoodsRecommendModel *> *goods_recommand_list;
@property (nonatomic, strong) NSDictionary *goods_category_list;

+(void)loadDataWithHomePage:(NSDictionary *)parameter
                    success:(void (^)(MainPageModel *))mainPageModel
                     failed:(void (^)(NSDictionary *errorCode))errorInfo;

@end
