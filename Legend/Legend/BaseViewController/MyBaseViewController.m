//
//  MyBaseViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyBaseViewController.h"
#import "SearchGoodsViewController.h"
#import "NotificationViewController.h"

@interface MyBaseViewController ()<UISearchBarDelegate>

@end

@implementation MyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
}
-(void)initNavigationBar
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"请输入商品名称";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"systemnotice"] style:UIBarButtonItemStylePlain target:self action:@selector(systemNoticeBtn:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)systemNoticeBtn:(UIButton *)button
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    notificationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notificationVC animated:YES];
}
#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchGoodsViewController *searchGoodsVC = [[SearchGoodsViewController alloc] init];
    searchGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchGoodsVC animated:YES];
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
