//
//  ChainPublishHistoryVo.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateMenuVoList.h"
#import "PlateShopVoList.h"
@interface ChainPublishHistoryVo : NSObject
/**
 * 发布计划ID
 */
@property (nonatomic ,strong)   NSString * publishPlanId;

/**
 * 发布状态(0:发布成功，1:发布失败)
 */
@property (nonatomic ,assign)  int publishStatus;

/**
 * 发布状态描述
 */
@property (nonatomic ,strong)   NSString *  publishStatusDesc;

/**
 * 发布时间
 */
@property (nonatomic ,strong)  NSString *publishDate;

/**
 * 时间区间
 */
@property (nonatomic ,strong)   NSString * timeInterval;

/**
 * 品牌实体ID
 */
@property (nonatomic ,strong)   NSString *  plateEntityId;

/**
 * 品牌名称
 */
@property (nonatomic ,strong)   NSString *  plateName;

/**
 * 发布商品个数
 */
@property (nonatomic ,assign)  int menuCount;

/**
 * 发布门店个数
 */
@property (nonatomic ,assign)  int shopCount;


/**
 * 发布失败门店个数
 */
@property (nonatomic ,assign)  int  failShopCount;
/**
 * 发布商品列表
 */
@property (nonatomic ,strong)  NSMutableArray * plateMenuVoList;

/**
 * 发布失败门店列表
 */
@property (nonatomic ,strong)  NSMutableArray * plateShopVoList;
@end
