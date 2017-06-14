//
//  BaseSpecDetail.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseSpecDetail : BaseSyncShop

/**
 * <code>规格</code>.
 */
@property (nonatomic,retain) NSString *specId;
/**
 * <code>价格调整比例或数值</code>.
 */
@property double priceScale;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>原料消耗比例</code>.
 */
@property double rawScale;
/**
 * <code>规格项名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;
/**
 * <code>调价模式</code>.
 */
@property short priceMode;

@end
