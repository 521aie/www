//
//  ChainStatisticsMonthVo.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainStatisticsMonthVo.h"
#import "ObjectUtil.h"
@implementation ChainStatisticsMonthVo
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.businessMonth = [ObjectUtil getStringValue:dic key:@"businessMonth"];
        NSDictionary *dict =  dic[@"businessStatisticsVo"];
        if ([ObjectUtil isNotEmpty:dict]) {
            self.businessStatisticsVo = [[BusinessStatisticsVo alloc]initWithDictionary:dict];
        }
    }
    return self;
}

// /*** 各支付种类数据*/
- (NSMutableArray *)convertToPaymentStatisticsVoListByArr:(NSArray *)paymentStatisticsVoVoList
{
    NSMutableArray *paymentStatisticsList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:paymentStatisticsVoVoList]) {
        for (NSDictionary *dictionary in paymentStatisticsVoVoList) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                PaymentStatisticsVo *paymentStatisticsVo = [[PaymentStatisticsVo alloc]initWithDictionary:dictionary];
                [paymentStatisticsList addObject:paymentStatisticsVo];
            }
        }
        return paymentStatisticsList;
    }
    return nil;
}

@end
