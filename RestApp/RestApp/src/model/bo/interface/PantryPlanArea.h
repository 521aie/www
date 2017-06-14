//
//  PantryPlanArea.h
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-10-29.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BasePantryPlanArea.h"
#import "INameValueItem.h"

@interface PantryPlanArea : BasePantryPlanArea<INameValueItem>

/**
 * <code>区域ID</code>.
 */
@property (nonatomic,strong) NSString* areaName;

@property (nonatomic, strong) NSString *name;

@property (nonatomic ,strong) NSString *pantryAreaId;

@end
