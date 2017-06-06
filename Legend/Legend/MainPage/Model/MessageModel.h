//
//  MessageModel.h
//  Legend
//
//  Created by 梅毅 on 2017/6/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeListModel : NSObject


@property(nonatomic, retain) NSString   *content;
@property(nonatomic, retain) NSString   *effect_time;
@property(nonatomic, retain) NSString   *is_read;
@property(nonatomic, retain) NSString   *notice_id;
@property(nonatomic, retain) NSString   *title;

@end

@interface MessageModel : NSObject

@property (nonatomic, copy)NSArray<NoticeListModel*>*notice_list;

@end
