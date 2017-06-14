//
//  CouponRule.h
//  RestApp
//
//  Created by 邵建青 on 15-1-26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import <Foundation/Foundation.h>

#define TYPE_PUBLISH_NUM 1
#define TYPE_GET_CARD 2
#define TYPE_CHARGE_GET 3
#define TYPE_RULE_ENVELOPE 4

@interface CouponRule : Jastor

@property (nonatomic) int type;
@property (nonatomic) int quantity;
@property (nonatomic) int couponId;
@property (nonatomic) int useQuantity;
@property (nonatomic) int clickQuantity;
@property (nonatomic) int receiveQuantity;
@property (nonatomic, strong) NSString *rule;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *entityId;

+ (CouponRule *)intWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryData;

@end
