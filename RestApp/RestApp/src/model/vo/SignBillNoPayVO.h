//
//  SignBillNoPayVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillNoPayVO : NSObject

/**
 * 挂账单Id.
 */
@property (nonatomic, strong) NSString *payId;
/**
 * 挂账人id.
 */
@property (nonatomic, strong) NSString *kindPayDetailOptionId;
/**
 * 挂账人.
 */
@property (nonatomic, strong) NSString *memo;
/**
 * 挂账金额.
 */
@property (nonatomic) double fee;
/**
 * 挂账时间（时间戳）.
 */
@property (nonatomic) long long signDate;
/**
 * 流水号.
 */
@property (nonatomic, strong) NSString *flowno;
/**
 * 订单id.
 */
@property (nonatomic, strong) NSString *orderId;
/**
 * 账单id.
 */
@property (nonatomic, strong) NSString *totalPayId;
/**
 * 挂账时间.
 */
@property (nonatomic, strong) NSString *displaySignDate;
/**
 * 签字人.
 */
@property (nonatomic, strong) NSString *signMemo;
/**
 * 签字人.
 */
@property (nonatomic, strong) NSString *time;

+ (SignBillNoPayVO *)convertToSignBillNoPayVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillNoPayList:(NSArray *)list;

@end
