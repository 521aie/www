//
//  ShopStatisticsMonthVo.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopStatisticsMonthVo.h"
#import "ObjectUtil.h"
@implementation ShopStatisticsMonthVo

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        
        NSDictionary *dict =  dic[@"chainBusinessStatisticsMonth"];
        if ([ObjectUtil isNotEmpty:dict]) {
            self.chainBusinessStatisticsMonth = [[ChainBusinessStatisticsMonth alloc]initWithDictionary:dict];
        }
        self.paymentVoList = [ObjectUtil getArryValue:dic key:@"chainPaymentStatisticsMonthList"];
    }
    return self;
}

@end
