//
//  BrandStatisticsVo.m
//  RestApp
//
//  Created by 刘红琳 on 16/2/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BrandStatisticsDayVo.h"
#import "ObjectUtil.h"

@implementation BrandStatisticsDayVo

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.plateId = [ObjectUtil getStringValue:dic key:@"plateId"];
        self.plateName	= [ObjectUtil getStringValue:dic key:@"plateName"];
        self.shopVoListArr = [ObjectUtil getArryValue:dic key:@"shopVoList"];
    }
    return self;
}
@end
