//
//  BaseLinkMan.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseLinkMan : EntityObject

/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;
/**
 * <code>身份证</code>.
 */
@property (nonatomic,retain) NSString *certificate;
/**
 * <code>生日</code>.
 */
@property NSDate* birthday;
/**
 * <code>性别</code>.
 */
@property short sex;
/**
 * <code>是否接收相关短信</code>.
 */
@property short isSMS;
/**
 * <code>手机号码</code>.
 */
@property (nonatomic,retain) NSString *mobile;
/**
 * <code>接收内容类型</code>.
 */
@property short smsKind;
/**
 * <code>接收时段</code>.
 */
@property int receiveTime;
/**
 * <code>接收日类型</code>.
 */
@property short dateKind;
/**
 * <code>下一发送时间</code>.
 */
@property long long nextSMSTime;

@end
