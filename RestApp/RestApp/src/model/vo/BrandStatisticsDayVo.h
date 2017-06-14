//
//  BrandStatisticsVo.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface BrandStatisticsDayVo : Jastor

/**
 * 品牌id
 */
@property(nonatomic, strong) NSString *plateId;

/**
 * 品牌名称
 */
@property(nonatomic, strong) NSString *plateName;

@property(nonatomic, strong) NSArray *shopVoListArr;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
