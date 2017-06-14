//
//  SimpleShopVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
#import "TDFSwitchModel.h"

@interface SimpleShopVo : NSObject<INameValueItem>
/**
 * shop id
 */
@property(nonatomic, strong) NSString *id;

/**
 * shop name
 */
@property(nonatomic, strong) NSString *name;

/**
 * 店铺 的entityId
 */
@property(nonatomic, strong) NSString *entityId;

/**
 * 店铺使用的价格方案名
 */
@property(nonatomic, strong) NSString *menuPricePlanName;

/**
 * 是否勾选
 */
@property(nonatomic, assign) BOOL selected;

/**
 * 1直营2加盟.
 */
@property(nonatomic, assign) int joinMode;

@property(nonatomic, copy) NSString *spell;

/**
 * 权限列表
 */
@property(nonatomic, copy) NSMutableArray *switchList;
@end
