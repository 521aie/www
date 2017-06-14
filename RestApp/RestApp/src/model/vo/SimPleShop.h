//
//  SimPleShop.h
//  RestApp
//
//  Created by zishu on 16/10/14.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimPleShop : NSObject
/**
 * shop id
 */
@property(nonatomic, strong) NSString *entityId;
/**
 * 是否 有商品管理的权限
 */
@property(nonatomic, assign) int menuPower;
@end
