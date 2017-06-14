//
//  TDFPlatePublishVo.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/22.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChainPublishHistoryVo.h"

@interface TDFPlatePublishVo : NSObject
/**
 * 品牌实体ID
 */
@property (nonatomic ,strong) NSString  *plateEntityId;

/**
 * 品牌名
 */
@property (nonatomic ,strong) NSString  * plateName;

/**
 * 发布计划ID
 */
@property (nonatomic ,strong) NSString  * publishPlanId;

/**
 * 发布状态(0:待发布，1:发布中，2:发布失败，3:重试待发布)
 */
@property int publishStatus;

/**
 * 发布状态描述
 */
@property (nonatomic ,strong) NSString  * publishStatusDesc;

/**
 * 发布日期
 */
@property  long publishDate;

/**
 * 时间区间
 */
@property(nonatomic ,strong)  NSString  * timeInterval;

/**
 * 品牌下是否有商品（0：没有，1：有）
 */
@property  (nonatomic ,assign) BOOL hasMenu;

/**
 * 品牌下是否有门店（0：没有，1：有）
 */
@property(nonatomic ,assign)  BOOL hasShop;

/**
 * 发布历史
 */
@property (nonatomic ,strong)ChainPublishHistoryVo * history;

+(NSString *)getPublishStatusString:(NSInteger)status;
+ (UIColor *)getPublishStatusColor:(NSInteger)status;
+ (BOOL) isHideWithPublishStatus:(NSInteger)status;
+ (NSInteger)getFialureStatus:(NSInteger)status;
+ (BOOL)isWaitWithStatus:(NSInteger)status;

@end
