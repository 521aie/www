//
//  FeePlanRender.m
//  RestApp
//
//  Created by zxh on 14-4-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FeePlanRender.h"
#import "NameItemVO.h"
#import "FeePlan.h"

@implementation FeePlanRender

+(NSMutableArray*) listServiceFeeMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"每桌固定", nil) andId:[NSString stringWithFormat:@"%d",CAL_BASE_FIXED]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"商品价百分比", nil) andId:[NSString stringWithFormat:@"%d",CAL_BASE_AMOUNT]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按人数", nil) andId:[NSString stringWithFormat:@"%d",CAL_BASE_PEOPLE]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按时间", nil) andId:[NSString stringWithFormat:@"%d",CAL_BASE_TIME]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按每个商品的服务费收取", nil) andId:[NSString stringWithFormat:@"%d",CAL_BASE_PER_MENU]];
    [vos addObject:item];
    return vos;
}

+(NSMutableArray*) listMinFeeMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"固定费用", nil) andId:[NSString stringWithFormat:@"%d",MIN_CONSUME_KIND_FIX]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"人均最低消费", nil) andId:[NSString stringWithFormat:@"%d",MIN_CONSUME_KIND_PEOPLE]];
    [vos addObject:item];
   
    return vos;
}

+(NSString*) obtainServiceFeeUnit:(short)calBase
{
    if (calBase==CAL_BASE_FIXED) {
        return NSLocalizedString(@"元/桌", nil);
    }else if(calBase==CAL_BASE_AMOUNT){
        return @"%";
    }else if(calBase==CAL_BASE_PEOPLE){
        return NSLocalizedString(@"元/人", nil);
    }else if(calBase==CAL_BASE_TIME){
        return NSLocalizedString(@"元", nil);
    }else if(calBase==CAL_BASE_PER_MENU){
        return NSLocalizedString(@"元", nil);
    }else{
        return NSLocalizedString(@"未设", nil);
    }
}


@end
