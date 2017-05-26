//
//  VerificationDeviceViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/5/9.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@protocol CheckUserDeviceDelegate <NSObject>

- (void)checkUserDevice:(NSString *)sms_token;

@end

@interface VerificationDeviceViewController : BaseViewController

@property (nonatomic, strong) NSString       *mobile_no;
@property (nonatomic, weak)   id             delegate;

@end
