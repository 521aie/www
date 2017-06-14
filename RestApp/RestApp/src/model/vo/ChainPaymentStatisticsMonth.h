//
//  ChainPaymentStatisticsMonth.h
//  RestApp
//
//  Created by 刘红琳 on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

//连锁-支付种类金额统计表（按月）
@interface ChainPaymentStatisticsMonth : Jastor

/**
 * 商户编码
 */
@property (nonatomic,copy)NSString *entityId;

/**
 * 订单日期
 */
@property (nonatomic,copy)NSString *orderMonth;

/**
 * 支付方式名称
 */
@property (nonatomic,copy)NSString *payKindName;

/**
 * 支付金额
 */
@property (nonatomic,assign) double payAmount;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
