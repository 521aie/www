//
//  BaseFeePlan.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseFeePlan : EntityObject

/**
 * <code>套餐名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>最低消费</code>.
 */
@property double minConsume;
/**
 * <code>最低消费类型</code>.
 */
@property short minConsumeKind;
/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString *memo;

@end
