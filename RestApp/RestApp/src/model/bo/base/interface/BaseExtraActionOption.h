//
//  BaseExtraActionOption.h
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseExtraActionOption : Base

/**
 * <code>特殊权限项ID</code>.
 */
@property (nonatomic,retain) NSString *extraActionId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>说明</code>.
 */
@property (nonatomic,retain) NSString *memo;
/**
 * <code>选项值</code>.
 */
@property (nonatomic,retain) NSString *value;
/**
 * <code>系统类型ID</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;

@end
