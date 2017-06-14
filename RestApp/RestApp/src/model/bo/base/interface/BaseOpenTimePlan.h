//
//  BaseOpenTimePlan.h
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseOpenTimePlan : EntityObject

/**
 * <code>营业结束时间类型</code>.
 */
@property short endType;
/**
 * <code>营业结束时间</code>.
 */
@property int endTime;

@end
