//
//  BaseUserShop.h
//  RestApp
//
//  Created by 刘红琳 on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseEntity.h"

@interface BaseUserShop : BaseEntity
/**
 * <code>用户ID</code>.
 */
@property (nonatomic, strong) NSString *userId;
/**
 * <code>餐店ID</code>.
 */
@property (nonatomic, strong) NSString *shopId;

@end
