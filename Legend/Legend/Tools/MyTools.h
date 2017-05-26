//
//  MyTools.h
//  Legend
//
//  Created by 梅毅 on 2017/3/27.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyTools : NSObject
/*
 *  获取用户token
 */
+(NSString *)getUserToken;
/*
 *  获取用户设备的UUID
 */
+(NSString *)getDeviceUUID;
/*
 *  进行登陆验证
*/
+(BOOL)isLogin;
+(BOOL)loginIsOrNot :(UIViewController *)controller;
+ (void)clearUserLocalData;
+ (instancetype)sharedInstance;
- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (BOOL)isPayPassword;
+ (void)detailPhone:(NSString *)phone;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range;
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size;
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range;
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr;
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitilStr:(NSString *)titilStr withVc:(UIViewController *)fxVc isAdShare:(NSString *) adShareStatus;

@end
