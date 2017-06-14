//
//  BaseConfigItem.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseConfigItem : Base

/**
 * <code>参数组ID</code>.
 */
@property (nonatomic,retain) NSString *kindConfigId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>说明</code>.
 */
@property (nonatomic,retain) NSString *memo;
/**
 * <code>编码</code>.
 */
@property (nonatomic,retain) NSString *code;
/**
 * <code>参数类型</code>.
 */
@property short dataType;
/**
 * <code>参数设置模式</code>.
 */
@property short selectMode;
/**
 * <code>默认值</code>.
 */
@property (nonatomic,retain) NSString *defaultValue;
/**
 * <code>是否可由餐店配置</code>.
 */
@property short isShopConfig;
/**
 * <code>所属系统类型ID</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;

@end
