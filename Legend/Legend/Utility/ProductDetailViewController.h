//
//  ProductDetailViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"
#import "ProducrModel.h"

@interface ProductDetailViewController : BaseViewController

@property (nonatomic, strong) NSString  *goods_id;
@property (nonatomic, assign) BOOL      is_endorse;
@property (nonatomic, strong) NSString  *ad_id;
@property (nonatomic, strong) ProducrModel *currentModel;
@property (nonatomic, assign) BOOL      isToCard;

- (void)continueDealBuy;

@end
