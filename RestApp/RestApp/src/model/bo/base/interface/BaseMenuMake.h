//
//  BaseMenuMake.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseMenuMake : BaseSyncShop
/**
 * <code>菜肴ID</code>.
 */
@property (nonatomic,retain) NSString *menuId;
/**
 * <code>烧法ID</code>.
 */
@property (nonatomic,retain) NSString *makeId;
/**
 * <code>烧法加价</code>.
 */
@property double makePrice;
/**
 * <code>调价模式</code>.
 */
@property short makePriceMode;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;

@end
