//
//  ToCardMemberModel.h
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToCardMemberModel : NSObject

@property (nonatomic, strong) NSString  *user_id;
@property (nonatomic, strong) NSString  *user_name;
@property (nonatomic, strong) NSString  *photo_url;
@property (nonatomic, strong) NSString  *grade;
@property (nonatomic, strong) NSString  *low_members_count;
@property (nonatomic, strong) NSString  *today_add_members_count;
@property (nonatomic, strong) NSString  *telephone;
@property (nonatomic, strong) NSString  *low_one_members_count;
@property (nonatomic, strong) NSString  *is_remove;

@end
