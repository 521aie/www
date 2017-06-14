//
//  Area.m
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Area.h"

@implementation Area

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

-(NSString*) obtainItemId
{
    return self._id;
}

-(NSString*) obtainItemName
{
    return self.name;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

-(NSString*) obtainItemValue
{
    return @"";
}

-(id)mutableCopyWithZone:(NSZone *) zone
{
    Area* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.name=[self.name copy];
    obj.sortCode=self.sortCode;
    obj.memo=[self.memo copy];
    obj.code=[self.code copy];
    return obj;
}

-(id)copyWithZone:(NSZone *) zone
{
    Area* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.name=[self.name copy];
    obj.sortCode=self.sortCode;
    obj.memo=[self.memo copy];
    obj.code=[self.code copy];
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

- (BOOL)hiddenValueLabel {

    return YES;
}

@end
