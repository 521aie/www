//
//  ShopTag.m
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopTag.h"

@implementation ShopTag

-(NSString *) obtainItemId
{
    return self.dicSysItemId;
}

-(NSString *) obtainItemName
{
    return self.name;
}

-(NSString *) obtainOrignName
{
    return self.name;
}

-(NSString *) obtainItemValue
{
    return @"";
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

-(ShopTag *) copyWithZone:(NSZone*)zone
{
    ShopTag* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    
    obj.entityId=[self.entityId copy];
    
    obj.name=[self.name copy];
    obj.spell=[self.spell copy];
    obj.code=[self.code copy];
    obj.dicSysItemId=[self.dicSysItemId copy];
    
    return obj;
}

@end
