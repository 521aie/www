//
//  SmsService.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "LifeInfoService.h"
#import "RestConstants.h"
#import "Notification.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "JSONKit.h"

@implementation LifeInfoService

//获得生活圈列表API.
- (void)listLifeInfoData:(NSInteger)page pageSize:(NSInteger)pageSize target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setObject:[NSString stringWithFormat:@"%li", (long)page] forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%li", (long)pageSize] forKey:@"pageSize"];
    NSString *query = @"Customer?method=getNotification";
    [super postSession:query param:param target:target callback:callback];
}

//获得消息接受人数API.
- (void)listNoteCountData:(NSString *)kindCardId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    param[@"kindCardId"] = kindCardId;
    NSString *query = @"Customer?method=getNotificationCount";
    [super postSession:query param:param target:target callback:callback];
}

//保存Notification的API.
- (void)saveNotification:(Notification *)notification filePath:(NSString *)filePath target:(id)target callback:(SEL)callback{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setObject:[JsonHelper transJson:notification] forKey:@"notification"];
    filePath = [NSString stringWithFormat:@"\"%@\"", filePath];
    [param setObject:filePath forKey:@"filePath"];
    NSString *query = @"Customer?method=saveNotification";
    [super postSession:query param:param target:target callback:callback];
}

//删除Notification的API.
- (void)removeNotification:(NSString *)notificationId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setObject:notificationId forKey:@"notificationId"];
    NSString *query = @"Customer?method=removeNotification";
    [super postSession:query param:param target:target callback:callback];
}
//检验Notification数量的API.
- (void)checkNotificationCount:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    NSString *query = @"Customer?method=checkNotificationCount";
    [super postSession:query param:param target:target callback:callback];
}
@end
