//
//  SetPayKeyViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/19.
//  Copyright © 2017年 my. All rights reserved.
//

#import "SetPayKeyViewController.h"

@interface SetPayKeyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *payPwd;
@property (weak, nonatomic) IBOutlet UITextField *samePayPwd;
@property (weak, nonatomic) IBOutlet UIButton *finisheBtn;

@end

@implementation SetPayKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置支付密码";
    self.payPwd.delegate = self;
    self.samePayPwd.delegate = self;
    self.finisheBtn.layer.cornerRadius = 8;
    self.finisheBtn.layer.masksToBounds = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self getFinishBtnEnable];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - FinishedBtnClicked
- (IBAction)finishBtnCliked:(id)sender
{
    [self.view endEditing:YES];
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",self.payPwd.text,DES_KEY];
    NSString *md5PassWord = [[MyTools sharedInstance] getMd5_32Bit_String:passwordKey];
    if (self.payPwd.text.length != 6) {
        [self showHUDWithResult:NO message:@"密码位数请设置6位" completion:nil];
        return;
    }
    if (self.isFromForgetKeyView) {
//        [self showHUDWithMessage:nil];
//        NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
//                                     @"token":[MyTools getUserToken],
//                                     @"mobile_no":self.
//                                     };
    }
    else
    {
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                     @"token":[MyTools getUserToken],
                                     @"new_payment_pwd":md5PassWord,
                                     @"re_new_payment_pwd":md5PassWord
                                     };
        [MainRequest RequestHTTPData:PATH(@"api/user/setPaymentPassword") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:@"设置密码成功" completion:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:havePayPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        }];
    }
}

- (void)getFinishBtnEnable
{
    if (self.payPwd.text.length != 0 && self.samePayPwd.text.length != 0) {
        self.finisheBtn.enabled = YES;
        self.finisheBtn.backgroundColor = mainColor;
    }
}

@end
