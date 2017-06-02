//
//  SearchGoodsViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"

@class SearchGoodsViewController;
@protocol SearchGoodsResultDelegate <NSObject>

- (void)searchGoodsViewController:(SearchGoodsViewController *)searchVC didSearchText:(NSString *)text;

@end

@interface SearchGoodsViewController : BaseViewController

@property (nonatomic, strong)NSString   *searchText;
@property (nonatomic, weak)id<SearchGoodsResultDelegate>delegate;

@end
