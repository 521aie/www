//
//  OpenTimePlan.h
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseOpenTimePlan.h"

@interface OpenTimePlan : BaseOpenTimePlan

typedef enum
{
    TYPE_TODAY,      //结束时间类型:今天
    TYPE_TOMORROW    //结束时间类型:次日早晨
}EndType;

@end
