//
//  MenuRender.m
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuRender.h"
#import "Menu.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "RestConstants.h"

#define MENU_DEDUCT_FORMAT NSLocalizedString(@"▪︎ 提成金额(%@)", nil)
#define MENU_SERVICEFEEMODE_FORMAT NSLocalizedString(@"▪︎ 费用(%@)", nil)
@interface MenuRender ()
{
    NSMutableArray *_menuStepLengthArray;
}
@end

@implementation MenuRender

+ (MenuRender *)render
{
    static MenuRender *rander;
    static dispatch_once_t time;
    dispatch_once(&time, ^{
        if (!rander) {
            rander = [[self alloc] init];
        }
    });
    return rander;
}

+ (NSMutableArray *)listDataKind
{
    NSMutableArray *vos = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"手动清理", nil) andId:[NSString stringWithFormat:@"%d",DATACLEAR_UNAUTO]];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"自动清理", nil) andId:[NSString stringWithFormat:@"%d",DATACLEAR_AUTO]];
    [vos addObject:item];
    return vos;
}
+ (NSMutableArray *)listDataTime
{
    NSMutableArray *vos = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"每天03:00清理", nil) andId:[NSString stringWithFormat:@"%d",DATACLEAR_DAY]];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"每周一03:00清理", nil) andId:[NSString stringWithFormat:@"%d",DATACLEAR_WEEK]];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"每月1日03:00清理", nil) andId:[NSString stringWithFormat:@"%d",DATACLEAR_MONTH]];
    [vos addObject:item];
    return vos;
}



+ (NSMutableArray *)listBillType
{
    NSMutableArray *vos = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"根据营业额", nil) andId:@"0"];

    [vos addObject:item];
    item =   [[NameItemVO alloc] initWithVal:NSLocalizedString(@"根据账单数量", nil) andId:@"1"];
    [vos addObject:item];
    return vos;
}

+(NSString*) getbillTypeUnit:(short)btype
{
    if (btype == BILL_TURNOVER) {
        return NSLocalizedString(@"账单占营业额的百分比(%)", nil);
    }else if(btype == BILL_ACCOUNT){
        return NSLocalizedString(@"账单占总单数百分比(%)", nil);
    }
    return @"";
}





+ (NSMutableArray *)listBillPer
{
      NSMutableArray *countArray = [NSMutableArray array];
      for (int i = 1; i < 101; i ++) {
            NameItemVO *item = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d",i] andId:[NSString stringWithFormat:@"%d",i]];
            [countArray addObject:item];
        }
    return countArray;
}

+ (NSMutableArray *)listAutoDay
{
    NSMutableArray *countArray = [NSMutableArray array];
    for (int i = 1; i < 61; i ++) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d",i] andId:[NSString stringWithFormat:@"%d",i]];
        [countArray addObject:item];
    }
    return countArray;
}


+(NSMutableArray*) listDeductKind
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不提成", nil) andId:[NSString stringWithFormat:@"%d",DEDUCTKIND_NOSET]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按比例", nil) andId:[NSString stringWithFormat:@"%d",DEDUCTKIND_RATIO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"按固定金额", nil) andId:[NSString stringWithFormat:@"%d",DEDUCTKIND_FIX]];
    [vos addObject:item];

    return vos;
}

+(NSMutableArray*) listServiceFeeMode
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不收取", nil) andId:[NSString stringWithFormat:@"%d",SERVICEFEEMODE_NO]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"固定费用", nil) andId:[NSString stringWithFormat:@"%d",SERVICEFEEMODE_FIX]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"商品价格百分比", nil) andId:[NSString stringWithFormat:@"%d",SERVICEFEEMODE_RATIO]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listAcridLevels
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"不设定", nil) andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"一颗辣椒", nil) andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"两颗辣椒", nil) andId:@"2"];
    [vos addObject:item];
    
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"三颗辣椒", nil) andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listMenuUnits:(NSString*)units
{
    if ([NSString isBlank:units]) {
        units=DEFAULT_MENU_UNITS;
    }
    NameItemVO *item=nil;
    NSMutableArray* vos=[NSMutableArray array];
    NSArray* unitList=[units componentsSeparatedByString:@"|"];
    for (NSString* str in unitList) {
        item=[[NameItemVO alloc] initWithVal:str andId:str];
        [vos addObject:item];
    }
    return vos;
}

+(NSString*) getDeductdLabel:(short) val
{
    if (val==DEDUCTKIND_FIX) {
        return [NSString stringWithFormat:MENU_DEDUCT_FORMAT,NSLocalizedString(@"元", nil)];
    }else if(val==DEDUCTKIND_RATIO){
        return [NSString stringWithFormat:MENU_DEDUCT_FORMAT,@"%"];
    }
    return NSLocalizedString(@"▪︎ 提成金额", nil);
}

+(NSString*) getServiceFeeLabel:(short) val
{
    if (val==SERVICEFEEMODE_FIX) {
        return [NSString stringWithFormat:MENU_SERVICEFEEMODE_FORMAT,NSLocalizedString(@"元", nil)];
    }else if(val==SERVICEFEEMODE_RATIO){
        return [NSString stringWithFormat:MENU_SERVICEFEEMODE_FORMAT,@"%"];
    }
     return NSLocalizedString(@"▪︎ 费用", nil);
}
+ (NSString*)obtainItem:(NSMutableArray*)list itemId:(NSString*)itemId
{
    if(!list || [NSString isBlank:itemId]){
        return @"";
    }
    NSString* itemName=nil;
    for (NameItemVO *item in list) {
        if([item.obtainItemId isEqualToString:itemId]){
            itemName=item.obtainItemName;
            break;
        }
    }
    return itemName;
}

- (NSMutableArray *)menuStepLengthArray
{
    if (!_menuStepLengthArray) {
        _menuStepLengthArray = [NSMutableArray array];
        for (int i = 1; i < 21; i ++) {
            NameItemVO *vo = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d",i] andId:[NSString stringWithFormat:@"%d",i]];
            [_menuStepLengthArray addObject:vo];
        }
    }
    return _menuStepLengthArray;
    
}
@end
