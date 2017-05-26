//
//  ReceiveAddressModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveAddressModel : NSObject

@property (nonatomic, strong)NSString   *address_id;
@property (nonatomic, strong)NSString   *consignee;
@property (nonatomic, strong)NSString   *address;
@property (nonatomic, strong)NSString   *area_id;
@property (nonatomic, strong)NSString   *area;
@property (nonatomic, strong)NSString   *street;
@property (nonatomic, strong)NSString   *mobile;
@property (nonatomic, strong)NSString   *is_default;

@property (nonatomic, strong)NSString   *provice;
@property (nonatomic, strong)NSString   *city;
@property (nonatomic, strong)NSString   *distrct;
@property (nonatomic, strong)NSNumber   *lng;
@property (nonatomic, strong)NSNumber   *lat;

@end

@interface ReceiveAddressModel (NetworkParser)

+ (ReceiveAddressModel *)parseResponse:(id)response;

+ (NSArray <ReceiveAddressModel *> *)parseArrayResponse:(id)response;

@end
