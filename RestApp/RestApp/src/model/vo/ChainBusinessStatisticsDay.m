//
//  ChainBusinessStatisticsDay.m
//  RestApp
//
//  Created by 刘红琳 on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainBusinessStatisticsDay.h"
#import "ObjectUtil.h"
@implementation ChainBusinessStatisticsDay
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        self.orderDate = [ObjectUtil getStringValue:dic key:@"orderDate"];
        self.orderCount = [ObjectUtil getIntegerValue:dic key:@"orderCount"];
        self.mealsCount = [ObjectUtil getIntegerValue:dic key:@"mealsCount"];
        self.sourceAmount = [ObjectUtil getDoubleValue:dic key:@"sourceAmount"];
        self.actualAmount = [ObjectUtil getDoubleValue:dic key:@"actualAmount"];
        self.discountAmount = [ObjectUtil getDoubleValue:dic key:@"discountAmount"];
        self.profitLossAmount = [ObjectUtil getDoubleValue:dic key:@"profitLossAmount"];
        self.actualAmountAvg = [ObjectUtil getDoubleValue:dic key:@"actualAmountAvg"];
    }
    return self;
}
+ (ChainBusinessStatisticsDay *)convertShopDetail:(NSDictionary *)dic

{
    if ([ObjectUtil isNotEmpty:dic]) {
        ChainBusinessStatisticsDay * day  =[[ChainBusinessStatisticsDay alloc]init];
        day.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        day.orderDate = [ObjectUtil getStringValue:dic key:@"orderDate"];
        day.orderCount = [ObjectUtil getIntegerValue:dic key:@"orderCount"];
        day.mealsCount = [ObjectUtil getIntegerValue:dic key:@"mealsCount"];
        day.sourceAmount = [ObjectUtil getDoubleValue:dic key:@"sourceAmount"];
        day.actualAmount = [ObjectUtil getDoubleValue:dic key:@"actualAmount"];
        day.discountAmount = [ObjectUtil getDoubleValue:dic key:@"discountAmount"];
        day.profitLossAmount = [ObjectUtil getDoubleValue:dic key:@"profitLossAmount"];
        day.actualAmountAvg = [ObjectUtil getDoubleValue:dic key:@"actualAmountAvg"];
        
        return day;
    }
    else
        return nil;
}
@end
