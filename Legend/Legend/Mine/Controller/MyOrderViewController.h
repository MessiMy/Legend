//
//  MyOrderViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GPOrderIndex)
{
    LWOrderIndexAll = 0,
    LWOrderIndexWillPay,
    LWOrderIndexWillReceive,
    LWOrderIndexWillComment,
    LWOrderIndexCancelled,
};

@interface MyOrderViewController : BaseViewController

@property (nonatomic)NSInteger pageIndex;

@end
