//
//  BaseSuitMenuChange.h
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseSuitMenuChange : BaseSyncShop

/**
 * <code>套菜子菜ID</code>.
 */
@property (nonatomic,retain) NSString * suitMenuDetailId;
/**
 * <code>菜肴ID</code>.
 */
@property (nonatomic,retain) NSString * menuId;
/**
 * <code>数量</code>.
 */
@property double num;

/**
 * <code>加价模式</code>.
 */
@property short priceMode;

/**
 * <code>加价</code>.
 */
@property double price;

/**
 * <code>顺序码</code>.
 */
@property int sortCode;

@property (nonatomic,retain) NSString * specDetailId;


@end
