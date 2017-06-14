//
//  TDFPublishInfoVo.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/22.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"
#import "NameItemVO.h"
@interface TDFPublishInfoVo : NSObject
/**
 * 品牌实体ID
 */
@property (nonatomic ,strong)NSString  *plateEntityId;

/**
 * 品牌名称
 */
@property (nonatomic ,strong)NSString  *plateName;

/**
 * 发布计划ID
 */
@property (nonatomic ,strong)NSString  * publishPlanId;

/**
 * 发布商品
 */
@property(nonatomic ,strong) NSArray  *publishMenuVoList;

/**
 * 发布门店
 */
@property(nonatomic ,strong) NSArray *publishShopVoList;

@property (nonatomic ,strong) NSArray *timeIntervalList;



+(NameItemVO *)getCurrentData:(NSMutableArray *)discountTypeList  IteamId:(NSString *)iteamId;//获取当前选中
+ (NSMutableArray *)getTimeIntervalListWithArry:(NSArray *)timeList;//获取列表时段

@end
