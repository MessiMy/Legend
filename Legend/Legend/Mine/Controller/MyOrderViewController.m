//
//  MyOrderViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyOrderViewController.h"
#import "SwitchView.h"
#import "MyOrderCollectionViewCell.h"
#import "OrderModel.h"
#import "MyOrderTableViewCell.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SwitchViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SwitchView        *switchView;
@property (nonatomic, strong) NSArray           *titles;
@property (nonatomic, strong) NSArray           *orders;
@property (nonatomic, strong) NSMutableArray    *firstAppearIndex;
@property (nonatomic, strong) NSMutableArray    *maxPages;
@property (nonatomic, strong) NSMutableArray    *pages;
//@property (nonatomic, assign) NSInteger         pageIndex;

@end


@implementation MyOrderViewController

-(SwitchView *)switchView
{
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 35) titles:self.titles pageIndex:self.pageIndex];
        _switchView.delegate = self;
    }
    return _switchView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _titles = @[@"全部",@"待付款",@"待收货",@"待评价",@"售后"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SearchWhite"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self.view addSubview:self.switchView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyOrderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyOrderCollectionViewCell"];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        [temp addObject:[NSArray array]];
    }
    self.orders = [temp copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 搜索按钮按下
- (void)searchBtnClicked:(UIButton *)button
{
    
}
#pragma mark - UICollectionViewDelegate&&UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.titles.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyOrderCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.orderTableView.rowHeight = 40;
    cell.orderTableView.sectionHeaderHeight = 0;
    cell.orderTableView.sectionFooterHeight = 10;
    cell.orderTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    cell.orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    cell.orderTableView.backgroundColor = [UIColor clearColor];
    cell.orderTableView.separatorColor = [UIColor seperateColor];
    cell.orderTableView.tag = indexPath.row;
    [cell.orderTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderCollectionViewCell *myCell = (MyOrderCollectionViewCell *)cell;
    NSArray *orders = [self.orders objectAtIndex:indexPath.row];
    myCell.noOrderImg.hidden = orders.count > 0;
    myCell.noOrderLab.hidden = orders.count > 0;
    myCell.orderTableView.hidden = !orders.count;
    [myCell.orderTableView reloadData];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 99);
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.collectionView == scrollView && (self.collectionView.isDragging || self.collectionView.isDecelerating)) {
        if (scrollView.contentSize.width != 0) {
            CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
            [self.switchView scrollViewDidScrollPercent:percent];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.collectionView == scrollView) {
        NSInteger pageIndex = ceil(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
        pageIndex = MAX(0, pageIndex);
        pageIndex = MIN(pageIndex, self.titles.count - 1);
        if (self.pageIndex == pageIndex) {
            return;
        }
        self.pageIndex = pageIndex;
        UIButton *btn = [self.switchView viewWithTag:10 + self.pageIndex];
        [self.switchView headBtnClicked:btn];
    }
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *orders = [self.orders objectAtIndex:tableView.tag];
    return  orders.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *orders = [self.orders objectAtIndex:tableView.tag];
    OrderModel *model = [orders objectAtIndex:indexPath.row];
    GoodsModel *goods = [model.order_goods firstObject];
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    [cell.goodsImg setImageWithURL:[NSURL URLWithString:goods.goods_thumb]];
    cell.goodsName.text = goods.goods_name;
    cell.goodsCount.text = [NSString stringWithFormat:@"X%ld",(long)goods.goods_number];
    cell.goodsMoney.text = [NSString stringWithFormat:@"¥%@",model.order_money];
    cell.goodsState.text = [NSString stringWithFormat:@"状态：%@", [self getOrderStatusDescByOrder:model]];
    [cell.checkDetail setTitle:[self getActionBtnTitleByOrder:model] forState:UIControlStateNormal];
    return cell;
}
#pragma mark - SwitchViewDelegate
- (void)switchView:(SwitchView *)switchView didSelectAtIndex:(NSInteger)index
{
    self.pageIndex = index;
    [UIView animateWithDuration:0.5 animations:^{
        [self.collectionView setContentOffset:CGPointMake(self.pageIndex*DeviceMaxWidth, self.collectionView.contentOffset.y)];
    }completion:^(BOOL finished){
        
    }];
}
- (NSString *)getOrderStatusDescByOrder:(OrderModel *)order {
    if (order.is_after == 1) {
        return @"申请退款中";
    } else if (order.is_after == 2) {
        return @"退款已完成";
    } else if (order.is_after == 3) {
        return @"退款关闭";
    }
    NSInteger orderStatus = [order.order_status integerValue];
    NSString *desc = nil;
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    switch (orderStatus) {
        case 0:{
            desc = @"待付款";
            break;
        }
        case 1:{
            desc = @"待收货";
            break;
        }
        case 2:{
            desc = @"待收货";
            break;
        }
        case 3:{
            desc = @"待评价";
            break;
        }
        case 4:{
            desc = @"已完成";
            break;
        }
        case 5:{
            desc = @"退款已完成";
            break;
        }
        case 6:{
            desc = @"已取消";
            break;
        }
        case 7:{
            desc = @"已取消";
            break;
        }
        case 8:{
            desc = @"充值失败";
            break;
        }
        default:
            break;
    }
    return desc;
}
- (NSString *)getActionBtnTitleByOrder:(OrderModel *)order {
    NSInteger orderStatus = [order.order_status integerValue];
    NSString *desc = @"查看详情";
    if (order.is_after > 0 && (self.switchView.currentIndex == 0 || self.switchView.currentIndex == 4)) {
        return desc;
    }
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    if (orderStatus == 0) {
        desc = @"付款";
    } else if (orderStatus == 1 || orderStatus == 2) {
        desc = @"确认收货";
    } else if (orderStatus == 3) {
        desc = @"去评价";
    }
    return desc;
}
@end
