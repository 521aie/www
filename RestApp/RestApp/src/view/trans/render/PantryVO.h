//
//  PantryVO.h
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@interface PantryVO : NSObject <INameValueItem>
/**
 * 主键id
 */

@property (nonatomic ,strong) NSString *pantryId ;
/**
 * 商家id
 */

@property (nonatomic ,strong) NSString *entityId ;
/**
 * 名称
 */
@property (nonatomic ,strong) NSString *name ;

/**
 * 是否配全部方案.
 */

@property (nonatomic ,assign) NSInteger isAllPlan ;
/**
 * 是否自动切单.
 */

@property (nonatomic ,assign) NSInteger isAutoPrin ;
/**
 * 打印机Ip.
 */

@property (nonatomic ,strong) NSString *printerIp;
/**
 * 每行字符数.
 */
@property (nonatomic ,assign) NSInteger charCount;
/**
 * 是否自动切单.
 */
@property (nonatomic ,assign) NSInteger isCut;
/**
 * 打印份数
 */

@property (nonatomic ,assign) NSInteger printNum;
/**
 * 是否打印总单
 */

@property (nonatomic ,assign) NSInteger isTotalPrint;

/**
 * 打印纸宽度对应字段
 */

@property (nonatomic ,assign) NSInteger paperWidth;

/**
 * 关联的出品方案字符串
 */
@property (nonatomic ,strong) NSString *producePlanStr ;

/**
 * 关联的出品方案集合
 */
@property (nonatomic ,strong) NSMutableArray *pantryPlans ;
/**
 * 是否出全部区域
 */
@property (nonatomic ,assign) NSInteger isAllArea;
/**
 * 出品方案ID
 */
@property (nonatomic ,strong) NSString *producePlanId;
/**
 * 打印机类型
 */
@property (nonatomic ,strong) NSString *printerType ;

/**
 * 打印机名称
 */
@property (nonatomic ,strong) NSString *printerTypeName ;

@end
