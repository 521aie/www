//
//  TDFForceMenuVo.h
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFForceConfigVo.h"

@interface TDFForceMenuVo : NSObject

/**
 * 商品ID
 */
@property (nonatomic, strong)NSString *menuId;

/**
 * 序列ID
 */
@property (nonatomic, assign)long serialVersionUID;

/**
 * 商品名称
 */
@property (nonatomic, strong)NSString *menuName;

/**
 * 菜类ID
 */
@property (nonatomic, strong)NSString *kindMenuId;

/**
 * 商品类型（0:普通菜,1:套菜,2:加料菜）
 */
@property (nonatomic, assign)int menuType;

/**
 * 商品价格
 */
@property (nonatomic, assign)double price;

/**
 * 结账单位
 */
@property (nonatomic, strong)NSString *account;

/**
 * 商品图片（只有URI，域名客户端自己配置）
 */
@property (nonatomic, strong)NSString *path;

/**
 * 是否必选商品
 */
@property (nonatomic, assign)int isForceMenu;

/**
 * 必选商品配置
 */
@property (nonatomic, strong)TDFForceConfigVo* forceConfigVo;

/**
 * 做法列表
 */
@property (nonatomic, strong)NSArray *makeList;

/**
 * 规格列表
 */
@property (nonatomic, strong)NSArray *specList;

/**
 * 商品是否上架 （0：下架 / 1:上架 ）
 */
@property (nonatomic, assign)int isSelf;

/**
 * 客户端是否可点（0:不可点 / 1:可点）
 */
@property (nonatomic, assign)int isReserve;

/**
 * 是否仅在套餐显示（0:否 / 1:是）
 */
@property (nonatomic, assign)int isMealOnly;

@end
