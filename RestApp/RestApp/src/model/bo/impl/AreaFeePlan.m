//
//  AreaFeePlan.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AreaFeePlan.h"

@implementation AreaFeePlan

-(NSString*) obtainItemId
{
    return self.areaId;
}

-(NSString*) obtainItemName
{
    return self.areaName;
}

-(NSString*) obtainOrignName
{
    return self.areaName;
}

-(BOOL)isEqual:(id)object
{
    if (object !=nil && [object respondsToSelector:@selector(obtainItemId)]) {
        if ([[object obtainItemId] isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

-(id)copyWithZone:(NSZone*) zone
{
    AreaFeePlan* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.areaId=[self.areaId copy];
    obj.feePlanId=[self.feePlanId copy];
    obj.isTime=[self isTime];
    obj.startDate=[self.startDate copy];
    obj.endDate=[self.endDate copy];
    obj.startDateStr  = [self.startDateStr copy];
    obj.endDateStr  = [self.endDateStr copy];
    obj.startTime=self.startTime;
    obj.endTime=self.endTime;
    obj.isDate=self.isDate;
    obj.weekDay=[self.weekDay copy];
    obj.areaName=[self.areaName copy];
    obj.feePlanName=[self.feePlanName copy];
    
    return obj;
}

@end
