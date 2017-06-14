//
//  NameValueItemVO.m
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueItemVO.h"

@implementation NameValueItemVO

-(NSString*) obtainItemId
{
    return self.itemId;
}

-(NSString*) obtainItemName
{
    return self.itemName;
}

-(NSString*) obtainOrignName
{
    return self.itemName;
}

-(NSString*) obtainItemValue
{
    return self.itemVal;
}

-(id)initWithVal:(NSString*)name val:(NSString*)val andId:(NSString*)itemId
{
    self.itemId=itemId;
    self.itemName=name;
    self.itemVal=val;
    return self;
}

@end
