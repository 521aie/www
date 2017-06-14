//
//  ShopStatisticsMonthVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "ChainBusinessStatisticsMonth.h"
#import "ChainPaymentStatisticsMonth.h"

// 单店汇总营业数据（按月）
@interface ShopStatisticsMonthVo : Jastor
/**
 * 店铺名称
 */
@property (nonatomic,copy)NSString *shopName;

/**
 * 店铺营业数据
 */
@property (nonatomic,strong)ChainBusinessStatisticsMonth *chainBusinessStatisticsMonth;

@property (nonatomic,strong)NSArray *paymentVoList;
- (id)initWithDictionary:(NSDictionary *)dic;
@end
