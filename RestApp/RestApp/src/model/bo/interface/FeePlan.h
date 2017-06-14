//
//  FeePlan.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseFeePlan.h"
#import "INameValueItem.h"

typedef enum
{
    CAL_BASE_NULL=0,      //不收小费.
    CAL_BASE_FIXED=1,      //固定.
    CAL_BASE_AMOUNT=2,      //根据总菜价消费金额
    CAL_BASE_PEOPLE=3,   //根据人数计算
    CAL_BASE_TIME=4,          //根据时间计算.
    CAL_BASE_PER_MENU=5        //按每个菜的设置分别收取计算.
}FEEPLAN_SERVICEMODE_ENUM;


typedef enum
{
    MIN_CONSUME_KIND_NULL=0,      //无最低消费.
    MIN_CONSUME_KIND_FIX=1,      //固定费用.
    MIN_CONSUME_KIND_PEOPLE=2      //人均最低消费
}FEEPLAN_MINMODE_ENUM;


@interface FeePlan : BaseFeePlan<INameValueItem>
/**
 * <code>服务费-费用</code>.
 */
@property double fee;
/**
 * <code>服务费-费用计算方式</code>.
 */
@property short calBase;
/**
 * <code>服务费-费用计算基准</code>.
 */
@property int standard;
@end
