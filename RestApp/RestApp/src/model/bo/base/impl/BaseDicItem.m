//
//  BaseDicItem.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseDicItem.h"

@implementation BaseDicItem

-(void)dealloc
{
    self.name=nil;
    self.systemTypeId=nil;
    self.dicId=nil;
    self.val=nil;
    self.attachmentId=nil;
}

@end
