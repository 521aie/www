//
//  TDFSwitchModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFSwitchModel : NSObject
/**
 * 权限名
 */
@property(nonatomic, strong) NSString *name;

/**
 * 门店EntityId
 */
@property(nonatomic, strong) NSString *entityId;

/**
 * 模块类型
 */
@property(nonatomic, assign) int moduleType;

/**
 * 开关状态
 */
@property(nonatomic, assign) NSNumber *status;
/**
 * 开关类型 （1：是否允许修改，2：是否允许新增,3允许门店自主管理）
 */

@property(nonatomic, assign) int switchType;

@end
