//
//  ShopStatisticsDayVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "ChainBusinessStatisticsDay.h"
#import "ChainPaymentStatisticsDay.h"

// * 单店汇总营业数据（按天）
@interface ShopStatisticsDayVo : Jastor

/**
 * 店铺名称
 */
@property (nonatomic,strong)NSString *shopName;

/**
 * 店铺营业数据
 */
@property (nonatomic,strong)ChainBusinessStatisticsDay *chainBusinessStatisticsDay;

@property (nonatomic,strong)NSArray *paymentVoList;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
