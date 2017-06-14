//
//  MenuProducePlan.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseMenuProducePlan.h"
#import "INameValueItem.h"
#import "IMenuDataItem.h"

typedef enum
{
    MENUPRODUCEPLAN_TYPE_KIND=0,   //分类
    MENUPRODUCEPLAN_TYPE_MENU=1,      //商品
}MENUPRODUCEPLAN_TYPE_Enum;

@interface MenuProducePlan : BaseMenuProducePlan<INameValueItem, IMenuDataItem>

/**
 * <code>菜肴名称</code>.
 */
@property (nonatomic,retain) NSString *menuName;

/**
 * <code>菜类名称</code>.
 */
@property (nonatomic,retain) NSString *kindName;

@end
