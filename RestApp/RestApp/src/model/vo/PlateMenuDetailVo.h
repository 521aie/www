//
//  PlateMenuDetailVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateMenuVo.h"
@interface PlateMenuDetailVo : NSObject<INameValueItem>

/**
 * 菜类ID
 */
@property(nonatomic, strong) NSString *kindMenuId;

/**
 * 菜类名称
 */
@property(nonatomic, strong) NSString *kindMenuName;

/**
 * 父级菜类名称
 */
@property(nonatomic, strong) NSString *parentKindMenuName;

/**
 * 是否选中（0：否 / 1：是）
 */
@property(nonatomic, assign) int isSelected;

/**
 * 菜类下商品列表
 */
@property(nonatomic, strong) NSMutableArray *plateMenuVos;
@end
