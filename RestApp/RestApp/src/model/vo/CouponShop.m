//
//  CouponShop.m
//  RestApp
//
//  Created by 邵建青 on 15-1-26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CouponShop.h"

@implementation CouponShop

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:self.shopId forKey:@"shopId"];
    [dictionary setObject:self.entityId forKey:@"entityId"];
    [dictionary setObject:self.shopName forKey:@"shopName"];
    return dictionary;
}

@end