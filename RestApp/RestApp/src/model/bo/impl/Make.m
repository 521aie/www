//
//  Make.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Make.h"
#import "ObjectUtil.h"

@implementation Make

-(NSString *) obtainItemId
{
    return self._id;
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

-(void)dealloc
{
    self.menuArr=nil;
    self.keyword=nil;
}

-(Make*) copyWithZone:(NSZone*)zone
{
    Make* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.name=[self.name copy];
    obj.spell=[self.spell copy];
    obj.memo=[self.memo copy];
    obj.sortCode=self.sortCode;
    obj.code=[self.code copy];
    
    obj.menuArr=[self.menuArr copy];
    obj.keyword=[self.keyword copy];
    obj.makePriceMode=self.makePriceMode;
    obj.name=[self.name copy];
    obj.makePrice=self.makePrice;
    return obj;
}

-(BOOL)isEqual:(id)object
{
    if ([ObjectUtil isNotNull:object] && [object isKindOfClass:[Make class]]) {
        Make *make = (Make *)object;
        if ([make._id isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

@end
