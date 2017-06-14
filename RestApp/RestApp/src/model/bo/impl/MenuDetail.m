//
//  MenuDetail.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuDetail.h"

@implementation MenuDetail

-(void)dealloc
{
    self.path=nil;
    self.server=nil;
    self.filePath=nil;
}

- (NSString *)obtainId
{
    return self._id;
}

- (NSString *)obtainPath
{
    return self.path;
}

- (NSString *)obtainFilePath
{
    return self.filePath;
}

@end
