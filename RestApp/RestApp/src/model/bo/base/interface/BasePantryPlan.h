//
//  BasePantryPlan.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BasePantryPlan : EntityObject

/**
 * <code>配菜点ID</code>.
 */
@property (nonatomic,retain) NSString *pantryId;
/**
 * <code>出品方案ID</code>.
 */
@property (nonatomic,retain) NSString *producePlanId;
/**
 * <code>是否出全部区域</code>.
 */
@property short isAllArea;

@end
