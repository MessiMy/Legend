//
//  OrderModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProducrModel.h"
#import "GoodsModel.h"
#import "ReceiveAddressModel.h"

@interface SellerInfoModel : NSObject

@property (nonatomic, strong)NSString       *seller_id;
@property (nonatomic, strong)NSString       *seller_name;
@property (nonatomic, strong)NSString       *address;
@property (nonatomic, strong)NSString       *telephone;
@property (nonatomic, strong)NSString       *backup_img;
@property (nonatomic, strong)NSString       *thunb_img;

@end

@interface OrderModel : NSObject

@property (nonatomic, strong)NSString       *order_id;//订单id
@property (nonatomic, strong)NSString       *order_number;//订单号
@property (nonatomic, strong)NSString       *order_money;//订单价格
@property (nonatomic, strong)NSString       *order_status;

@property (nonatomic, strong)NSString       *shipping_fee;//
@property (nonatomic, strong)NSString       *create_time;
@property (nonatomic, strong)NSString       *range_time;
@property (nonatomic, strong)NSString       *pay_time;
@property (nonatomic, strong)NSString       *shipping_time;
@property (nonatomic, strong)NSString       *shipping_number;
@property (nonatomic, strong)NSString       *confirm_receipt_time;
@property (nonatomic, strong)NSString       *complete_time;
@property (nonatomic, strong)NSString       *goods_amount;
@property (nonatomic, strong)NSString       *share_money;
@property (nonatomic, strong)NSNumber       *pay_type;
@property (nonatomic, strong)SellerInfoModel*seller_info;

@property (nonatomic, strong)NSArray<ProducrModel *>    *goods_list;
@property (nonatomic, strong)NSArray<GoodsModel *>      *order_goods;

@property (nonatomic, strong)NSString       *order_type;
@property (nonatomic, strong)NSString       *complete_status;
//--address
@property (nonatomic, strong)NSString       *ad_id;
@property (nonatomic, assign)BOOL           is_endorse;
@property (nonatomic, assign)NSInteger      is_after;

@property (nonatomic, strong)NSString       *need_note;

@property (nonatomic, strong)ReceiveAddressModel    *address;
//@property (nonatomic, strong)

- (NSString *)dateStr;

@end

@interface OrderModel (NetworkParser)

+ (NSArray <OrderModel *> *)paraseResponse:(id)response;
+ (NSArray <OrderModel *> *)parseOrderListResponse:(id)response;
+ (OrderModel *)parseOrderDetailResponse:(id)response;

@end
