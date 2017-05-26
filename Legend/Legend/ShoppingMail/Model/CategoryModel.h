//
//  CategoryModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/3.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic,strong) NSString *cat_id;
@property (nonatomic,strong) NSString *cat_name;
@property (nonatomic,strong) NSString *parent_id;
@property (nonatomic,strong) NSString *category_img;
@property (nonatomic,strong) NSString *sell_count;

+(void)loadDataWithOrderDetail:(NSInteger)category_id
                       success:(void(^)(NSMutableArray *shoppingMallArr))shoppingMallList
failed:(void(^)(NSDictionary *errorDic))errorInfo;

@end
