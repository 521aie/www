//
//  EmployeeUserVo.h
//  RestApp
//
//  Created by zishu on 16/7/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "Employee.h"
#import "UserVO.h"
#import "ExtraAction.h"
#import "BranchVo.h"
#import "Plate.h"
#import "ShopVO.h"

@interface EmployeeUserVo : Jastor

/**
 * 员工信息
 */
@property(nonatomic, strong) Employee* employeeVo;

/**
 * 账号信息
 */
@property(nonatomic, strong) UserVO* userVo;

/**
 * 门店的额外权限
 * 当门店管理门店员工时,使用此字段.
 */
@property(nonatomic, strong) NSMutableArray *extraActionVoList;

/**
 * 员工可管理的分公司
 */

@property(nonatomic, strong) NSMutableArray *userBranchVoList;

/**
 * 员工可管理的门店
 */

@property(nonatomic, strong) NSMutableArray *userShopVoList;

/**
 * 员工可管理的品牌
 */

@property(nonatomic, strong) NSMutableArray *userPlateVoList;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
