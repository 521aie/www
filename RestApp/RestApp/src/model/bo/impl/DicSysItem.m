//
//  DicSysItem.m
//  RestApp
//
//  Created by zxh on 14-5-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DicSysItem.h"

@implementation DicSysItem

+ (instancetype)itemWithId:(NSString *)itemId name:(NSString *)name {

    DicSysItem *item = [[DicSysItem alloc] init];
    item._id = itemId;
    item.name = name;
    return item;
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
    return self.val;
}

-(DicSysItem*) copyWithZone:(NSZone*)zone
{
    DicSysItem* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    
    obj.name=[self.name copy];

    obj.systemTypeId=[self.systemTypeId copy];
    obj.attachmentVer=self.attachmentVer;
    obj.dicId=[self.dicId copy];
    obj.sortCode=self.sortCode;
    obj.val=[self.val copy];
    obj.attachmentId=[self.attachmentId copy];
    obj.state=self.state;
    
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
