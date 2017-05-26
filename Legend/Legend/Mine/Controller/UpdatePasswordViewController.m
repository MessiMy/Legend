//
//  UpdatePasswordViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()<UITextFieldDelegate>

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFromPayKeySetView) {
        self.title = @"设置支付密码";
        self.forgetPsBtn.hidden = NO;
        self.newsPsTF.keyboardType = UIKeyboardTypeNumberPad;
        self.confirmPsTF.keyboardType = UIKeyboardTypeNumberPad;
        self.currentPwTF.keyboardType = UIKeyboardTypeNumberPad
        ;
    }
    else
    {
        self.title = @"设置登录密码";
        self.forgetPsBtn.hidden = YES;
    }
    self.currentPwTF.delegate = self;
    self.newsPsTF.delegate = self;
    self.confirmPsTF.delegate = self;
    self.saveBtn.layer.cornerRadius = 6;
    self.saveBtn.layer.masksToBounds = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.currentPwTF.text.length == 0) {
        return YES;
    }
    if (self.newsPsTF.text.length == 0) {
        return YES;
    }
    if (self.confirmPsTF.text.length == 0) {
        return YES;
    }
    self.saveBtn.backgroundColor = mainColor;
    self.saveBtn.enabled = YES;
    return YES;
}
- (IBAction)saveBtnClicked:(UIButton *)sender
{
    NSString *passwordBeforeKey = [NSString stringWithFormat:@"%@%@",self.currentPwTF.text,DES_KEY];
    NSString *md5BeforePW = [[MyTools sharedInstance] getMd5_32Bit_String:passwordBeforeKey];
    NSString *passwordAfterKey = [NSString stringWithFormat:@"%@%@",self.newsPsTF.text,DES_KEY];
    NSString *md5AfterPS = [[MyTools sharedInstance] getMd5_32Bit_String:passwordAfterKey];
    if (self.confirmPsTF.text != self.newsPsTF.text) {
        [self showHUDWithResult:NO message:@"两次密码不一致" completion:nil];
        return;
    }
    if (self.isFromPayKeySetView == YES) {
        if (self.newsPsTF.text.length != 6) {
            [self showHUDWithResult:NO message:@"支付密码请设置6位数字" completion:nil];
            return;
        }
    }
    if (self.isFromPayKeySetView == NO) {
        if (self.newsPsTF.text.length < 6 || self.newsPsTF.text.length > 6 ) {
            [self showHUDWithResult:NO message:@"密码6-16位" completion:nil];
            return;
        }
    }
    __weak typeof(self) weakSelf = self;
    if (self.isFromPayKeySetView == NO) {
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                     @"user_pwd":self.currentPwTF.text,
                                     @"new_pwd":self.newsPsTF.text,
                                     @"re_pwd":self.newsPsTF.text,
                                     @"token":[MyTools getUserToken]
                                     };
        [MainRequest RequestHTTPData:PATH(@"api/user/resetPwd") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:@"修改成功" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        }];
    }
    else
    {
        [self hideHUD];
        NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                     @"payment_pwd":md5BeforePW,
                                     @"new_payment_pwd":md5AfterPS,
                                     @"re_new_payment_pwd":md5AfterPS,
                                     @"token":[MyTools getUserToken]
                                     };
        [MainRequest RequestHTTPData:PATH(@"Api/User/setPaymentPassword") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:@"修改成功" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        }];
    }
}
- (IBAction)forgetBtnCliked:(UIButton *)sender
{
    
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
