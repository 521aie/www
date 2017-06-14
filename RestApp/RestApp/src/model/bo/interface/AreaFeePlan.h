//
//  AreaFeePlan.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseAreaFeePlan.h"
#import "INameItem.h"

@interface AreaFeePlan : BaseAreaFeePlan<INameItem>
/**
 * <code>区域名称</code>.
 */
@property (nonatomic,retain) NSString *areaName;

/**
 * <code>附加费名称</code>.
 */
@property (nonatomic,retain) NSString *feePlanName;

@property (nonatomic, strong) NSString *endDateStr;

@property (nonatomic , strong) NSString *startDateStr;

@end
