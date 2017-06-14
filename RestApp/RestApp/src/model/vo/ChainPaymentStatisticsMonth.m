//
//  ChainPaymentStatisticsMonth.m
//  RestApp
//
//  Created by 刘红琳 on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainPaymentStatisticsMonth.h"
#import "ObjectUtil.h"
@implementation ChainPaymentStatisticsMonth
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        self.orderMonth = [ObjectUtil getStringValue:dic key:@"orderMonth"];
        self.payKindName = [ObjectUtil getStringValue:dic key:@"payKindName"];
        self.payAmount = [ObjectUtil getDoubleValue:dic key:@"payAmount"];
    }
    return self;
}

@end
