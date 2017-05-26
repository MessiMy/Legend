//
//  HomeViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "HomeViewController.h"
#import "MainPageView.h"
#import "ShoppingMailPage.h"
#import "ToCardPage.h"
#import "ShoppingCar.h"
#import "MinePage.h"
#import "LoginViewController.h"

@interface HomeViewController ()<UITabBarControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}
-(void)initView
{
    //初始化首页
    MainPageView *mainPage = [[MainPageView alloc] init];
    mainPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"homePage_No_Selected"] tag:ModelIndexHome];
    UINavigationController *mainPageNav = [[UINavigationController alloc] initWithRootViewController:mainPage];
    //初始化商城
    ShoppingMailPage *shoppimgMailPage = [[ShoppingMailPage alloc] init];
    shoppimgMailPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"ShoppingMall_No_Selected"] tag:ModelIndexShoppingMall];
    UINavigationController *shoppingMailNav = [[UINavigationController alloc] initWithRootViewController:shoppimgMailPage];
    //初始化空的ToCard
    UIViewController *emptyToCard = [[UIViewController alloc] init];
    emptyToCard.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"TO卡" image:[UIImage new] tag:ModelIndexTOCard];
    UINavigationController *emptyToCardNav = [[UINavigationController alloc] initWithRootViewController:emptyToCard];
    //初始化购物车
    ShoppingCar *shoppingCar = [[ShoppingCar alloc] init];
    shoppingCar.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[UIImage imageNamed:@"ShoppingCart_No_Selected"] tag:ModelIndexShoppingCart];
    UINavigationController *shoppingCarNav = [[UINavigationController alloc] initWithRootViewController:shoppingCar];
    //初始化我的页面
    MinePage *minePage = [[MinePage alloc] init];
    minePage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"Mine_No_Selected"] tag:ModelIndexMine];
    UINavigationController *minePageNav = [[UINavigationController alloc] initWithRootViewController:minePage];
    self.viewControllers = @[mainPageNav,shoppingMailNav,emptyToCardNav,shoppingCarNav,minePageNav];
    self.delegate = self;
    //添加ToCard按钮
    [self addToCardBtn];
}
-(void)addToCardBtn
{
    UIButton *toCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toCardBtn.frame = CGRectMake((DeviceMaxWidth - 45)/2, -10, 45, 45);
    [toCardBtn setBackgroundImage:[UIImage imageNamed:@"TO_btn"] forState:UIControlStateNormal];
    [toCardBtn addTarget:self action:@selector(openToCard) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:toCardBtn];
    
}
-(void)openToCard
{
    if (![MyTools loginIsOrNot:self]) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.contentColor = [UIColor bodyTextColor];
    hud.minSize = CGSizeMake(100, 80);
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    
    [hud showAnimated:YES];
    
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"token":[MyTools getUserToken]
                                 };
    [MainRequest RequestHTTPData:PATH(@"Api/User/checkTocardFlag") parameters:parameters success:^(id response) {
        [hud hideAnimated:YES];
        BOOL flag = [[response objectForKey:@"flag"] boolValue];
        NSString *toCard_grade = [response objectForKey:@"tocard_grade"];
        
        NSString *auth_status = [response objectForKey:@"auth_status"];
        if (toCard_grade) {
            NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal] mutableCopy];
            [userDic setObject:toCard_grade?toCard_grade:@"" forKey:@"tocard_grade"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:userLoginDataToLocal];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (([auth_status integerValue] == 3 || [auth_status integerValue] == 2) && [toCard_grade integerValue] >= 1) {
            return;
        }
        ToCardPage *toCardPage = [[ToCardPage alloc] init];
        toCardPage.isActivated = flag;
        toCardPage.auth_status = auth_status;
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:toCardPage];
        [self presentViewController:homeNav animated:YES completion:nil];
    } failed:^(NSDictionary *errorDic) {
        
    }];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == ModelIndexTOCard) {
        return NO;
    }
    if (index == ModelIndexShoppingCart && ![MyTools isLogin]) {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self presentViewController:loginNav animated:YES completion:nil];
        
        return NO;
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        [nav popToRootViewControllerAnimated:NO];
    }
    return YES;
}

@end
