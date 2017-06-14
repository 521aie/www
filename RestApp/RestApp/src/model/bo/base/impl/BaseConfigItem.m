//
//  BaseConfigItem.m
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseConfigItem.h"

@implementation BaseConfigItem

-(void)dealloc{
    self.name=nil;
    self.code=nil;
    self.defaultValue=nil;
    self.kindConfigId=nil;
    self.memo=nil;
    self.systemTypeId=nil;
}

@end
