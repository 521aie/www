//
//  BaseUserDiscountPlanVO.h
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserDiscountPlan.h"
#import "INameItem.h"
#import "INameValueItem.h"

@interface UserDiscountPlanVO : UserDiscountPlan<INameItem,INameValueItem>

@property (nonatomic, strong) NSString *userName;

@end
