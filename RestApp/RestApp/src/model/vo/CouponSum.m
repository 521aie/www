//
//  CouponRule.m
//  RestApp
//
//  Created by 邵建青 on 15-1-26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CouponSum.h"
#import "ObjectUtil.h"

@implementation CouponSum

+ (CouponSum *)intWithDictionary:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotEmpty:dictionary]) {
        CouponSum *couponSum = [CouponSum new];
        couponSum.price = [[dictionary objectForKey:@"price"] doubleValue];
        couponSum.receiveQuantity = [[dictionary objectForKey:@"receiveQuantity"] intValue];
        couponSum.clickQuantity = [[dictionary objectForKey:@"clickQuantity"] intValue];
        couponSum.useQuantity = [[dictionary objectForKey:@"useQuantity"] intValue];
        return couponSum;
    }
    return nil;
}

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [self setObject:dictionary valueInt:self.price key:@"price"];
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
