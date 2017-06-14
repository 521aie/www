//
//  BaseAreaFeePlan.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseAreaFeePlan : EntityObject

/**
 * <code>区域ID</code>.
 */
@property (nonatomic,retain) NSString *areaId;
/**
 * <code>费用套餐ID</code>.
 */
@property (nonatomic,retain) NSString *feePlanId;
/**
 * <code>是否分时间</code>.
 */
@property short isTime;
/**
 * <code>开始日期</code>.
 */
@property NSString* startDate;
/**
 * <code>结束日期</code>.
 */
@property NSString* endDate;
/**
 * <code>开始时间</code>.
 */
@property int startTime;
/**
 * <code>结束时间</code>.
 */
@property int endTime;
/**
 * <code>是否有日期限制</code>.
 */
@property short isDate;
/**
 * <code>星期范围</code>.
 */
@property (nonatomic,retain) NSString *weekDay;

@end
