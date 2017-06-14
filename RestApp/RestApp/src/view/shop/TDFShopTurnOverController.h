//
//  TDFShopTurnOverController.h
//  RestApp
//
//  Created by Cloud on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFRootViewController.h"
#import "TDFShopCompareItem.h"

typedef enum : NSUInteger {
    
    TDFShopTurnOverDateTypeDay,
    TDFShopTurnOverDateTypeMonth,
    
} TDFShopTurnOverDateType;

@interface TDFShopTurnOverController : TDFRootViewController

@property (nonatomic ,strong) TDFShopCompareItem *item;

@property (nonatomic ,assign) TDFShopTurnOverDateType dateType;

@end
