//
//  QuitBtnCell.h
//  Legend
//
//  Created by 梅毅 on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuitBtnCellDelegate <NSObject>

- (void)QuitBtnClicked;

@end

@interface QuitBtnCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *QuitBtn;
@property (weak, nonatomic) id<QuitBtnCellDelegate>delegate;

@end
