//
//  ChainStatisticsMonthVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "BusinessStatisticsVo.h"
#import "PaymentStatisticsVo.h"

//连锁总部汇总营业数据（按月）
@interface ChainStatisticsMonthVo : Jastor

/**
 * 营业日期(yyyyMM)
 */
@property (nonatomic,copy)NSString *businessMonth;

/**
 * 营业数据
 */
@property (nonatomic,strong)BusinessStatisticsVo *businessStatisticsVo;

- (id)initWithDictionary:(NSDictionary *)dic;
- (NSMutableArray *)convertToPaymentStatisticsVoListByArr:(NSArray *)paymentStatisticsVoVoList;

@end
