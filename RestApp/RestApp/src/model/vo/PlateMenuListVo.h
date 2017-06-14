//
//  PlateMenuListVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlateMenuListVo : NSObject
/**
 * 品牌实体ID
 */
@property(nonatomic, strong) NSString *plateEntityId;

/**
 * 品牌名
 */
@property(nonatomic, strong) NSString *plateName;

/**
 * 品牌关联商品数量
 */
@property(nonatomic, assign) int menuCnt;

@property (nonatomic ,assign)BOOL  isSearch;

@end
