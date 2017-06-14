//
//  BaseMenuSpecDetail.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

#define ADDMODE_AUTO 1
#define ADDMODE_HAND 2

@interface BaseMenuSpecDetail : BaseSyncShop

/**
 * <code>原料消耗比例</code>.
 */
@property double rawScale;
/**
 * <code>菜肴ID</code>.
 */
@property (nonatomic,retain) NSString *menuId;
/**
 * <code>规格项ID</code>.
 */
@property (nonatomic,retain) NSString *specItemId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>调价模式</code>.
 */
@property short priceMode;
/**
 * <code>价格调整比例</code>.
 */
@property double priceScale;
/**
 * <code>加价属性</code>
 * =1 自动计算, =2 手动设置.
 */
@property short addMode;

@end
