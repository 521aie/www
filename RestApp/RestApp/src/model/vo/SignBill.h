//
//  SignBill.h
//  RestApp
//
//  Created by Shaojianqing on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBill : NSObject
/**
 * id.
 */
@property (nonatomic, strong) NSString *signBillId;
/**
 * 挂账人id.
 */
@property (nonatomic, strong) NSArray *kindPayDetailOptionId;
/**
 * 挂账人名称.
 */
@property (nonatomic, strong) NSString *company;
/**
 * 挂账金额.
 */
@property (nonatomic) double fee;
/**
 * 实收额.
 */
@property (nonatomic) double realFee;
/**
 * 操作员.
 */
@property (nonatomic, strong) NSString *operatorName;
/**
 * 付款方式.
 */
@property (nonatomic, strong) NSString *payName;
/**
 * 处理时间.
 */
@property (nonatomic) long long payTime;
/**
 * 备注.
 */
@property (nonatomic, strong) NSString *memo;
/**
 * 还款类型.
 */
@property (nonatomic, strong) NSString *payModeId;
/**
 * 店铺唯一标识.
 */
@property (nonatomic, strong) NSString *entityId;
/**
 * 还款日期.
 */
@property (nonatomic, strong) NSString *displayCreateTime;

/**
 * 还款人.
 */
@property (nonatomic, strong) NSString *signBillPerson;

+ (SignBill *)convertToSignBill:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillList:(NSArray *)list;

@end
