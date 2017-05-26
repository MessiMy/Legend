//
//  LoginUserManager.m
//  Legend
//
//  Created by 梅毅 on 2017/5/9.
//  Copyright © 2017年 my. All rights reserved.
//

#import "LoginUserManager.h"

@interface LoginUserManager()

@property (nonatomic,assign) BOOL       isLogin;
@property (nonatomic,strong) UserModel  *loginUser;
@property (nonatomic,strong) NSString   *token;
@property (nonatomic,assign) BOOL       haveSetPayPassWord;

@end

@implementation LoginUserManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal];
        if (userDic) {
            self.isLogin = YES;
            self.loginUser = [UserModel mj_objectWithKeyValues:userDic];
            self.token = [[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile];
            self.haveSetPayPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:havePayPassword];
        }
    }
    return self;
}
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LoginUserManager *manager = nil;
    dispatch_once(&onceToken,^{
        manager = [[LoginUserManager alloc] init];
    });
    return manager;
}
-(void)updateLoginUser:(NSDictionary *)userDic
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (userDic) {
        [userDefault setObject:[userDic objectForKey:@"user_info"] forKey:userLoginDataToLocal];
        [userDefault synchronize];
        
        [userDefault setObject:[userDic objectForKey:@"access_token"] forKey:saveLocalTokenFile];
        [userDefault synchronize];
        
        NSString *isPayPassWord = [NSString stringWithFormat:@"%@",[[userDic objectForKey:@"user_info"] objectForKey:@"payment_pwd"]];
        [userDefault setBool:[isPayPassWord boolValue] forKey:havePayPassword];
        [userDefault synchronize];
        
        self.isLogin = YES;
        self.loginUser = [UserModel mj_objectWithKeyValues:[userDic objectForKey:@"user_info"]];
        self.token = [userDic objectForKey:@"access_token"];
        self.haveSetPayPassWord = [isPayPassWord boolValue];
    }
    else
    {
        [userDefault removeObjectForKey:userLoginDataToLocal];
        [userDefault removeObjectForKey:saveLocalTokenFile];
        [userDefault removeObjectForKey:havePayPassword];
        [userDefault synchronize];
        
        self.isLogin = NO;
        self.loginUser = nil;
        self.token = nil;
        self.haveSetPayPassWord = NO;
    }
}
@end
