//
//  TDFMenuHitRuleVo.h
//  RestApp
//
//  Created by xueyu on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
@interface TDFMenuHitRuleVo : NSObject <INameValueItem>
/**
 *  计价规则Id
 */
@property (nonatomic, copy) NSString *ruleId;

/**
 *  价格
 */
@property (nonatomic, assign) double price;

/**
 *  版本号
 */
@property (nonatomic, assign) long lastVer;

/**
 *  商品
 */
@property (nonatomic, strong) NSArray *items;

@end







@interface TDFMenuItem : NSObject<INameValueItem>
/**
 *  商品Id
 */
@property (nonatomic, copy) NSString *menuId;

/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *menuName;

@end









@interface TDFMenuDetailVo :NSObject<INameValueItem>

/**
 *  套餐分组id
 */
@property (nonatomic, copy) NSString *menuDetailId;

/**
 *  分组名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  套餐Id
 */
@property (nonatomic, copy) NSString *suitMenuId;

/**
 *  商品
 */
@property (nonatomic, strong) NSArray *items;
@end
