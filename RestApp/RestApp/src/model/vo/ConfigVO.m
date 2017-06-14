//
//  ConfigVO.m
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVO.h"

@implementation ConfigVO

+(id) options_class{
    return NSClassFromString(@"ConfigItemOption");
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"
             };
}

@end
