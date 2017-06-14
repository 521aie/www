//
//  Coupon.m
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CouponShop.h"
#import "ObjectUtil.h"
#import "Coupon.h"

@implementation Coupon

+ (NSMutableArray *)convertToCouponList:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        NSMutableArray *resultList = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionary in list) {
            Coupon *coupon = [Coupon convertToCoupon:dictionary];
            if ([ObjectUtil isNotNull:coupon]) {
                [resultList addObject:coupon];
            }
        }
        return resultList;
    }
    return nil;
}

+ (Coupon *)convertToCoupon:(NSDictionary *)dictionary
{
    if ([ObjectUtil isNotEmpty:dictionary]) {
        Coupon *coupon = [Coupon new];
        coupon._id = [[dictionary objectForKey:@"_id"] intValue];
        coupon.createTime = [[dictionary objectForKey:@"createTime"] intValue];
        coupon.modifyTime = [[dictionary objectForKey:@"modifyTime"] intValue];
        coupon.createUser = [dictionary objectForKey:@"createUser"];
        coupon.modifyUser = [dictionary objectForKey:@"modifyUser"];
        coupon.entityId = [dictionary objectForKey:@"entityId"];
        coupon.shopId = [dictionary objectForKey:@"shopId"];
        coupon.type = [[dictionary objectForKey:@"type"] intValue];
        coupon.name = [dictionary objectForKey:@"name"];
        coupon.price = [[dictionary objectForKey:@"price"] doubleValue];
        coupon.totalQuantity = [[dictionary objectForKey:@"totalQuantity"] intValue];
        coupon.allocationQuantity = [[dictionary objectForKey:@"allocationQuantity"] intValue];
        coupon.receiveQuantity = [[dictionary objectForKey:@"receiveQuantity"] intValue];
        coupon.useQuantity = [[dictionary objectForKey:@"useQuantity"] intValue];
        coupon.singleQuantity = [[dictionary objectForKey:@"singleQuantity"] intValue];
        coupon.receiveMaxQuantity = [[dictionary objectForKey:@"receiveMaxQuantity"] intValue];
        coupon.availableQuantity = [[dictionary objectForKey:@"availableQuantity"] intValue];
        coupon.receiveCondition = [[dictionary objectForKey:@"receiveCondition"] intValue];
        coupon.grantRule = [[dictionary objectForKey:@"grantRule"] intValue];
        coupon.consumeMoney = [[dictionary objectForKey:@"consumeMoney"] doubleValue];
        coupon.displayBarcode = [[dictionary objectForKey:@"displayBarcode"] intValue];
        coupon.status = [[dictionary objectForKey:@"status"] intValue];
        coupon.enableRule = [[dictionary objectForKey:@"enableRule"] intValue];
        coupon.memo = [dictionary objectForKey:@"memo"];
        coupon.startTime = [[dictionary objectForKey:@"startTime"] longLongValue]*1000;
        coupon.endTime = [[dictionary objectForKey:@"endTime"] longLongValue]*1000;
        coupon.ruleList = [dictionary objectForKey:@"ruleList"];
        coupon.shopList = [dictionary objectForKey:@"shopList"];
        coupon.couponSum = [dictionary objectForKey:@"couponSum"];
        coupon.ruleList = [dictionary objectForKey:@"ruleList"];
        
        return coupon;
    }
    return nil;
}

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionaryData = [[NSMutableDictionary alloc]init];
    [self setObject:dictionaryData valueInt:self._id key:@"_id"];
    [self setObject:dictionaryData valueInt:self.createTime key:@"createTime"];
    [self setObject:dictionaryData valueInt:self.modifyTime key:@"modifyTime"];
    [self setObject:dictionaryData valueInt:self.type key:@"type"];
    [self setObject:dictionaryData valueInt:self.totalQuantity key:@"totalQuantity"];
    [self setObject:dictionaryData valueInt:self.allocationQuantity key:@"allocationQuantity"];
    [self setObject:dictionaryData valueInt:self.receiveQuantity key:@"receiveQuantity"];
    [self setObject:dictionaryData valueInt:self.useQuantity key:@"useQuantity"];
    [self setObject:dictionaryData valueInt:self.singleQuantity key:@"singleQuantity"];
    [self setObject:dictionaryData valueInt:self.receiveMaxQuantity key:@"receiveMaxQuantity"];
    [self setObject:dictionaryData valueInt:self.availableQuantity key:@"availableQuantity"];
    [self setObject:dictionaryData valueInt:self.receiveCondition key:@"receiveCondition"];
    [self setObject:dictionaryData valueInt:self.grantRule key:@"grantRule"];
    [self setObject:dictionaryData valueInt:self.displayBarcode key:@"displayBarcode"];
    [self setObject:dictionaryData valueInt:self.status key:@"status"];
    [self setObject:dictionaryData valueInt:self.enableRule key:@"enableRule"];
    [self setObject:dictionaryData valueInt:self.startTime key:@"startTime"];
    [self setObject:dictionaryData valueInt:self.endTime key:@"endTime"];
    
    [self setObject:dictionaryData valueDou:self.price key:@"price"];
    [self setObject:dictionaryData valueDou:self.consumeMoney key:@"consumeMoney"];
    
    [self setObject:dictionaryData valueStr:self.entityId key:@"entityId"];
    [self setObject:dictionaryData valueStr:self.shopId key:@"shopId"];
    [self setObject:dictionaryData valueStr:self.createUser key:@"createUser"];
    [self setObject:dictionaryData valueStr:self.modifyUser key:@"modifyUser"];
    [self setObject:dictionaryData valueStr:self.memo key:@"memo"];
    [self setObject:dictionaryData valueStr:self.name key:@"name"];

    if ([ObjectUtil isNotEmpty:self.shopList]) {
        [dictionaryData setObject:self.shopList forKey:@"shopList"];
    }
    if ([ObjectUtil isNotEmpty:self.ruleList]) {
        [dictionaryData setObject:self.ruleList forKey:@"ruleList"];
    }
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

