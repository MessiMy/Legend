//
//  MyCollectionViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/25.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "SwitchView.h"
#import "GoodsTableViewCell.h"
#import "GoodsModel.h"
#import "SellerModel.h"


@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchViewDelegate>

@property (nonatomic, strong)SwitchView             *switchView;
@property (nonatomic, strong)NSMutableArray         *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (weak, nonatomic) IBOutlet UIView *noGoodsView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;


@end

@implementation MyCollectionViewController
#pragma mark - 懒加载

- (SwitchView *)switchView
{
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 35) titles:@[@"商品",@"商家"] pageIndex:0];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    [self.view addSubview:self.switchView];
    self.dataArr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentTable.showsVerticalScrollIndicator = NO;
    self.contentTable.showsHorizontalScrollIndicator = NO;
    
    [self.contentTable registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsTableViewCell"];
    [self.contentTable addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.contentTable headerBeginRefreshing];
}
#pragma mark - refresh
- (void)headerRefreshing
{
    [self.dataArr removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[MyTools getUserToken],
                                 @"token":[MyTools getUserToken],
                                 @"type":[NSNumber numberWithInteger:1],
                                 @"last_collect_id":[NSNumber numberWithInteger:0]
                                 };
    [MainRequest RequestHTTPData:PATHShop(@"Api/GoodsCollect/getCollectList") parameters:parameters success:^(id response) {
        [self.contentTable headerEndRefreshing];
        NSArray *dataArr = [GoodsModel parseResponse:response];
        for (GoodsModel *model in [GoodsModel parseCollectResponse:response]) {
            [self.dataArr addObject:model];
        }
        if (dataArr.count == 0) {
            self.noGoodsView.hidden = NO;
            self.contentTable.hidden = YES;
        }
        else
        {
            self.noGoodsView.hidden = YES;
            self.contentTable.hidden = NO;
        }
        [self.contentTable reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败" completion:nil];
        [self.contentTable headerEndRefreshing];
    }];
}
- (void)sellerTableViewHeaderRefreshing
{
    [self.dataArr removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"token":[MyTools getUserToken],
                                 @"last_collect_id":@"0"
                                 };
    [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/getShopCollectList") parameters:parameters success:^(id response) {
        NSArray *dataArray = [SellerModel paraseSellerList:response];
        for (SellerModel *model in dataArray) {
            [self.dataArr addObject:model];
        }
        if (dataArray.count == 0) {
            self.noGoodsView.hidden = NO;
            self.switchView.hidden = YES;
            self.contentTable.hidden = YES;
        }
        else
        {
            self.noGoodsView.hidden = YES;
            self.switchView.hidden = NO;
            self.contentTable.hidden = NO;
        }
        [self.contentTable headerEndRefreshing];
        [self.contentTable reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败" completion:nil];
        [self.contentTable headerEndRefreshing];
    }];
}
#pragma  mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.switchView.currentIndex == 0) {
        return 106;
    }
    return 86;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsTableViewCell"];
    if (self.dataArr.count != 0) {
        GoodsModel *model = [self.dataArr objectAtIndex:indexPath.row];
        [cell.goodsImg setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
        cell.goodsName.text = model.goods_name;
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
        if ([model.recommend_reward isEqualToString:@"0.00"]) {
            cell.directPushBtn.hidden = YES;
        }
    }
    return cell;
}
- (void)switchView:(SwitchView *)switchView didSelectAtIndex:(NSInteger)index
{
    if (index == 0) {
        switchView.currentIndex = index;
    }
    else if (index == 1)
    {
        switchView.currentIndex = index;
    }
    [self.contentTable headerBeginRefreshing];
}

@end
