/*
*  Notification .h
*  CardApp
*
*  Created by SHAOJIANQING on 13-6-18.
*  Copyright (c) 2013年 ZMSOFT. All rights reserved.
*/

#import "EntityObject.h"

/**
 * 通知信息.
 * shao_jian_qing@126.com
 */
@interface BaseNotification : EntityObject
/**
 * <code>发布时间</code>.
 */
@property (nonatomic, strong) NSDate *sendDate;
/**
 * <code>开始时间</code>.
 */
@property (nonatomic, strong) NSDate *startDate;
/**
 * <code>结束时间</code>.
 */
@property (nonatomic, strong) NSDate *endDate;
/**
 * <code>名称</code>.
 */
@property (nonatomic, strong) NSString *name;
/**
 * <code>说明</code>.
 */
@property (nonatomic, strong) NSString *memo;
/**
 * <code>卡类型ID</code>.
 */
@property (nonatomic, strong) NSString *kindCardId;
@property (nonatomic, strong) NSString *kindCardName;
/**
 * <code>附件ID</code>.
 */
@property (nonatomic, strong) NSString *attachmentId;
/**
 * <code>所在服务器</code>.
 */
@property (nonatomic, strong) NSString *server;
/**
 * <code>路径</code>.
 */
@property (nonatomic, strong) NSString *path;
/**
 * <code>NOTIFYKIND对应的字段</code>.
 */
@property (nonatomic, assign) NSInteger notifyKind;
@end
