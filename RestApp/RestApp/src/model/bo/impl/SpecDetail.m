//
//  SpecDetail.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecDetail.h"
#import "FormatUtil.h"
#import "ObjectUtil.h"

@implementation SpecDetail

-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.name;
}

-(NSString*) obtainOrignName{
    return self.name;
}

-(NSString*) obtainItemValue{
    
    return [NSString stringWithFormat:@"%@",[FormatUtil formatDouble4:self.priceScale]];
}

-(SpecDetail*) copyWithZone:(NSZone*)zone
{
    SpecDetail* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];

    obj.name=[self.name copy];
    obj.spell=[self.spell copy];
    obj.specId=[self.specId copy];
    obj.priceScale=self.priceScale;
    obj.sortCode=self.sortCode;
    obj.rawScale=self.rawScale;
    obj.priceMode=self.priceMode;
    
    return obj;
}

-(BOOL)isEqual:(id)object
{
    if ([ObjectUtil isNotNull:object] && [object isKindOfClass:[SpecDetail class]]) {
        SpecDetail *sepcDetail = (SpecDetail *)object;
        if ([sepcDetail._id isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

@end
