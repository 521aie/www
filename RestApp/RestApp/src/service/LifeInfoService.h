//
//  SmsService.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Notification.h"
#import "BaseService.h"

@interface LifeInfoService : BaseService


- (void)listLifeInfoData:(NSInteger)page pageSize:(NSInteger)pageSize target:(id)target callback:(SEL)callback;

- (void)listNoteCountData:(NSString *)kindCardId target:(id)target callback:(SEL)callback;


- (void)saveNotification:(Notification *)notification filePath:(NSString *)filePath target:(id)target callback:(SEL)callback;


- (void)removeNotification:(NSString *)notificationId target:(id)target callback:(SEL)callback;


- (void)checkNotificationCount:(id)target callback:(SEL)callback;

@end
