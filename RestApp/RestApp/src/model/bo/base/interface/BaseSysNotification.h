/*
*  Notification .h
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "Base.h"

/**
 * 系统通知信息.
 * shao_jian_qing@126.com
 */
@interface BaseSysNotification : Base

@property (nonatomic) NSInteger *notifyKind;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *attachmentId;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *path;

@end
