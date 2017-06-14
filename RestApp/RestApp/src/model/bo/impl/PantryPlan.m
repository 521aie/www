//
//  PantryPlan.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PantryPlan.h"

@implementation PantryPlan

+(id) areaIds_class{
    return NSClassFromString(@"NSString");
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areaIds" : [NSString class]};
}
@end
