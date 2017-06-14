/*
*  Notification .m
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "JsonUtil.h"
#import "ObjectUtil.h"
#import "SysNotification.h"

@implementation SysNotification

+ (NSMutableArray *)convertToSysNotificationsByArr:(NSArray *)notificationArray
{
    NSMutableArray *notifications = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:notificationArray]) {
        for (NSDictionary *dictionary in notificationArray) {
            SysNotification *notification = [SysNotification convertToSysNotification:dictionary];
            if ([ObjectUtil isNotNull:notification]) {
                [notifications addObject:notification];
            }
        }
        return notifications;
    }
    return nil;
}

+ (SysNotification *)convertToSysNotification:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SysNotification *notification = [[SysNotification alloc]init];
        notification._id = [dictionary objectForKey:@"id"];
        notification.name = [dictionary objectForKey:@"name"];
        notification.memo = [dictionary objectForKey:@"memo"];
        notification.path = [dictionary objectForKey:@"path"];
        notification.server = [dictionary objectForKey:@"server"];
        notification.notifyKind = [[dictionary objectForKey:@"notifyKind"] integerValue];
        notification.createTime = [[dictionary objectForKey:@"createTime"] longLongValue];
        return notification;
    }
    return nil;
}

@end
