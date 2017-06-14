//
//  TDFPackingBoxKindVo.h
//  RestApp
//
//  Created by 栀子花 on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFPackingBoxKindVo : NSObject
/**
 * 菜类ID
 */
@property (nonatomic, strong)NSString *kindMenuId;

/**
 * 菜类名称
 */
@property (nonatomic, strong)NSString *kindMenuName;
/**
 * 餐盒列表Vo
 */
@property (nonatomic, strong)NSArray *packingBoxVoList;

@end
