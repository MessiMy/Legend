//
//  CertificationUploadViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/24.
//  Copyright © 2017年 my. All rights reserved.
//

#import "CertificationUploadViewController.h"
#import "CertificationUploadImageViewController.h"

@interface CertificationUploadViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UITextField *IDTF;
@property (weak, nonatomic) IBOutlet UITextField *contractNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contractNumTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation CertificationUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.layer.masksToBounds = YES;
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.realNameTF.text.length > 0 && self.contractNumTF.text.length > 0 &&self.contractNameTF.text.length > 0 && self.IDTF.text.length > 0) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = mainColor;
    }
    else
    {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [UIColor noteTextColor];
    }
}
- (IBAction)nextBtnClicked:(UIButton *)sender
{
    if (self.realNameTF.text.length < 2 || self.realNameTF.text.length > 6) {
        [self showHUDWithResult:NO message:@"请填写您的真实姓名，姓名长度为2～6位" completion:nil];
        return;
    }
    if (![MyTools isValidateMobile:self.contractNumTF.text]) {
        [self showHUDWithResult:NO message:@"请填写有效的联系人电话号码" completion:nil];
        return;
    }
    if (self.contractNameTF.text.length < 2 || self.contractNameTF.text.length > 6) {
        [self showHUDWithResult:NO message:@"请填写联系人的姓名，长度为2～6位" completion:nil];
        return;
    }
    NSDictionary *parameters = @{@"token":[MyTools getUserToken],
                                 @"device_id":[MyTools getDeviceUUID],
                                 @"real_name":[NSString stringWithFormat:@"%@",self.realNameTF.text],
                                 @"ID_card":[NSString stringWithFormat:@"%@",self.IDTF.text],
                                 @"emergency_contact_name":[NSString stringWithFormat:@"%@",self.contractNameTF.text],
                                 @"emergency_contact_phone":[NSString stringWithFormat:@"%@",self.contractNumTF.text]
                                 };
    [self showHUDWithMessage:@"信息检查中"];
    [MainRequest RequestHTTPData:PATH(@"Api/user/checkRealNameAuth") parameters:parameters success:^(id response) {
        [self hideHUD];
        CertificationUploadImageViewController *certificationUploadImageVC = [[CertificationUploadImageViewController alloc] init];
        certificationUploadImageVC.realNameStr = self.realNameTF.text;
        certificationUploadImageVC.IDCardStr = self.IDTF.text;
        certificationUploadImageVC.contactName = self.contractNameTF.text;
        certificationUploadImageVC.contactPhone = self.contractNumTF.text;
        certificationUploadImageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certificationUploadImageVC animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        NSLog(@"%@",[errorDic objectForKey:@"error_msg"]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
