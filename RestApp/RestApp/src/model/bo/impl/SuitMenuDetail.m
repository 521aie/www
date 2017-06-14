//
//  SuitMenuDetail.m
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuDetail.h"
#import "FormatUtil.h"
#import "ObjectUtil.h"

@implementation SuitMenuDetail
-(NSString*) obtainItemId{
    return self._id;
}

-(NSString*) obtainItemName{
    return self.name;
}

-(NSString*) obtainOrignName{
    return self.name;
}

-(NSString*) obtainItemValue{
    NSString* typeStr=self.isRequired==1?NSLocalizedString(@"必须全部选择", nil):NSLocalizedString(@"允许顾客自选", nil);
    if (self.num == -1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%@:数量不限", nil),typeStr];
    }
    return [NSString stringWithFormat:@"%@:%@",typeStr,[FormatUtil formatDouble4:self.num]];
}

- (BOOL)isEqual:(id)object
{
    if ([ObjectUtil isNotNull:object] && [object isKindOfClass:[SuitMenuDetail class]]) {
        SuitMenuDetail *suitMenuDetailP = (SuitMenuDetail *)object;
        if ([suitMenuDetailP._id isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

@end
