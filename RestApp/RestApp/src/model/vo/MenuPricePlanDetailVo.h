//
//  MenuPricePlanDetailVo.h
//  RestApp
//
//  Created by zishu on 16/10/18.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
@interface MenuPricePlanDetailVo : NSObject<INameValueItem>
@property(nonatomic, strong) NSString *pricePlanDetailId;

/**
 * 价格方案id
 */
@property(nonatomic, strong) NSString *pricePlanId;

/**
 * 价格方案名
 */
@property(nonatomic, strong) NSString *pricePlanName;

@property(nonatomic, strong) NSString *menuId;

/**
 * 商品类型（0：普通菜,1：套餐）
 */
@property(nonatomic, assign) int menuType;

/**
 * 价格
 */
@property(nonatomic, strong) NSString *menuPrice;
@property(nonatomic, assign) BOOL isChange;
@property(nonatomic, assign) BOOL isOldPrice;
@end
