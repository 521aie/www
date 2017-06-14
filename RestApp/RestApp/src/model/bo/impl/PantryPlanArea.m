//
//  PantryPlanArea.m
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-10-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PantryPlanArea.h"

@implementation PantryPlanArea

-(NSString *) obtainItemId
{
    return self.areaId;
}

-(NSString *) obtainItemName
{
    return self.areaName;
}

-(NSString *) obtainOrignName
{
    return self.areaName;
}

-(NSString *) obtainItemValue
{
    return @"";
}

- (void)setName:(NSString *)name
{
    _name  = name ;
    self.areaName  = name;
}


- (BOOL)isEqual:(id)object
{
    if (object !=nil && [object respondsToSelector:@selector(obtainItemId)]) {
        if ([[object obtainItemId] isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

- (id)mutableCopyWithZone:(NSZone *) zone
{
    PantryPlanArea *obj=[[[self class] allocWithZone:zone] init];
    obj._id = [self._id copy];
    obj.name  = [self.name copy];
    obj.pantryAreaId  = [self.pantryAreaId copy];
    obj.lastVer = self.lastVer;
    obj.isValid = self.isValid;
    obj.createTime = self.createTime;
    obj.opTime = self.opTime;
    obj.entityId = [self.entityId copy];
    obj.pantryPlanId = [self.pantryPlanId copy];
    obj.areaId = [self.areaId copy];
    return obj;
}

- (id)copyWithZone:(NSZone *) zone
{
    PantryPlanArea *obj=[[[self class] allocWithZone:zone] init];
    obj._id = [self._id copy];
    obj.name  = [self.name copy];
    obj.pantryAreaId  = [self.pantryAreaId copy];
    obj.lastVer = self.lastVer;
    obj.isValid = self.isValid;
    obj.createTime = self.createTime;
    obj.opTime = self.opTime;
    obj.entityId = [self.entityId copy];
    obj.pantryPlanId = [self.pantryPlanId copy];
    obj.areaId = [self.areaId copy];
    return obj;
}

@end
