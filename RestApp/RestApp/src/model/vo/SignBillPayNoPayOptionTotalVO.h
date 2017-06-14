//
//  SignBillPayNoPayOptionTotalVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillPayNoPayOptionTotalVO : NSObject

/**
 * 支付方式详细选项Id.
 */
@property (nonatomic, strong) NSString *kindPayDetailOptionId;
/**
 * 支付方式选项名称.
 */
@property (nonatomic, strong) NSString *name;
/**
 * 支付数量.
 */
@property (nonatomic) NSUInteger payCount;
/**
 * 支付金额.
 */
@property (nonatomic) double fee;
/**
 * 支付方式Id.
 */
@property (nonatomic, strong) NSString *kindPayId;
/**
 * 支付记录Id数组.
 */
@property (nonatomic, strong) NSString *payIdsStr;

+ (SignBillPayNoPayOptionTotalVO *)convertToSignBillPayNoPayOptionTotalVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillPayNoPayOptionTotalList:(NSArray *)list;

@end
