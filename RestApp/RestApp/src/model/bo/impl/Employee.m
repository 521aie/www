//
//  Employee.m
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Employee.h"

@implementation Employee

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
    return self.mobile;
}

-(NSString*) obtainImgpath
{
    return [self.name substringFromIndex:(self.name.length-1)];
}

-(NSString*) obtainHeadId
{
    return self.roleId;
}

-(NSString*) obtainItemSpell
{
    return self.spell;
}

-(NSString*) obtainItemCode
{
    return @"";
}

-(void)dealloc
{
    self.userId=nil;
    self.userName=nil;
    self.roleName=nil;
    self.roleId=nil;
}
@end
