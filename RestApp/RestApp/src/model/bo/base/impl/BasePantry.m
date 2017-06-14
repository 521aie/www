//
//  BasePantry.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BasePantry.h"

@implementation BasePantry

-(void)dealloc
{
    self.name=nil;
    self.printerIp=nil;
    self.printerTypeName =nil;
    self.printerType =nil;
}
@end
