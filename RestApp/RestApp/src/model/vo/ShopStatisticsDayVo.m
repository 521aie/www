//
//  ShopStatisticsDayVo.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopStatisticsDayVo.h"
#import "ObjectUtil.h"
#import "NSString+Estimate.h"

//当该门店没有品牌的时候，brandStatisticsVoList 是 null，则营业数据，取 shopshopStatisticsVoListVoList

@implementation ShopStatisticsDayVo
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
       
        NSDictionary *dict =  dic[@"chainBusinessStatisticsDay"];
        if ([ObjectUtil isNotEmpty:dict]) {
            self.chainBusinessStatisticsDay = [[ChainBusinessStatisticsDay alloc]initWithDictionary:dict];
        }
        self.paymentVoList = [ObjectUtil getArryValue:dic key:@"chainPaymentStatisticsDayList"];
    }
    return self;
}

@end
