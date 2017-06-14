//
//  SignBillVO.m
//  RestApp
//
//  Created by Shaojianqing on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SignBillVO.h"

@implementation SignBillVO

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionaryData = [[NSMutableDictionary alloc]init];
    
    [self setObject:dictionaryData valueDou:self.fee key:@"fee"];
    [self setObject:dictionaryData valueDou:self.realFee key:@"realFee"];
    
    [self setObject:dictionaryData valueStr:self.payModeId key:@"payModeId"];
    [self setObject:dictionaryData valueStr:self.company key:@"company"];
    [self setObject:dictionaryData valueStr:self.memo key:@"memo"];
    return dictionaryData;
}

- (void)setObject:(NSMutableDictionary *)dictionaryData valueInt:(NSInteger)value key:(NSString *)key
{
    [dictionaryData setObject:[NSString stringWithFormat:@"%li", (long)value] forKey:key];
}

- (void)setObject:(NSMutableDictionary *)dictionaryData valueStr:(NSString *)value key:(NSString *)key
{
    if ([ObjectUtil isNotNull:value]) {
        [dictionaryData setObject:value forKey:key];
    }
}

- (void)setObject:(NSMutableDictionary *)dictionaryData valueDou:(double)value key:(NSString *)key
{
    [dictionaryData setObject:[NSString stringWithFormat:@"%0.2f", value] forKey:key];
}


@end
