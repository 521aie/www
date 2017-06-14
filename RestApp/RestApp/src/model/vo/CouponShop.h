//
//  CouponShop.h
//  RestApp
//
//  Created by 邵建青 on 15-1-26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import <Foundation/Foundation.h>

@interface CouponShop : Jastor

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *shopName;

- (NSDictionary *)dictionaryData;

@end
