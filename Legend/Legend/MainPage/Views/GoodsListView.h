//
//  GoodsListView.h
//  Legend
//
//  Created by 梅毅 on 2017/3/27.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListView : UIView

@property (nonatomic, strong) NSDictionary      *goodsData;

-(instancetype)initWithFrame:(CGRect)frame :(UIViewController *)andViewController;

@end
