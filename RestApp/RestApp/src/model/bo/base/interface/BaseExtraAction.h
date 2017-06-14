//
//  BaseExtraAction.h
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseExtraAction : Base

/**
 * <code>编码</code>.
 */
@property (nonatomic,retain) NSString *code;
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>状态</code>.
 */
@property short status;
/**
 * <code>权限所属系统</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;
/**
 * <code>排列顺序</code>.
 */
@property int sortCode;
/**
 * <code>项目选择模式</code>.
 */
@property short selectMode;
/**
 * <code>参数类型</code>.
 */
@property short dataType;
/**
 * <code>默认值</code>.
 */
@property (nonatomic,retain) NSString *defaultValue;
/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString *memo;

@end
