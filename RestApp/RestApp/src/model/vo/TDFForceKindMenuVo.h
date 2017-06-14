//
//  TDFForceKindMenuVo.h
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFForceKindMenuVo : NSObject

/**
 * 序列ID
 */
@property (nonatomic, assign)long serialVersionUID;

/**
 * 菜类ID
 */
@property (nonatomic, strong)NSString *kindMenuId;

/**
 * 菜类名称
 */
@property (nonatomic, strong)NSString *kindMenuName;

/**
 * 父级菜类名称（多级菜类时拼到一起）
 */
@property (nonatomic, strong)NSString *parentKindMenuName;

/**
 * 实体ID
 */
@property (nonatomic, strong)NSString *entityId;

/**
 * 父级菜类ID
 */
@property (nonatomic, strong)NSString *parentKindMenuId;

/**
 * 商品Vo
 */
@property (nonatomic, strong)NSArray *forceMenuVoList;

@end
