//
//  MenuMake.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseMenuMake.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "IMultiNameValueItem.h"


typedef enum
{
    MAKEPRICE_NONE=0,          //不加价.
    MAKEPRICE_TOTAL=1,         //一次性加价.
    MAKEPRICE_PERBUYACCOUNT=2, //每购买单位加价
    MAKEPRICE_PERUNIT=3        //每结账单位加价
}MENUMAKE_PRICEMODE_ENUM;

@interface MenuMake : BaseMenuMake<INameItem,INameValueItem,IMultiNameValueItem>

/** 烧法名称. */
@property (nonatomic,retain) NSString *name;

/** 菜肴名称. */
@property (nonatomic,retain) NSString *menuName;

@property BOOL checkVal;

@end
