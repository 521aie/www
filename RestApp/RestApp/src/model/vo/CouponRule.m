//
//  CouponRule.m
//  RestApp
//
//  Created by 邵建青 on 15-1-26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "CouponRule.h"

@implementation CouponRule

+ (CouponRule *)intWithDictionary:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotEmpty:dictionary]) {
        CouponRule *couponRule = [CouponRule new];
        couponRule.type = [[dictionary objectForKey:@"type"] intValue];
        couponRule.couponId = [[dictionary objectForKey:@"couponId"] intValue];
        couponRule.quantity = [[dictionary objectForKey:@"quantity"] intValue];
        couponRule.receiveQuantity = [[dictionary objectForKey:@"receiveQuantity"] intValue];
        couponRule.clickQuantity = [[dictionary objectForKey:@"clickQuantity"] intValue];
        couponRule.useQuantity = [[dictionary objectForKey:@"useQuantity"] intValue];
        couponRule.entityId = [dictionary objectForKey:@"entityId"];
        couponRule.value = [dictionary objectForKey:@"value"];
        couponRule.rule = [dictionary objectForKey:@"rule"];
        return couponRule;
    }
    return nil;
}

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [self setObject:dictionary valueStr:self.rule key:@"rule"];
    [self setObject:dictionary valueStr:self.entityId key:@"entityId"];
    [self setObject:dictionary valueStr:self.value key:@"value"];
    [self setObject:dictionary valueInt:self.type key:@"type"];
    [self setObject:dictionary valueInt:self.quantity key:@"quantity"];
    [self setObject:dictionary valueInt:self.couponId key:@"couponId"];
    [self setObject:dictionary valueInt:self.receiveQuantity key:@"receiveQuantity"];
    [self setObject:dictionary valueInt:self.clickQuantity key:@"clickQuantity"];
    [self setObject:dictionary valueInt:self.useQuantity key:@"useQuantity"];
    return dictionary;
}

- (void)setObject:(NSMutableDictionary *)dictionaryData valueStr:(NSString *)value key:(NSString *)key
{
    if ([ObjectUtil isNotNull:value]) {
        [dictionaryData setObject:value forKey:key];
    }
}

- (void)setObject:(NSMutableDictionary *)dictionaryData valueInt:(NSInteger)value key:(NSString *)key
{
    [dictionaryData setObject:[NSString stringWithFormat:@"%li", (long)value] forKey:key];
}

@end
