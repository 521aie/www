//
//  Taste.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Taste.h"

@implementation Taste

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

-(BOOL) obtainCheckVal
{
    return self.checkVal;
}

-(void) mCheckVal:(BOOL)check
{
    self.checkVal=check;
}

-(void)dealloc
{
    self.keyword=nil;
}

@end
