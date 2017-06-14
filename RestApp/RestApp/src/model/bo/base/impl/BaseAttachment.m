//
//  BaseAttachment.m
//  RestApp
//
//  Created by zxh on 14-6-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseAttachment.h"

@implementation BaseAttachment
-(void) dealloc
{
    self.path=nil;
    self.validateCode=nil;
    self.tableName=nil;
    self.mainId=nil;
    self.server=nil;
}
@end
