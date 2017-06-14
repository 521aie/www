//
//  PantryPlan.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BasePantryPlan.h"

@interface PantryPlan : BasePantryPlan

/**
 * <code>出品方案名称</code>.
 */
@property (nonatomic,retain) NSString *producePlanName;

/**
 * <code>绑定的区域集合</code>.
 */
@property (nonatomic,strong) NSMutableArray* areaIds;

/**
 * <code>区域名称</code>.
 */
@property (nonatomic,retain) NSString *areaName;

+(id) areaIds_class;
@end
