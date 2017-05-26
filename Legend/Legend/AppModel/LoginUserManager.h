//
//  LoginUserManager.h
//  Legend
//
//  Created by 梅毅 on 2017/5/9.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface LoginUserManager : NSObject

@property (nonatomic, readonly) BOOL                isLogin;
@property (nonatomic, strong, readonly) UserModel   *loginUser;
@property (nonatomic, strong, readonly) NSString    *token;
@property (nonatomic, readonly) BOOL                haveSetPayPassword;

+ (instancetype) sharedManager;
-(void)updateLoginUser:(NSDictionary *)userDic;

@end
