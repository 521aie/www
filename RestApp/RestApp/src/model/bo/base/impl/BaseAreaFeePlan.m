//
//  BaseAreaFeePlan.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseAreaFeePlan.h"

@implementation BaseAreaFeePlan

-(void)dealloc
{
    self.areaId=nil;
    self.feePlanId=nil;
    self.startDate=nil;
    self.endDate=nil;
    self.weekDay=nil;
}
@end
