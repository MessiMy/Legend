//
//  SellerModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/25.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerModel : NSObject

@property (nonatomic, assign)NSInteger      seller_id;
@property (nonatomic, strong)NSString       *seller_name;
@property (nonatomic, strong)NSString       *thumb_img;
@property (nonatomic, strong)NSString       *backup_img;
@property (nonatomic, assign)BOOL           col_flag;
@property (nonatomic, assign)NSInteger      collect_count;
@property (nonatomic, strong)NSString       *collect_id;
@property (nonatomic, assign)CGFloat        dividend_price;
@property (nonatomic, assign)CGFloat        com_money;
@property (nonatomic, strong)NSString       *telephone;
@property (nonatomic, strong)NSString       *address;
@property (nonatomic, strong)NSString       *after_address;

@property (nonatomic, assign)CGFloat        price_distance;
@property (nonatomic, assign)CGFloat        seller_fee;

@end

@interface SellerModel (NetworkParser)

+ (SellerModel *)paraseResponse:(id)response;
+ (NSArray <SellerModel *>*)paraseSellerList:(id)response;
+ (NSInteger)paraseCollectCountResponse:(id)response;

@end
