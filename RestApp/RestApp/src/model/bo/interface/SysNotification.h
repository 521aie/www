/*
*  Notification .h
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "BaseSysNotification.h"

/**
 * 系统通知信息.
 * shao_jian_qing@126.com
 */
@interface SysNotification : BaseSysNotification

+ (SysNotification *)convertToSysNotification:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSysNotificationsByArr:(NSArray *)notificationArray;

@end
