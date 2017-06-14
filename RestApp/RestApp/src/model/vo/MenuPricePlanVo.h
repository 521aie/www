//
//  MenuPricePlanVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleBranchVo.h"
@interface MenuPricePlanVo : NSObject<INameValueItem>
@property(nonatomic, strong) NSString *pricePlanId;
/**
 * 价格方案 名字
 */
@property(nonatomic, strong) NSString *pricePlanName;
@property(nonatomic, strong) NSString *entityId;
/**
 * 使用此价格方案的 店铺数量
 */
@property(nonatomic, assign) int shopCount;

/**
 * 分公司 门店 列表
 */
@property(nonatomic, strong) NSMutableArray *simpleBranchVoList;
@property(nonatomic, assign) int lastVer;

@end
