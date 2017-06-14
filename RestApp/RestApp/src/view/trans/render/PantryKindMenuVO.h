//
//  PantryKindMenuVO.h
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PantryKindMenuVO : NSObject
/**
 * 主键id
 */

@property (nonatomic ,strong) NSString *menuId ;
/**
 * 类别名字
 */
@property (nonatomic ,strong) NSString *name ;
/**
 * 版本号
 */
@property (nonatomic ,assign) NSInteger lastVer ;
/**
 * 分类下菜肴
 */
//private List<PantryMenuVO> menus = new ArrayList<>();
@property (nonatomic ,strong) NSMutableArray *menus;

/**
 * 类别id
 */

@property (nonatomic ,strong) NSString *kindId ;
@end
