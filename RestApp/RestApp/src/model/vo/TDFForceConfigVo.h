//
//  TDFForceConfigVo.h
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFForceSpecificationVo.h"
#import "TDFForceMakeVo.h"
@interface TDFForceConfigVo : NSObject<NSCopying>

/**
 * 序列ID
 */
@property (nonatomic, assign)long serialVersionUID;

/**
 * 必选商品配置ID
 */
@property (nonatomic, strong)NSString* configId;

/**
 * 实体ID
 */
@property (nonatomic, strong)NSString* entityId;

/**
 * 商品ID
 */
@property (nonatomic, strong)NSString* menuId;

/**
 * 商品类型（0:普通菜,1:套菜,2:加料菜）
 */
@property (nonatomic, assign)int menuType;

/**
 * 强制类型（0:指定数量,1:与用餐人数相同）
 */
@property (nonatomic, assign)int forceType;

/**
 * 强制点菜数量（当强制类型为"与用餐人数相同"时无视此数量）
 */
@property (nonatomic, assign)int forceNum;

/**
 * 已设置的做法
 */
@property (nonatomic, strong)TDFForceMakeVo *make;

/**
 * 已设置的规格
 */
@property (nonatomic, strong)TDFForceSpecificationVo *spec;

/**
 * 强制类型数组
 */

+ (NSArray *)forceNumArray;
/**
 * 强制类型数组
 */

+ (NSArray *)forceTypeArray;

@end
