//
//  MenuSpecDetail.m
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuSpecDetail.h"
#import "NumberUtil.h"
#import "FormatUtil.h"
#import "NSString+Estimate.h"
@implementation MenuSpecDetail

- (NSString *)obtainItemId
{
    if ([NSString isBlank:self.specItemId]) {
        return self.id;
    }
    return self.specItemId;
}

- (NSString *)obtainItemName
{
    if ([NSString isBlank:self.specDetailName]) {
        return self.name;
    }
    return self.specDetailName;
}

- (NSString *)obtainOrignName
{
    if ([NSString isBlank:self.specDetailName]) {
        return self.name;
    }
    return self.specDetailName;
}

- (NSString *)obtainItemValue
{
    if (self.addMode==ADDMODE_HAND) {
        return [NSString stringWithFormat:NSLocalizedString(@"自定义单价:%@", nil), [FormatUtil formatDouble4:self.definePrice]];
    } else if (self.addMode==ADDMODE_AUTO) {
        return [NSString stringWithFormat:NSLocalizedString(@"默认单价:%@", nil), [FormatUtil formatDouble4:self.definePrice]];
    }
    
    return @"";
}

- (BOOL)obtainCheckVal
{
    return self.checkVal;
}

- (void)mCheckVal:(BOOL)check
{
    self.checkVal=check;
}

@end
