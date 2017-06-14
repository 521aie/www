//
//  BaseSuitMenuDetail.h
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseSuitMenuDetail : BaseSyncShop

/**
 * <code>套菜ID</code>.
 */
@property (nonatomic,retain) NSString *suitMenuId;
/**
 * <code>数量</code>.
 */
@property double num;
/**
 * <code>是否必选(必选/备选)</code>.
 */
@property short isRequired;
/**
 * <code>是否可换</code>.
 */
@property short isChange;
/**
 * <code>可换菜的选择范围</code>.
 */
@property short changeMode;
/**
 * <code>排序码</code>.
 */
@property int sortCode;
/**
 * <code>菜肴ID</code>.
 */
@property (nonatomic,retain) NSString * detailMenuId;

@property (nonatomic,retain) NSString * name;

@end
