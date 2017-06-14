//
//  ShopTemplateRender.m
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopTemplateRender.h"
#import "ShopTemplate.h"
#import "NameItemVO.h"

@implementation ShopTemplateRender

+(NSMutableArray*) listWidth
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"58mm 适用", nil) andId:[NSString stringWithFormat:@"%d",PRINT_58]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"76mm 适用", nil) andId:[NSString stringWithFormat:@"%d",PRINT_76]];
    [vos addObject:item];
    
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"80mm 适用", nil) andId:[NSString stringWithFormat:@"%d",PRINT_80]];
    [vos addObject:item];
    
    return vos;
}

+(NSString*) objtainKindName:(int)type
{
    return type==SHOPTEMPLATE_TYPE_CASH?NSLocalizedString(@"收银单据", nil):(type==SHOPTEMPLATE_TYPE_BASE?NSLocalizedString(@"消费底联", nil):NSLocalizedString(@"厨房单据", nil));
}

@end
