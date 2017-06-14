//
//  MenuSpecDetail.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseMenuSpecDetail.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "IMultiNameValueItem.h"

typedef enum {
    PRICE_MODE_SCALE=1,
    PRICE_MODE_ADD=2
} MENUSPECDETAIL_PRICEMODE_ENUM;

@interface MenuSpecDetail : BaseMenuSpecDetail<INameItem,INameValueItem,IMultiNameValueItem>

/* 规格名称 */
@property (nonatomic, retain) NSString *specDetailName;
/* 规格名称 */
@property (nonatomic, retain) NSString *name;

/* 菜肴名称 */
@property (nonatomic, retain) NSString *menuName;

/* 菜肴价格 */
@property (nonatomic, assign) double menuPrice;

/* 价格比例 */
@property (nonatomic, assign) double priceRatio;

/* 默认价格 */
@property (nonatomic, assign) double defaultPrice;

/* 自定义价格 */
@property (nonatomic, assign) double definePrice;

@property (nonatomic, assign) BOOL checkVal;

@end

