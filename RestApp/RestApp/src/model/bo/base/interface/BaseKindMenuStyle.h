//
//  BaseKindMenuStyle.h
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseKindMenuStyle : EntityObject

/**
 * <code>排版风格</code>.
 */
@property short typeSet;
/**
 * <code>菜类风格属性</code>.
 */
@property short type;
/**
 * <code>菜肴菜类/菜谱菜类</code>.
 */
@property short kind;
/**
 * <code>菜谱Id</code>.
 */
@property (nonatomic,retain) NSString *bookId;
/**
 * <code>菜类Id</code>.
 */
@property (nonatomic,retain) NSString *kindId;
/**
 * <code>风格用途</code>.
 */
@property short usage;
/**
 * <code>展示风格ID</code>.
 */
@property (nonatomic,retain) NSString *styleId;

@end
