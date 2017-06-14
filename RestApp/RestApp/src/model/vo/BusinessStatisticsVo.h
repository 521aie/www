//
//  BusinessStatisticsVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface BusinessStatisticsVo : Jastor

/**
 * 订单日期
 */
@property(nonatomic, strong) NSString *orderDate;

/**
 * 订单月份
 */
@property(nonatomic, strong) NSString *orderMonth;

/*
 *订单数量*
 */
@property(nonatomic, assign) int orderCount;

/*
 *就餐人数
 */
@property(nonatomic, assign) int mealsCount;

/*
 *营业额
 */
@property(nonatomic, assign) double sourceAmount;

/*
 *实收金额
 */
@property(nonatomic, assign) double actualAmount;

/*
 * 折扣金额. 
 */
@property(nonatomic, assign) double discountAmount;

/*
 * 损益金额.
 */
@property(nonatomic, assign) double profitLossAmount;

/*
 * 实收人均金额. 
 */
@property(nonatomic, assign) double actualAmountAvg;

@property(nonatomic, assign) NSInteger shopCount;

@property (nonatomic ,assign) NSInteger count;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end