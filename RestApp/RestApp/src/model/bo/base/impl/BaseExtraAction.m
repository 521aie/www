//
//  BaseExtraAction.m
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseExtraAction.h"

@implementation BaseExtraAction

-(void)dealloc
{
    self.code=nil;
    self.name=nil;
    self.systemTypeId=nil;
    self.defaultValue=nil;
    self.memo=nil;
    
}

@end
