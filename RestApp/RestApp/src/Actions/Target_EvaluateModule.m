//
//  Target_EvaluateModule.m
//  RestApp
//
//  Created by iOS香肠 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFEvaluateListViewController.h"
#import "Target_EvaluateModule.h"
#import "TotalEvaluateView.h"
#import "ShopEvaluateView.h"
#import "WaiterEvaluateView.h"
#import "WaiterDetailView.h"
#import "SystemUtil.h"

@implementation Target_EvaluateModule

///评价功能列表
- (UIViewController *)Action_nativeTDFEvaluateListViewController:(NSDictionary *)params
{
    TDFEvaluateListViewController *viewController = [TDFEvaluateListViewController new];
    viewController.codeArray = params[@"data"][@"actionCodeArrs"];
    viewController.childFunctionArr = params[@"data"][@"isOpenFunctionArrs"];
    return viewController;
}

- (UIViewController *)Action_nativeTotalEvaluateViewController:(NSDictionary *)params
{
    TotalEvaluateView *totalEvaluateView =[[TotalEvaluateView alloc] init];
    return totalEvaluateView;
}

-(UIViewController *)Action_nativeShopEvaluateViewController:(NSDictionary *)params
{
    ShopEvaluateView *shopEvaluateView =[[ShopEvaluateView  alloc] init];
     return shopEvaluateView;
}

- (UIViewController *)Action_nativeWaiterEvaluateViewController:(NSDictionary *)params
{
    WaiterEvaluateView *waiterEvaluateView =[[WaiterEvaluateView alloc] init];
    return waiterEvaluateView;
}


- (UIViewController *)Action_nativeWaiterDetailViewController:(NSDictionary *)params
{
    WaiterDetailView *waiterDetailView =[[WaiterDetailView alloc] init];
    waiterDetailView.param = params;
    return waiterDetailView;
}

@end
