//
//  BaseViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UITableView    *tableView;

- (UserModel *)getUserData;
- (void) showHUDWithMessage:(NSString *)message;
- (void)hideHUD;
- (void)showLoginViewController;
- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message completion:(void (^)(void))completion;
- (void)updateUserData;

@end
