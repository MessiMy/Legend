//
//  GoodsAttrModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsAttrModel : NSObject

@property (nonatomic, assign) NSInteger attr_id;
@property (nonatomic, strong) NSString *attr_name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger goods_number;

@end
