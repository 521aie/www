//
//  BaseUserDiscountPlan.h
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseUserDiscountPlan : EntityObject

/**
 * <code>用户Id</code>.
 */
@property (nonatomic,retain) NSString *userId;
/**
 * <code>打折方案Id</code>.
 */
@property (nonatomic,retain) NSString *discountPlanId;

@end
