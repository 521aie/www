//
//  PantryAreaVO.h
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PantryAreaVO : NSObject
/**
 * PantryPlanArea
 */

@property (nonatomic ,strong) NSString *pantryAreaId ;
/**
 * area表id
 */
@property (nonatomic ,strong) NSString *areaId ;
/**
 * 区域名称
 */
@property (nonatomic ,strong) NSString *name ;
/**
 * 版本号
 */
@property (nonatomic ,assign) NSInteger lastVer;

@end
