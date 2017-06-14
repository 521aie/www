//
//  MakeRender.m
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MakeRender.h"
#import "MenuMake.h"
#import "NameItemVO.h"
#import "Make.h"

@implementation MakeRender

+(NSMutableArray*) listMakePriceMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不加价", nil) andId:[NSString stringWithFormat:@"%d",MAKEPRICE_NONE]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"一次性加价", nil) andId:[NSString stringWithFormat:@"%d",MAKEPRICE_TOTAL]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"每购买单位加价", nil) andId:[NSString stringWithFormat:@"%d",MAKEPRICE_PERBUYACCOUNT]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"每结账单位加价", nil) andId:[NSString stringWithFormat:@"%d",MAKEPRICE_PERUNIT]];
    [vos addObject:item];
    
    return vos;
 
}

+(MenuMake*) convertMake:(Make*)make
{
    MenuMake* menuMake=[MenuMake new];
    menuMake.makeId=make._id;
    menuMake.makePrice=0;
    menuMake.makePriceMode=MAKEPRICE_NONE;
    menuMake.name=make.name;
    return menuMake;
}

@end
