//
//  ReceiveAddressModel.m
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ReceiveAddressModel.h"

@implementation ReceiveAddressModel

@end
@implementation ReceiveAddressModel (NetworkParser)

+ (ReceiveAddressModel *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *addressDic = [response objectForKey:@"address"];
        if (addressDic) {
            ReceiveAddressModel *address = [[ReceiveAddressModel alloc] init];
            address.consignee = [addressDic objectForKey:@"name"];
            address.address_id = [addressDic objectForKey:@"address_id"];
            address.mobile = [addressDic objectForKey:@"tel"];
            address.area_id = [addressDic objectForKey:@"area_id"];
            address.area = [addressDic objectForKey:@"area"];
            address.address = [addressDic objectForKey:@"address"];
            return address;
        }
    }
    return nil;
}

+ (NSArray <ReceiveAddressModel *> *)parseArrayResponse:(id)response {
    NSArray *arr = [ReceiveAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"address_list"]];
    return arr;
}
@end
