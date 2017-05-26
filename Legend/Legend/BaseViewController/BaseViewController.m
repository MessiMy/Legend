//
//  BaseViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginUserManager.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) MBProgressHUD *hudView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers indexOfObject:self]!=0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack:)];
    }
}
-(void)getBack:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UserModel *)getUserData
{
    return [LoginUserManager sharedManager].loginUser;
}
- (void)showHUDWithMessage:(NSString *)message
{
    self.hudView.mode = MBProgressHUDModeDeterminate;
    self.hudView.detailsLabel.text = message;
    [self.hudView showAnimated:YES];
}
- (void)hideHUD
{
    [self.hudView hideAnimated:YES];
}
- (void)showLoginViewController {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message completion:(void (^)(void))completion {
    [self.hudView showAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hudView.mode = MBProgressHUDModeCustomView;
        
        UIImage *image = [UIImage imageNamed: isSuccess ? @"success_network" : @"error_network"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sizeToFit];
        
        self.hudView.customView = imageView;
        self.hudView.detailsLabel.text = message;
        
        double deley = isSuccess ? 1.0 : 2.0;
        [self.hudView hideAnimated:YES afterDelay:deley];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deley * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}
- (void)updateUserData{
    NSDictionary *dic = @{@"token":[MyTools getUserToken],
                          @"device_id":[MyTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"Api/User/getuserinfo") parameters:dic success:^(id responseData) {
        [[LoginUserManager sharedManager] updateLoginUser:responseData];
    } failed:^(NSDictionary *errorDic) {
        
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
