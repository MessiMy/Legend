//
//  ToCardMemberHeaderView.h
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToCardMemberHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) UILabel     *titleLabel;
@property (nonatomic, weak) UIButton    *infoBtn;
@property (nonatomic, weak) UILabel     *infoLabel;

- (void)setInfoLabelRemainCount:(NSInteger)count;
- (void)setInfoLabelBenifitLayer:(NSInteger)count;
@end
