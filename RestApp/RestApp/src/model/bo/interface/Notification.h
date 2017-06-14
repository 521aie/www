/*
*  Notification .h
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "BaseNotification.h"

/**
 * 通知信息.
 * shao_jian_qing@126.com
 */
@interface Notification : BaseNotification

+ (NSMutableArray *)convertToNotificationsByArr:(NSArray *)notificationArray;

+ (Notification *)convertToNotification:(NSDictionary *)dictionary;

@end
