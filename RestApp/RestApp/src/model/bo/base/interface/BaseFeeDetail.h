//
//  BaseFeeDetail.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseFeeDetail : EntityObject
/**
 * <code>费用名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>费用</code>.
 */
@property double fee;
/**
 * <code>费用计算方式</code>.
 */
@property short calBase;
/**
 * <code>费用计算基准</code>.
 */
@property int standard;
/**
 * <code>费用方案ID</code>.
 */
@property (nonatomic,retain) NSString *feePlanId;

@end
