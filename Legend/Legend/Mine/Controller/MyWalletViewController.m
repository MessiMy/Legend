//
//  MyWalletViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/25.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletHeadView.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myIncomeTableView;
@property (nonatomic, strong)        MyWalletHeadView      *headView;
@property (nonatomic, strong)        NSMutableArray         *dataArr;
@property (nonatomic, strong)        NSArray                *dealData;

@end

@implementation MyWalletViewController
#pragma mark - 懒加载
- (MyWalletHeadView *)headView
{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"MyWalletHeadView" owner:self options:nil] lastObject];
        _headView.frame = CGRectMake(0, 0, DeviceMaxWidth, 200);
    }
    return _headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"我的收益" style:UIBarButtonItemStylePlain target:self action:@selector(myIncome)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self.dataArr addObject:@[@"银行卡管理"]];
    self.myIncomeTableView.showsVerticalScrollIndicator = NO;
    self.myIncomeTableView.showsHorizontalScrollIndicator = NO;
    self.myIncomeTableView.tableHeaderView = self.headView;
    //self.myIncomeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.01)];
    [self.myIncomeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyWalletCell"];
}

- (void)myIncome
{
    
}
#pragma mark - UITableViewDelegate && UITabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyWalletCell"];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = @"银行卡管理";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"交易明细";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
@end
