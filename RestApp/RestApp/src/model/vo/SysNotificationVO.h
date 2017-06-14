//
//  SysNotificationVO.h
//  RestApp
//
//  Created by shao_jian_qing on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SysNotification.h"

@interface SysNotificationVO : NSObject
/**
 * 最新的一条消息.
 */
@property (nonatomic, strong) NSString *title;
/** 
 * 消息数量.  
 */
@property (nonatomic, assign) NSInteger count;

+ (SysNotificationVO *)convertToSysNotificationVO:(NSDictionary *)dictionary;

@end
