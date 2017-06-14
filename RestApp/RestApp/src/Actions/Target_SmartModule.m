//
//  Target_SmartModel.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//


#import "SystemUtil.h"
#import "OrderListView.h"
#import "orderSetView.h"
#import "orderRecommendView.h"
#import "Target_SmartModule.h"
#import "orderDetailsView.h"
#import "orderRemindView.h"
#import "SpecialTagListView.h"
#import "SpecialTagEditView.h"
#import "TDFOrderRdDetailViewController.h"


@implementation Target_SmartModule

- (UIViewController *)Action_nativeTDFSmartOrderModuleViewController:(NSDictionary *)params{
    OrderListView *orderListView = [[OrderListView alloc] initWithNibName:@"OrderListView" bundle:nil parent:nil];
    orderListView.needHideOldNavigationBar = YES;
    return orderListView;
}


-  (UIViewController *)Action_nativeOrderListViewController:(NSDictionary *)params
{
    OrderListView *orderListView = [[OrderListView alloc] initWithNibName:@"OrderListView" bundle:nil parent:nil];
    orderListView.needHideOldNavigationBar = YES;
    return orderListView;
}

- (UIViewController *)Action_nativeOrderSetViewController:(NSDictionary *)params
{
    orderSetView *orderSet = [[ orderSetView  alloc] init];
    orderSet.needHideOldNavigationBar = YES;
    return orderSet;
}

- (UIViewController *)Action_nativeOrderRecommendViewController:(NSDictionary *)params
{
    orderRecommendView *orderRecommend = [[orderRecommendView alloc] init];
    orderRecommend.needHideOldNavigationBar = YES;
    return orderRecommend ;
}

- (UIViewController *)Action_nativeOrderRdDetailViewController:(NSDictionary *)params
{
    TDFOrderRdDetailViewController *orderRdDetail = [[TDFOrderRdDetailViewController  alloc] initWithparent:nil ];
    orderRdDetail.dic =[NSDictionary dictionaryWithDictionary:params];
    return orderRdDetail;
}

- (UIViewController *)Action_nativeOrderDetailsViewController:(NSDictionary *)params
{
    orderDetailsView *orderDetails = [[orderDetailsView  alloc]  initWithNibName:@"orderDetailsView" bundle:nil parent:nil];
    orderDetails.dic = [NSDictionary dictionaryWithDictionary:params];
//    orderDetails.needHideOldNavigationBar = YES ;
    return  orderDetails;
}

- (UIViewController *)Action_nativeOrderRemindViewController:(NSDictionary *)params
{
    orderRemindView *orderRemind = [[orderRemindView  alloc]  initWithNibName:@"orderRemindView" bundle:nil parent:nil];
    orderRemind.needHideOldNavigationBar =YES;
    orderRemind.dic = [NSDictionary dictionaryWithDictionary:params];
    return  orderRemind;
}

- (UIViewController *)Action_nativeSpecialTagListViewController:(NSDictionary *)params
{
    SpecialTagListView *specialView  = [[SpecialTagListView  alloc]  initWithNibName:@"SpecialTagListView" bundle:nil parent:nil moduleName:nil];
     specialView.dic  = [NSDictionary dictionaryWithDictionary:params];
    specialView.needHideOldNavigationBar = YES ;
    return specialView;
}

- (UIViewController *)Action_nativeSpecialTagEditViewController:(NSDictionary *)params
{
    SpecialTagEditView *specialEditView  = [[SpecialTagEditView  alloc]  initWithNibName:@"SpecialTagEditView" bundle:nil parent:nil moduleName:nil];
    specialEditView.dic  = [NSDictionary dictionaryWithDictionary:params];
     specialEditView.needHideOldNavigationBar = YES ;
    return specialEditView;
}

@end
