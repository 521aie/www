//
//  BaseMenuTime.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseMenuTime : EntityObject

/**
 * <code>是否有日期限制</code>.
 */
@property short isDate;
/**
 * <code>是否有时间限制</code>.
 */
@property short isTime;
/**
 * <code>是否特定日期有效/code>.
 */
@property short isWeek;
/**
 * <code>开始日期</code>.
 */
@property (nonatomic,retain) NSString *startDate;
/**
 * <code>结束日期</code>.
 */
@property (nonatomic,retain) NSString *endDate;
/**
 * <code>开始时间</code>.
 */
@property int starttime;
/**
 * <code>结束时间</code>.
 */
@property int endtime;
/**
 * <code>星期范围</code>.
 */
@property (nonatomic,retain) NSString *weekDay;
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>优惠方式</code>.
 */
@property short mode;
/**
 * <code>折扣率</code>.
 */
@property double ratio;
/**
 * <code>是否可打折</code>.
 */
@property short isRatio;

@end
