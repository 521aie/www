/*
*  Notification .m
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "JsonUtil.h"
#import "ObjectUtil.h"
#import "Notification.h"

@implementation Notification

+ (NSMutableArray *)convertToNotificationsByArr:(NSArray *)notificationArray
{
    NSMutableArray *notifications = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:notificationArray]) {
        for (NSDictionary *dictionary in notificationArray) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                Notification *notification = [Notification convertToNotification:dictionary];
                [notifications addObject:notification];
            }
        }
        return notifications;
    }
    return nil;
}

+ (Notification *)convertToNotification:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotEmpty:dictionary]) {
        Notification *notification = [[Notification alloc]init];
        notification._id = [dictionary objectForKey:@"id"];
        notification.sendDate = [JsonUtil stringTransformDate:[dictionary objectForKey:@"sendDate"]];
        notification.startDate = [JsonUtil stringTransformDate:[dictionary objectForKey:@"startDate"]];
        notification.endDate = [JsonUtil stringTransformDate:[dictionary objectForKey:@"endDate"]];
        notification.name = [dictionary objectForKey:@"name"];
        notification.kindCardId = [dictionary objectForKey:@"kindCardId"];
        notification.kindCardName = [dictionary objectForKey:@"kindCardName"];
        notification.server = [dictionary objectForKey:@"server"];
        notification.path = [dictionary objectForKey:@"path"];
        notification.memo = [dictionary objectForKey:@"memo"];
        
        notification.entityId = [dictionary objectForKey:@"entityId"];
        notification.isValid = [ObjectUtil getShortValue:dictionary key:@"isValid"];
        notification.createTime = [ObjectUtil getLonglongValue:dictionary key:@"createTime"];
        notification.opTime = [ObjectUtil getLonglongValue:dictionary key:@"opTime"];
        notification.lastVer = [ObjectUtil getLonglongValue:dictionary key:@"lastVer"];
        return notification;
    }
    return nil;
}

@end
