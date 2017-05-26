//
//  UpdatePasswordViewController.h
//  Legend
//
//  Created by 梅毅 on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdatePasswordViewController : BaseViewController

@property (nonatomic,assign) BOOL   isFromPayKeySetView;

@property (weak, nonatomic) IBOutlet UITextField *currentPwTF;
@property (weak, nonatomic) IBOutlet UITextField *newsPsTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPsTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPsBtn;

@end
