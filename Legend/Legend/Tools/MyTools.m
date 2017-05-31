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
#import "MyCustomButton.h"
//#import <ShareSDKUI/ShareSDK+SSUI.h>




static MyTools *shareTool;
#define pathsOther [NSString stringWithFormat:@"%@/SCFinanceOther",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define fxBgViewTag 339
#define fxLowViewTag 340
static UILabel * tempLabel;//alert提示label
//分享图片和描述
static NSString * fxConStr; //分享的内容
static id fxImg;            //分享的图片
static NSString * fxUrlStr; //分享的链接
static NSString * titleString; //分享的标题
UIViewController *tempFxVc; //缓存分享页面传过来的Vc

UIWebView *phoneCallWebView;

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
#pragma mark - 设置控件文本部分字体颜色
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    return as;
}
//根据文字和字体，计算文字的特定高度SpecificWidth内的显示高度
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size
{
    if ([string isEqualToString:@""]) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = size;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize sizeHeight = [string boundingRectWithSize:CGSizeMake(width, DeviceMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return sizeHeight.height;
}
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range
{
    if ([string isEqualToString:@""]) {
        return nil;
    }
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:size];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:range];
    return as;
}
/*
 *  @"YYYY-MM-dd HH:mm:ss" //对时间戳进行格式化处理
 */
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr
{
    NSDate * date = nil;
    time = [NSString stringWithFormat:@"%@",time];
    if (time.length == 10) { //10位
        date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }else //13位
    {
        date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    }
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:formatestr];
    return [df stringFromDate:date];
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
#pragma mark - 分享
//批量处理APP中的分享问题
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitilStr:(NSString *)titilStr withVc:(UIViewController *)fxVc isAdShare:(NSString *) adShareStatus
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    tempFxVc = fxVc;
    titleString = titilStr;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:shareTool action:@selector(fxViewDisAppear)];
    UIView * grayV = [[UIView alloc]initWithFrame:fxVc.navigationController.view.bounds];
    grayV.tag = fxBgViewTag;
    grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [grayV addGestureRecognizer:tapG];
    [fxVc.view addSubview:grayV];
    
    UIView * fxView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 140*widthRate)];
    fxView.tag = fxLowViewTag;
    fxView.backgroundColor = [UIColor whiteColor];
    [fxVc.view addSubview:fxView];
    
    NSArray * a = @[@"微信好友",@"QQ好友",@"短信"];
    CGFloat fxWith = (DeviceMaxWidth-20*widthRate)/3;
    for (int i = 0; i < 3; i++) {
        MyCustomButton * fxBtn = [[MyCustomButton alloc]initWithFrame2:CGRectMake(10*widthRate+fxWith*i, 0, fxWith, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        [fxBtn addTarget:[MyTools sharedInstance] action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [fxView addSubview:fxBtn];
    }
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fxView addSubview:cancelBtn];
    
    if ([adShareStatus integerValue] == 1) {
        cancelBtn.backgroundColor = mainColor;
        [cancelBtn setTitle:@"收藏" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(saveSuceess) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([adShareStatus integerValue] == 2) {
        cancelBtn.backgroundColor = mainColor;
        [cancelBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(saveSuceess) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        cancelBtn.backgroundColor = viewColor;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(fxViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 1;
        fxView.frame = CGRectMake(0, DeviceMaxHeight-140*widthRate-64, DeviceMaxWidth, 140*widthRate);
    }];
}
#pragma mark - hide fxView
- (void)fxViewDisAppear
{
    UIView  *grayV = [tempFxVc.view viewWithTag:fxBgViewTag];
    UIView  *fxView = [tempFxVc.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate);
        
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}
#pragma mark - share
- (void)fxBtnEvent:(UIButton *)button
{
//    [[MyTools sharedInstance] fxViewDisAppear];
//    SSDKPlatformType type;
//    switch (button.tag) {
//        case 0://微信好友
//            type = SSDKPlatformSubTypeWechatSession;
//            break;
//        case 1://QQ好友
//            type = SSDKPlatformSubTypeQQFriend;
//            break;
//        case 2://短信
//            type = SSDKPlatformTypeSMS;
//        default:
//            break;
//    }
}
- (void)saveSuceess
{
    
}
@end
