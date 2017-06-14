//
//  PlateMenuVo.h
//  RestApp
//
//  Created by zishu on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
@interface PlateMenuVo : NSObject<INameValueItem>

/**
 * 商品ID
 */
@property(nonatomic, strong) NSString *menuId;

/**
 * 商品名称
 */
@property(nonatomic, strong) NSString *menuName;

/**
 * 是否选中（0：否 / 1：是）
 */
@property(nonatomic, assign)int isSelected;
@end
