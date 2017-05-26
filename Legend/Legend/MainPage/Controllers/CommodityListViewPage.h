//
//  CommodityListViewPage.h
//  Legend
//
//  Created by 梅毅 on 2017/5/4.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyBaseViewController.h"

@interface CommodityListViewPage : MyBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *commodityTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *commodityCollectionView;
@property (weak, nonatomic) IBOutlet UIView *commodityNoGoodsView;
@property (nonatomic,strong)         NSString   *goodsName;
@property (nonatomic,strong)         NSString   *sellerID;
@property (nonatomic,strong)         NSString   *categoryID;
@property (nonatomic,assign)         BOOL       isFromSearchView;
@property (nonatomic,assign)         BOOL       isFromSellerView;
@property (nonatomic,assign)         BOOL       isFromShoppingMallView;

@end
