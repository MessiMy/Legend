//
//  CommodityListViewPage.m
//  Legend
//
//  Created by 梅毅 on 2017/5/4.
//  Copyright © 2017年 my. All rights reserved.
//

#import "CommodityListViewPage.h"
#import "GoodsModel.h"
#import "CommodityTableViewCell.h"
#import "CommodityCollectionViewCell.h"
#import "BannerView.h"
#import "ProductDetailPage.h"

@interface CommodityListViewPage ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BannerViewDelegate>

@property (nonatomic, strong) GoodsModel        *goodsModel;
@property (nonatomic, strong) NSMutableArray    *goodsArr;
@property (nonatomic, assign) NSInteger         maxPageIndex;
@property (nonatomic, assign) NSInteger         pageIndex;
@property (nonatomic, assign) NSInteger         titleIndex;
@property (nonatomic, assign) BOOL              isButtonSelected;
@property (nonatomic, strong) BannerView        *bannerView;

@end

@implementation CommodityListViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.text = self.goodsName;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"changeStyleTableView"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    self.commodityTableView.hidden = YES;
    self.commodityTableView.scrollsToTop = YES;
    self.commodityTableView.tableFooterView = [UIView new];
    self.commodityTableView.backgroundColor = [UIColor clearColor];
    self.commodityTableView.separatorColor = [UIColor grayColor];
    [self.commodityTableView registerNib:[UINib nibWithNibName:@"CommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommodityTableViewCell"];
    self.commodityTableView.rowHeight = 108;
    
    self.commodityCollectionView.hidden = NO;
    self.commodityCollectionView.scrollsToTop = YES;
    self.commodityCollectionView.backgroundColor = [UIColor clearColor];
    [self.commodityCollectionView registerNib:[UINib nibWithNibName:@"CommodityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CommodityCollectionViewCell"];
    
    
    self.pageIndex = 1;
    self.isButtonSelected = YES;
    self.goodsModel = [[GoodsModel alloc] init];
    self.goodsArr = [NSMutableArray array];
    
    NSDictionary *parameter = nil;
    if (self.isFromShoppingMallView) {
        parameter = @{@"device_id":[MyTools getDeviceUUID],@"cat_id":self.categoryID};
        [self requetForCommodityData:parameter];
    }
    else if (self.isFromSellerView)
    {
        parameter = @{@"device_id":[MyTools getDeviceUUID],@"keyword":self.goodsName,@"seller_id":self.sellerID};
        [self requetForCommodityData:parameter];
    }
    else if (self.isFromSearchView)
    {
        parameter = @{@"device_id":[MyTools getDeviceUUID],@"keyword":self.goodsName};
        [self requetForCommodityData:parameter];
    }
}
-(void)rightButtonClicked:(UIBarButtonItem *)button
{
    if (self.isButtonSelected) {
        [button setImage:[UIImage imageNamed:@"changeStyle"]];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"changeStyleTableView"]];
    }
    self.isButtonSelected = !self.isButtonSelected;
    self.commodityCollectionView.hidden = !self.commodityCollectionView.hidden;
    self.commodityTableView.hidden = !self.commodityTableView.hidden;
}
-(void)requetForCommodityData:(NSDictionary *)parameter
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.goodsArr removeAllObjects];
    [MainRequest RequestHTTPData:PATHShop(@"Api/Goods/searchGoods") parameters:parameter success:^(id response) {
        NSArray *arr = [GoodsModel parseResponse:response];
        self.pageIndex = 1;
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        for (GoodsModel *model in arr) {
            [self.goodsArr addObject:model];
        }
        self.commodityNoGoodsView.hidden = self.goodsArr.count > 0;
        [self.commodityTableView reloadData];
        [self.commodityCollectionView reloadData];
        [hud hideAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [hud hideAnimated:YES];
    }];
}
#pragma mark - UITableViewDelegate&&UITableViewDatasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *model = self.goodsArr[indexPath.row];
    
    CommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommodityTableViewCell"];
    [cell.goodsImg setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    cell.goodsName.text = model.goods_name;
    cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - UICollectionViewDatasource&&UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *model = self.goodsArr[indexPath.row];
    CommodityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommodityCollectionViewCell" forIndexPath:indexPath];
    [cell.goodsImg setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    cell.goodsName.text = model.goods_name;
    cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((DeviceMaxWidth - 15)/2, 261);
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailPage *productDetailPage = [[ProductDetailPage alloc] init];
    productDetailPage.hidesBottomBarWhenPushed = YES;
    GoodsModel *model = self.goodsArr[indexPath.row];
    productDetailPage.goods_id = model.goods_id;
    productDetailPage.is_endorse = [model.is_endorse integerValue];
    [self.navigationController pushViewController:productDetailPage animated:YES];
}
#pragma mark - BannerViewDelegate
- (void)BannerView:(BannerView *)bannerView didSelectBtton:(UIButton *)button
{
    
}
@end
