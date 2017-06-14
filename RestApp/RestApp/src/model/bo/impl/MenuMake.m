//
//  MenuMake.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuMake.h"
#import "FormatUtil.h"

@implementation MenuMake

-(NSString*) obtainItemId
{
    return self.id;
}

-(NSString*) obtainItemName
{
    return self.name;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

-(NSString*) obtainItemValue
{
    if (self.makePriceMode==MAKEPRICE_NONE) {
        return NSLocalizedString(@"不加价", nil);
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"%@:%@元", nil),[self obtainMakePriceModeLabel:self.makePriceMode],[FormatUtil formatDouble4:self.makePrice]];
    }
}

-(BOOL) obtainCheckVal
{
    return self.checkVal;
}

-(void) mCheckVal:(BOOL)check
{
    self.checkVal=check;
}

-(NSString*) obtainMakePriceModeLabel:(short)mode
{
    if (mode==MAKEPRICE_NONE) {
        return NSLocalizedString(@"不加价", nil);
    }else if(mode==MAKEPRICE_TOTAL){
        return NSLocalizedString(@"一次性加价", nil);
    }else if(mode==MAKEPRICE_PERBUYACCOUNT){
        return NSLocalizedString(@"每购买单位加价", nil);
    }else if(mode==MAKEPRICE_PERUNIT){
        return NSLocalizedString(@"每结账单位加价", nil);
    }
    return @"";
}

-(void)dealloc
{
    self.name=nil;
    self.menuName=nil;
}

@end
