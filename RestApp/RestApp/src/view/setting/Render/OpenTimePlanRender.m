//
//  OpenTimePlanRender.m
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "OpenTimePlanRender.h"
#import "StrItemVO.h"
#import "OpenTimePlan.h"
@implementation OpenTimePlanRender
+(NSMutableArray*) listEndTypes{
    NSMutableArray* vos=[NSMutableArray array];
    StrItemVO *item=[[StrItemVO alloc] initWithVal:NSLocalizedString(@"当日", nil) andId:[NSString stringWithFormat:@"%d",TYPE_TODAY]];
    [vos addObject:item];
    
    item=[[StrItemVO alloc] initWithVal:NSLocalizedString(@"次日早晨", nil) andId:[NSString stringWithFormat:@"%d",TYPE_TOMORROW]];
    [vos addObject:item];
    return vos;
}

@end
