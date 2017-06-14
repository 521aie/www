//
//  ChainBusinessStatisticsDay.h
//  RestApp
//
//  Created by 刘红琳 on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

//* 连锁-业务数据统计表（按天）
@interface ChainBusinessStatisticsDay : Jastor

/**
 * 商户ID
 */
@property (nonatomic,copy)NSString *entityId;
/**
 * 订单日期
 */
@property (nonatomic,copy)NSString *orderDate;
/**
 * 订单数量
 */
@property (nonatomic,assign)NSInteger orderCount;
/**
 * 就餐人数
 */
@property (nonatomic,assign)NSInteger mealsCount;
/**
 * 原始金额
 */
@property (nonatomic,assign)double sourceAmount;
/**
 * 实收金额
 */
@property (nonatomic,assign)double actualAmount;
/**
 * 折扣金额
 */
@property (nonatomic,assign)double discountAmount;
/**
 * 损益金额
 */
@property (nonatomic,assign)double profitLossAmount;
/**
 * 人均实收金额
 */
@property (nonatomic,assign)double actualAmountAvg;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (ChainBusinessStatisticsDay *)convertShopDetail:(NSDictionary *)dic;

@end
