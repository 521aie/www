//
//  DiscountPlanRender.m
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DiscountPlanRender.h"
#import "DiscountPlan.h"
#import "NameItemVO.h"

@implementation DiscountPlanRender

+(NSMutableArray*) listMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"打折", nil) andId:[NSString stringWithFormat:@"%d",MODE_RADIO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"使用会员价", nil) andId:[NSString stringWithFormat:@"%d",MODE_MEMBERPRICE]];
    [vos addObject:item];
    
    return vos;
}

@end
