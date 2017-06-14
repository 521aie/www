//
//  BaseMenuProducePlan.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseMenuProducePlan : EntityObject

/**
 * <code>出品方案ID</code>.
 */
@property (nonatomic,retain) NSString *prodPlanId;
/**
 * <code>菜肴或类别ID</code>.
 */
@property (nonatomic,retain) NSString *menuOrKindId;
/**
 * <code>类型</code>.
 */
@property short type;

@end
