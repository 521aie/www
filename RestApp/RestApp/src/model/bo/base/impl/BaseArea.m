//
//  BaseArea.m
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseArea.h"

@implementation BaseArea

- (void)dealloc
{
    self.name=nil;
    self.memo=nil;
    self.code=nil;
}

- (NSString *)id {

    return self._id;
}
@end
