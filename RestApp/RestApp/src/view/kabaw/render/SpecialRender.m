//
//  SpecialRender.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecialRender.h"
#import "NameItemVO.h"
#import "Special.h"

@implementation SpecialRender

+(NSMutableArray*) listMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按会员价", nil) andId:[NSString stringWithFormat:@"%d",SPECIAL_MODE_MEMBER_RATIO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按固定折扣", nil) andId:[NSString stringWithFormat:@"%d",SPECIAL_MODE_FIX_RATIO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按打折方案", nil) andId:[NSString stringWithFormat:@"%d",SPECIAL_MODE_DICOUNT_RATIO]];
    [vos addObject:item];
    
    return vos;
}
@end
