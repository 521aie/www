//
//  ChainBusinessStatisticsMonth.m
//  RestApp
//
//  Created by 刘红琳 on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainBusinessStatisticsMonth.h"
#import "ObjectUtil.h"
@implementation ChainBusinessStatisticsMonth
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        self.orderMonth = [ObjectUtil getStringValue:dic key:@"orderMonth"];
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

@end
