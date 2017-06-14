//
//  PaymentStatisticsVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
@interface PaymentStatisticsVo : Jastor
/**
 * 订单日期
 */
@property (nonatomic,copy)NSString *orderDate;

/**
 * 订单月份
 */
@property (nonatomic,copy)NSString *orderMonth;

/**
 * 支付类型
 */
@property (nonatomic,copy)NSString *payKindName;

/**
 * 支付金额
 */
@property (nonatomic,assign)double payAmount;

- (id)initWithDictionary:(NSDictionary *)dic;
@end
