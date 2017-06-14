//
//  MenuTimeRender.m
//  RestApp
//
//  Created by YouQ-MAC on 14-12-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimeRender.h"
#import "NameItemVO.h"

@implementation MenuTimeRender

+ (NSMutableArray *)listPerferential
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"促销价", nil) andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"打折", nil) andId:@"2"];
    [vos addObject:item];
    
    return vos;
}

@end
