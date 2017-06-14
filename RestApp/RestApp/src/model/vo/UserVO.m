//
//  UserVO.m
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserVO.h"

@implementation UserVO

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
    return nil;
}

-(id)mutableCopyWithZone:(NSZone*) zone
{
    
    UserVO* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.roleId=[self.roleId copy];
    obj.roleName=[self.roleName copy];
    obj.roleMemo=[self.roleMemo copy];
    obj.employeeId=[self.employeeId copy];
    obj.username=[self.username copy];
    obj.pwd=[self.pwd copy];
    obj.isSupper=self.isSupper;
    obj.ukey=[self.ukey copy];
    obj.isAllShop=self.isAllShop;
    obj.fingerPrint=[self.fingerPrint copy];
    obj.name=[self.name copy];
    obj.cardNo=[self.cardNo copy];
    obj.question=[self.question copy];
    obj.password=[self.password copy];
    obj.email=[self.email copy];
    obj.employeeName=[self.employeeName copy];
    obj.mobile=[self.mobile copy];
    obj.branchCode = [self.branchCode copy];
    obj.userName = [self.userName copy];
    return obj;
}

-(id)copyWithZone:(NSZone*) zone
{
    UserVO* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;
    obj.entityId=[self.entityId copy];
    obj.roleId=[self.roleId copy];
    obj.roleName=[self.roleName copy];
    obj.roleMemo=[self.roleMemo copy];
    obj.employeeId=[self.employeeId copy];
    obj.username=[self.username copy];
    obj.userName = [self.userName copy];
    obj.pwd=[self.pwd copy];
    obj.isSupper=self.isSupper;
    obj.ukey=[self.ukey copy];
    obj.isAllShop=self.isAllShop;
    obj.fingerPrint=[self.fingerPrint copy];
    obj.name=[self.name copy];
    obj.cardNo=[self.cardNo copy];
    obj.question=[self.question copy];
    obj.password=[self.password copy];
    obj.email=[self.email copy];
    obj.employeeName=[self.employeeName copy];
    obj.mobile=[self.mobile copy];
    self.branchCode = [self.branchCode copy];
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
