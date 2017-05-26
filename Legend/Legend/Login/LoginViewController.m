//
//  LoginViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/3/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginUserManager.h"
#import "VerificationDeviceViewController.h"

@interface LoginViewController ()<CheckUserDeviceDelegate,UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登陆";
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack:)];
}
-(void)getBack:(UIBarButtonItem *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClearText:(id)sender
{
    self.userTF.text = nil;
}
- (IBAction)SecretBtn:(UIButton *)sender
{
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    sender.selected = !sender.selected;
}
- (IBAction)forgetPassword:(id)sender
{
}
- (IBAction)newUserRegisster:(id)sender
{
}

- (IBAction)loginBtnClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.userTF.text.length <= 0) {
        NSLog(@"请输入手机号码！");
        return;
    }
    if (self.passwordTF.text.length <= 0) {
        NSLog(@"请输入登录密码");
        return;
    }
    if (self.passwordTF.text.length < 6) {
        NSLog(@"密码不少于六位");
        return;
    }
    if (self.passwordTF.text.length > 15) {
        NSLog(@"密码不能大于16位");
        return;
    }
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"user_name":self.userTF.text,
                                 @"user_pwd":self.passwordTF.text
                                 };
    [self showHUDWithMessage:@"登陆中..."];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MainRequest RequestHTTPData:PATH(@"api/user/checkUserDeviceIdentify") parameters:parameters success:^(id response) {
        [[LoginUserManager sharedManager] updateLoginUser:response];
        
        //[hud hideAnimated:YES];
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:YES message:@"登陆成功" completion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    } failed:^(NSDictionary *errorDic) {
        if ([[errorDic objectForKey:@"error_code"] integerValue] == 2040200) {
            [self hideHUD];
            VerificationDeviceViewController *vertifyVC = [VerificationDeviceViewController new];
            vertifyVC.mobile_no = [NSString stringWithFormat:@"%@",self.userTF.text];
            vertifyVC.delegate = self;
            [self.navigationController pushViewController:vertifyVC animated:YES];
        }
        else
        {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        }
        
    }];
}
-(void)checkUserDevice:(NSString *)sms_token
{
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"user_name":self.userTF.text,
                                 @"user_pwd":self.passwordTF.text,
                                 @"sms_token":[NSString stringWithFormat:@"%@",sms_token]
                                 };
    [self showHUDWithMessage:@"登陆中..."];
    [MainRequest RequestHTTPData:PATH(@"api/user/login") parameters:parameters success:^(id response) {
        [[LoginUserManager sharedManager] updateLoginUser:response];
        __weak typeof(self) weakSelf = self;
        [self showHUDWithResult:YES message:@"登陆成功" completion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
    }];
}


@end
