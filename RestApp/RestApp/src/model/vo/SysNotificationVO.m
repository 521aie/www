//
//  BusinessDayVO.m
//  RestApp
//
//  Created by zxh on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SysNotificationVO.h"

@implementation SysNotificationVO

+ (SysNotificationVO *)convertToSysNotificationVO:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotNull:dictionary]) {
        SysNotificationVO *sysNotificationVO = [[SysNotificationVO alloc]init];
        sysNotificationVO.title = [dictionary objectForKey:@"title"];
        sysNotificationVO.count = [[dictionary objectForKey:@"count"] integerValue];
        return sysNotificationVO;
    }
    return  nil;
}

@end
