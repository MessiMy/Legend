//
//  SettingViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoTableViewCell.h"
#import "QuitBtnCell.h"
#import "UpdatePasswordViewController.h"
#import "SetPayKeyViewController.h"
#import "UserDelegateViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,QuitBtnCellDelegate>

@property(nonatomic, strong) NSArray    *cellTitles;
@property(nonatomic, strong) NSString   *removeFileSize;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"应用设置";
    _cellTitles = @[@[@"登陆密码设置",@"支付密码设置"],@[@"用户协议",@"关于我们"],@[@"清除缓存",@"检查更新",@"客户电话"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 240)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingViewControllerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QuitBtnCell" bundle:nil] forCellReuseIdentifier:@"QuitBtnCell"];
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat size = [self folderSizeAtMainPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtMainPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtMainPath:NSTemporaryDirectory()];
    self.removeFileSize = size > 1?[NSString stringWithFormat:@"缓存%.2fM",size]:[NSString stringWithFormat:@"缓存%.2fK",size * 1024.0];
    //pop返回tableView时自动取消选中状态
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
- (CGFloat)folderSizeAtMainPath:(NSString *)path
{
    NSFileManager *fielMg = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([fielMg fileExistsAtPath:path]) {
        NSArray *childrenFile = [fielMg subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [fielMg attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellTitles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.cellTitles[section];
    if (section == 2) {
        return arr.count+1;
    }
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 3) {
        QuitBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuitBtnCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([MyTools isLogin]) {
            cell.QuitBtn.hidden = NO;
        }
        else
        {
            cell.QuitBtn.hidden = YES;
        }
        return cell;
    }
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewControllerCell"];
    cell.nameLab.text = self.cellTitles[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        cell.arrowImg.hidden = YES;
        if (indexPath.row == 0) {
            cell.detailLab.text = self.removeFileSize;
        }
        else if(indexPath.row == 1)
        {
            cell.detailLab.text = @"版本";
        }
        else if (indexPath.row == 2)
        {
            cell.detailLab.textColor = [UIColor orangeColor];
            cell.detailLab.text = @"028-61384228";
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 3) {
        if (DeviceMaxWidth == 320) {
            return 90*0.85;
        }
        return 90;
    }
    else
    {
        return 45;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if ([MyTools isLogin]) {
                UpdatePasswordViewController *updatePWPage = [[UpdatePasswordViewController alloc] init];
                updatePWPage.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:updatePWPage animated:YES];
            }
            else
            {
                [self showLoginViewController];
            }
        }
        else if (indexPath.row == 1)
        {
            if ([MyTools isLogin]) {
                if ([MyTools isPayPassword]) {
                    UpdatePasswordViewController *updatepwdVC = [[UpdatePasswordViewController alloc] init];
                    updatepwdVC.hidesBottomBarWhenPushed = YES;
                    updatepwdVC.isFromPayKeySetView = YES;
                    [self.navigationController pushViewController:updatepwdVC animated:YES];
                }
                else
                {
                    SetPayKeyViewController *setPayPwdPage = [[SetPayKeyViewController alloc] init];
                    setPayPwdPage.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setPayPwdPage animated:YES];
                }
            }
            else
            {
                [self showLoginViewController];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            UserDelegateViewController *userDelegatePage = [[UserDelegateViewController alloc] init];
            userDelegatePage.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userDelegatePage animated:YES];
        }
        else if (indexPath.row == 1)
        {
            AboutUsViewController *aboutUsPage = [[AboutUsViewController alloc] init];
            aboutUsPage.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsPage animated:YES];
        }
    }
    else if (indexPath.section)
    {
        if (indexPath.row == 0) {
            [self showHUDWithMessage:@"清理缓存中"];
            [self removeCacheAct];
        }
        else if (indexPath.row == 1)
        {
            
        }
        else if (indexPath.row == 2)
        {
            UserInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *phone = cell.detailLab.text;
            [MyTools detailPhone:phone];
        }
    }
}
#pragma mark - QuitBtnCellDelegate
-(void)QuitBtnClicked
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile] isEqualToString:@""]) {
        [self showHUDWithMessage:nil];
        return;
    }
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"token":[MyTools getUserToken]
                                 };
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/user/logout") parameters:parameters success:^(id response) {
        [self hideHUD];
        [MyTools clearUserLocalData];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
        [MyTools clearUserLocalData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)removeCacheAct
{
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSTemporaryDirectory()];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHUDWithResult:YES message:@"清理成功" completion:nil];
        self.removeFileSize = @"暂无缓存";
        [self.tableView reloadData];
    });
}
- (void)cleanCaches:(NSString *)path
{
    NSFileManager *fileMg = [NSFileManager defaultManager];
    if ([fileMg fileExistsAtPath:path]) {
        //获取该路径下的文件名
        NSArray *childrenFiles = [fileMg subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            //拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            //将文件删除
            [fileMg removeItemAtPath:absolutePath error:nil];
        }
    }
}
@end
