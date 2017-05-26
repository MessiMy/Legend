//
//  MyTools.m
//  Legend
//
//  Created by 梅毅 on 2017/3/27.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyTools.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>


static MyTools *shareTool;

@implementation MyTools

+(NSString *)getUserToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile];
    return token?token:@"";
}
+(NSString *)getDeviceUUID
{
    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return uuid?uuid:@"";
}
+(BOOL)isLogin
{
    if ([MyTools getUserToken].length > 0) {
        return YES;
    }
    return NO;
}
+(BOOL)loginIsOrNot:(UIViewController *)controller
{
    if ([MyTools getUserToken].length > 0) {
        return YES;
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [controller presentViewController:loginNav animated:YES completion:nil];
    }
    return NO;
}
+ (void)clearUserLocalData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveLocalTokenFile];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userLoginDataToLocal];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:havePayPassword];
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{     //该方法只执行一次，且能保证线程安全
        shareTool = [[MyTools alloc] init];
    });
    return shareTool;
}
+ (BOOL)isPayPassword {
    BOOL isPayPassword = [[[NSUserDefaults standardUserDefaults] objectForKey:havePayPassword] boolValue];
    return isPayPassword;
}
#pragma mark - 打电话
+ (void)detailPhone:(NSString *)phone {
    [self dialPhoneNumber:phone];
}

+ (void)dialPhoneNumber:(NSString *)aPhoneNumber {
    NSString *str = [NSString stringWithFormat:@"telprompt://%@",aPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
#pragma mark - 手机号验证
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    return NO;
}
@end
