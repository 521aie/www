//
//  BaseUserDiscountPlanVO.m
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserDiscountPlanVO.h"

@implementation UserDiscountPlanVO

-(NSString*) obtainItemId
{
    return self.userId;
}

-(NSString*) obtainItemName
{
    return self.userName;
}
-(NSString*) obtainOrignName
{
    return self.userName;
}

-(NSString*) obtainItemValue
{
    return @"";
}

-(void)dealloc
{
    self.userName=nil;
}

-(id)mutableCopyWithZone:(NSZone*) zone
{
    UserDiscountPlanVO* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.userId=[self.userId copy];
    obj.userName=self.userName;
    obj.discountPlanId=[self.discountPlanId copy];
    return obj;
}

-(id)copyWithZone:(NSZone*) zone
{
    UserDiscountPlanVO* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.userId=[self.userId copy];
    obj.userName=self.userName;
    obj.discountPlanId=[self.discountPlanId copy];
    return obj;
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

@end
