//
//  KindTaste.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindTaste.h"

@implementation KindTaste

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

-(id)initWithVal:(NSString*)name andId:(NSString*)itemId
{
    self._id=itemId;
    self.name=name;
    return self;
}

@end
