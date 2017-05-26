//
//  VerificationDeviceViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/9.
//  Copyright © 2017年 my. All rights reserved.
//

#import "VerificationDeviceViewController.h"


@interface VerificationDeviceViewController ()

@property (nonatomic,weak) UITextField *verifTF;
@property (nonatomic,weak) UIButton    *getVerfyBtn;
@property (nonatomic,weak) UIButton    *sureBtn;
@property (nonatomic,strong)NSTimer    *countDownTimer;
@property (nonatomic,assign)NSInteger  secondsCountDown;

@end

@implementation VerificationDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备校验";
    [self initUI];
    
}
-(void)initUI
{
    UIImageView *logoImg = [UIImageView new];
    [logoImg setImage:imageWithName(@"LegendImg")];
    [self.view addSubview:logoImg];
    
    logoImg.sd_layout
    .centerXEqualToView(self.view)
    .yIs(85)
    .widthIs(76)
    .heightIs(55);
    
    UIButton *getVertifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getVertifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [getVertifyBtn setTitleColor:mainColor forState:UIControlStateNormal];
    getVertifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    getVertifyBtn.layer.borderWidth = 0.5;
    getVertifyBtn.layer.borderColor = mainColor.CGColor;
    [getVertifyBtn addTarget:self action:@selector(getVertifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerfyBtn = getVertifyBtn;
    [self.view addSubview:getVertifyBtn];
    
    getVertifyBtn.sd_layout
    .topSpaceToView(logoImg, 60)
    .widthIs(80)
    .rightSpaceToView(self.view, 40)
    .heightIs(30);
    
    UITextField *vertifyTF = [UITextField new];
    vertifyTF.placeholder = @"请输入验证码";
    vertifyTF.textColor = contentTitleColorStr1;
    vertifyTF.font = [UIFont systemFontOfSize:14];
    vertifyTF.keyboardType = UIKeyboardTypeNumberPad;
    [vertifyTF addTarget:self action:@selector(vertifyTFClicked:) forControlEvents:UIControlEventEditingChanged];
    self.verifTF = vertifyTF;
    [self.view addSubview:vertifyTF];
    
    vertifyTF.sd_layout
    .leftSpaceToView(self.view, 40)
    .rightSpaceToView(getVertifyBtn, 0)
    .topSpaceToView(logoImg, 50)
    .heightIs(40);
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = tableDefSepLineColor;
    [self.view addSubview:lineV];
    
    lineV.sd_layout
    .leftSpaceToView(self.view, 40)
    .rightSpaceToView(self.view, 40)
    .heightIs(0.5)
    .topSpaceToView(getVertifyBtn, 0);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage backgroundImageWithColor:buttonGrayColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.enabled = NO;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(SureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    sureBtn.sd_layout
    .leftSpaceToView(self.view, 40)
    .rightSpaceToView(self.view, 40)
    .heightIs(40)
    .topSpaceToView(getVertifyBtn, 40);
}
-(void)getVertifyBtnClicked:(UIButton *)button
{
    NSDictionary *dic = @{@"token":[MyTools getUserToken],
                          @"device_id":[MyTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"1",
                          @"mobile_no":[NSString stringWithFormat:@"%@",self.mobile_no],
                          };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:dic success:^(id response) {
        [hud hideAnimated:YES];
        self.secondsCountDown = 60;//60秒倒计时
        [self.getVerfyBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
        self.getVerfyBtn.layer.borderColor = contentTitleColorStr1.CGColor;
        [self.getVerfyBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
        self.getVerfyBtn.enabled = NO;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    } failed:^(NSDictionary *errorDic) {
        [hud hideAnimated:YES];
    }];
}
-(void)timeFireMethod
{
    self.secondsCountDown--;
    [self.getVerfyBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.getVerfyBtn.enabled = NO;
    if (self.secondsCountDown == 0) {
        [self.countDownTimer invalidate];
        [self.getVerfyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getVerfyBtn.layer.borderColor = mainColor.CGColor;
        [self.getVerfyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        self.getVerfyBtn.enabled = YES;
    }
}
-(void)vertifyTFClicked:(UITextField *)textField
{
    if (self.verifTF.text.length == 6) {
        [self.sureBtn setBackgroundImage:[UIImage backgroundImageWithColor:mainColor] forState:UIControlStateNormal];
        self.sureBtn.enabled = YES;
    }
    else
    {
        [self.sureBtn setBackgroundImage:[UIImage backgroundImageWithColor:buttonGrayColor] forState:UIControlStateNormal];
        self.sureBtn.enabled = NO;
    }
}
-(void)SureBtnClicked:(UIButton *)button
{
    if (self.verifTF.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入验证码" completion:nil];
        return;
    }
    if (self.verifTF.text.length != 6) {
        return;
    }
    self.sureBtn.enabled = YES;
    NSDictionary *dic = @{@"device_id":[MyTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"1",
                          @"mobile_no":[NSString stringWithFormat:@"%@",self.mobile_no],
                          @"sms_code":[NSString stringWithFormat:@"%@",self.verifTF.text]
                          
                          };
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:dic success:^(id response) {
        [self hideHUD];
        [self.delegate checkUserDevice:[NSString stringWithFormat:@"%@",[response objectForKey:@"sms_token"]]];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        
    }];
}

@end
