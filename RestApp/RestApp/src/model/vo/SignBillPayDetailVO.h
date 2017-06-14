//
//  SignBillPayDetailVO.h
//  RestApp
//
//  Created by Shaojianqing on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignBillPayDetailVO : NSObject
/**
 * 挂账单Id.
 */
@property (nonatomic, strong) NSString *payId;
/**
 * 挂账金额.
 */
@property (nonatomic) double pay; //已弃用
/**
 * 处理时间.
 */
@property (nonatomic) long long payTime;
/**
 * 流水号.
 */
@property (nonatomic, strong) NSString *code; //已弃用
/**
 * 操作人.
 */
@property (nonatomic, strong) NSString *userName;
/**
 * 挂账类型.
 */
@property (nonatomic, strong) NSString *kindPayName;
/**
 * 挂账时间.
 */
@property (nonatomic, strong) NSString *displaySignDate;
/**
 * 签字人.
 */
@property (nonatomic, strong) NSString *signMemo;

/**
 * 流水号.
 */
@property (nonatomic, strong) NSString *flowNo;
/**
 * 挂账金额.
 */
@property (nonatomic) double fee;

+ (SignBillPayDetailVO *)convertToSignBillPayDetailVO:(NSDictionary *)dictionary;

+ (NSMutableArray *)convertToSignBillPayDetailList:(NSArray *)list;

@end
