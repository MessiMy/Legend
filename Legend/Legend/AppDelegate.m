//
//  AppDelegate.m
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
////腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
////微信SDK头文件
//#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册分享
    //[self initShare];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[HomeViewController alloc] init];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 初始化分享
- (void)initShare
{
//    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSMS),
//                                        @(SSDKPlatformTypeWechat),
//                                        @(SSDKPlatformTypeQQ)]
//                             onImport:^(SSDKPlatformType platformType) {
//                                 switch (platformType) {
//                                     case SSDKPlatformTypeWechat:
//                                         [ShareSDKConnector connectWeChat:[WXApi class]];
//                                         break;
//                                     case SSDKPlatformTypeSMS:
//                                         
//                                         break;
//                                     case SSDKPlatformTypeQQ:
//                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                                         break;
//                                     default:
//                                         break;
//                                 }
//                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//                                 switch (platformType) {
//                                     case SSDKPlatformTypeWechat:
//                                         
//                                         break;
//                                         
//                                     default:
//                                         break;
//                                 }
//                             }];
}

@end
