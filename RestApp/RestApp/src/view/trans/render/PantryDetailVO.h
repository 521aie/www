//
//  PantryDetailVO.h
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PantryDetailVO : NSObject

/**
 * 主键id
 */
@property (nonatomic ,strong) NSString *pantryId;
/**
 * 是否包含全区域
 */
@property (nonatomic ,assign) NSInteger  isAllArea ;
/**
 * 传菜区域
 */
//private List<PantryAreaVO> areas = new ArrayList<>();
@property (nonatomic ,strong) NSMutableArray *areas;
/**
 * 传菜的分类
 */
//private List<PantryKindMenuVO> menuKinds = new ArrayList<>();
@property (nonatomic ,strong) NSMutableArray *menuKinds;
/**
 * 传菜的商品
 */
//private List<PantryMenuVO> menus = new ArrayList<>();
@property (nonatomic ,strong) NSMutableArray *menus;

/**
 * 版本号
 */
@property (nonatomic ,assign) NSInteger lastVer ;
@end
