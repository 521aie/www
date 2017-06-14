//
//  MenuTimePrice.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseMenuTimePrice.h"
#import "INameValueItem.h"
#import "IMenuDataItem.h"

@interface MenuTimePrice : BaseMenuTimePrice<INameValueItem, IMenuDataItem>

/** 菜肴名称 */
@property (nonatomic,retain) NSString *menuName;

/** 菜类名称 */
@property (nonatomic,retain) NSString *kindMenuName;

@property (nonatomic) double menuPrice;

@end
