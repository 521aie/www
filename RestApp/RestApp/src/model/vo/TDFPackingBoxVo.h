//
//  TDFPackingBoxVo.h
//  RestApp
//
//  Created by 栀子花 on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFPackingBoxVo : NSObject
/**
 * 商品ID
 */
@property (nonatomic, strong)NSString *menuId;

/**
 * 商品名称
 */
@property (nonatomic, strong)NSString *menuName;

/**
 * 菜类ID
 */
@property (nonatomic, strong)NSString *kindMenuId;
/**
 * 商品价格
 */
@property (nonatomic, assign)double price;
/**
 * 是否选中
 */
@property (nonatomic, assign)BOOL isSelected;
@end
