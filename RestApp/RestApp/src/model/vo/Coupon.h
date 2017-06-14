//
//  Coupon.h
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATUS_COUPON_NORMAL 1
#define STATUS_COUPON_PAUSE 2
#define STATUS_COUPON_CANCEL 3
#define STATUS_COUPON_DELETE 4

#define TYPE_COUPON 1
#define TYPE_ENVELOPE 2

@interface Coupon : NSObject

@property (nonatomic) NSInteger _id;
@property (nonatomic) NSInteger createTime;
@property (nonatomic) NSInteger modifyTime;
@property (nonatomic, strong) NSString *createUser;
@property (nonatomic, strong) NSString *modifyUser;
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) double price;
@property (nonatomic) NSInteger totalQuantity;
@property (nonatomic) NSInteger allocationQuantity;
@property (nonatomic) NSInteger receiveQuantity;
@property (nonatomic) NSInteger useQuantity;
@property (nonatomic) NSInteger singleQuantity;
@property (nonatomic) NSInteger receiveMaxQuantity;
@property (nonatomic) NSInteger availableQuantity;
@property (nonatomic) NSInteger receiveCondition;
@property (nonatomic) NSInteger grantRule;
@property (nonatomic) double consumeMoney;
@property (nonatomic) NSInteger displayBarcode;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger enableRule;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic) long long startTime;
@property (nonatomic) long long endTime;
@property (nonatomic, strong) NSMutableArray *shopList;
@property (nonatomic, strong) NSMutableArray *ruleList;
@property (nonatomic, strong) NSMutableArray *couponSum;
@property (nonatomic, strong) NSMutableArray *failTimeList;

+ (NSMutableArray *)convertToCouponList:(NSArray *)list;

+ (Coupon *)convertToCoupon:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryData;

@end
