//
//  BasePantryPlanArea.h
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-10-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BasePantryPlanArea : EntityObject
/**
 * <code>配菜方案关联ID</code>.
 */
@property (nonatomic,strong) NSString *pantryPlanId;
/**
 * <code>区域ID</code>.
 */
@property (nonatomic,strong) NSString *areaId;

@end
