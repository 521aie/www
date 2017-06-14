//
//  PaymentStatisticsVo.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaymentStatisticsVo.h"
#import "ObjectUtil.h"
@implementation PaymentStatisticsVo
- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.payKindName = [ObjectUtil getStringValue:dic key:@"payKindName"];
        self.payAmount	 = [ObjectUtil getDoubleValue:dic key:@"payAmount"];
    }
    return self;
}

@end
