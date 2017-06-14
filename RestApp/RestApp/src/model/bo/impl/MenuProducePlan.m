//
//  MenuProducePlan.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuProducePlan.h"

@implementation MenuProducePlan

-(NSString*) obtainItemId{
    return self.menuOrKindId;
}

-(NSString*) obtainItemName{
    return self.menuName;
}

-(NSString*) obtainOrignName{
    return self.menuName;
}

-(NSString*) obtainItemValue{
    return @"";
}

-(NSString *)obtainMenuId{
    return self.menuOrKindId;
}

-(void)dealloc
{
    self.menuName=nil;
	self.kindName=nil;
}

-(MenuProducePlan *) copyWithZone:(NSZone*)zone
{
    MenuProducePlan* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.prodPlanId=[self.prodPlanId copy];
    obj.menuOrKindId=[self.menuOrKindId copy];
    obj.type=self.type;
    obj.menuName=[self.menuName copy];
    obj.kindName=[self.kindName copy];
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
