//
//  Target_KabawModule.m
//  RestApp
//
//  Created by hulatang on 16/7/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMustSelectGoodsListViewController.h"
#import "TDFMustSelectGoodsViewController.h"
#import "TDFAddForceGoodViewController.h"
#import "TDFKabawModulViewController.h"
#import "WXOfficialAccountController.h"
#import "TDFSeatBindViewController.h"
#import "ReserveTimeListView.h"
#import "ReserveSeatListView.h"
#import "ReserveSeatEditView.h"
#import "TakeOutTimeListView.h"
#import "TakeOutTimeEditView.h"
#import "ReserveTimeEditView.h"
#import "ReserveBandListView.h"
#import "ReserveBandEditView.h"
#import "Target_KabawModule.h"
#import "TakeOutSetEditView.h"
#import "ReserveSetEditView.h"
#import "ShopSalesRankView.h"
#import "MenusRankListView.h"
#import "ShopBlackListView.h"
#import "QueuKindListView.h"
#import "SpecialEditView.h"
#import "MapLocationView.h"
#import "SpecialListView.h"
#import "BaseSetingView.h"
#import "TDFSenderListViewController.h"
#import "SenderEditView.h"
#import "ShopCodeView.h"
#import "ShopEditView.h"
#import "SystemUtil.h"
#import "QueuKindListView.h"
#import "TDFQueueSettingViewController.h"
#import "TDFOrderReminderViewController.h"
#import "ESPlanEditerController.h"
#import "ESPageHeaderFooterController.h"
#import "TDFShopQRCodeController.h"

@implementation Target_KabawModule

///顾客端设置
- (UIViewController *)Action_nativeTDFKabawModulViewController:(NSDictionary *)params
{
    TDFKabawModulViewController *kabawModuleViewController = [[TDFKabawModulViewController alloc] init];
    kabawModuleViewController.codeArray = params[@"data"][@"actionCodeArrs"];
    kabawModuleViewController.childFunctionArr = params[@"data"][@"isOpenFunctionArrs"];
    return kabawModuleViewController;
}


///店家资料
-(UIViewController *)Action_nativeShopEditViewController:(NSDictionary *)params
{
    ShopEditView *shopEditViewController = [[ShopEditView alloc]initWithNibName: @"ShopEditView" bundle:nil parent:nil];
    shopEditViewController.needHideOldNavigationBar = YES;
    return shopEditViewController;
}


///定位
-(UIViewController *)Action_nativeMapLocationViewController:(NSDictionary *)params
{
    MapLocationView  *mapLocationViewController = [[MapLocationView alloc]initWithNibName:@"MapLocationView" bundle:nil parent:nil];
    if (params[@"callBack"]) {
        mapLocationViewController.backBlock = params[@"callBack"];
    }
    return mapLocationViewController;
}
///店铺二维码
- (UIViewController *)Action_nativeShopCodeViewController:(NSDictionary *)params
{
    TDFShopQRCodeController *shopCodeViewController = [[TDFShopQRCodeController alloc] init];

    return shopCodeViewController;
}

///店家微信公众号设置
-(UIViewController *)Action_nativeWXOfficialAccountController:(NSDictionary *)params
{
    WXOfficialAccountController *wxOfficialAccountController = [[WXOfficialAccountController alloc]init];
    wxOfficialAccountController.needHideOldNavigationBar = [params[@"needHideOldNavigationBar"] boolValue];
    return wxOfficialAccountController;
}
///排队桌位类型
- (UIViewController *)Action_nativeQueuKindListViewController:(NSDictionary *)params
{
    QueuKindListView *queuKindListViewController = [[QueuKindListView alloc] initWithNibName:@"QueuKindListView" bundle:nil parent:nil];
    queuKindListViewController.needHideOldNavigationBar = YES;
    return queuKindListViewController;
}

///  排队设置
- (UIViewController *)Action_nativeQueueSettingViewController:(NSDictionary *)param {

    return [[TDFQueueSettingViewController alloc] init];
}

///基础设置
- (UIViewController *)Action_nativeBaseSetingViewController:(NSDictionary *)params
{
    BaseSetingView *baseSetingViewController = [[BaseSetingView alloc] init];
    return baseSetingViewController;
}

///必选商品
- (UIViewController *)Action_nativeSelectGoodsViewController:(NSDictionary *)params
{
    TDFMustSelectGoodsViewController *viewController = [[TDFMustSelectGoodsViewController alloc] init];
    return viewController;
}

///添加必选商品列表
- (UIViewController *)Action_nativeMustSelectGoodsListViewController:(NSDictionary *)params
{
    TDFMustSelectGoodsListViewController *listViewController = [[TDFMustSelectGoodsListViewController alloc] init];
    return listViewController;
}

///添加必选商品
- (UIViewController *)Action_nativeAddForceGoodViewController:(NSDictionary *)params
{
    TDFAddForceGoodViewController *forceGood = [[TDFAddForceGoodViewController alloc] init];
    forceGood.needHideOldNavigationBar = [params[@"needHideOldNavigationBar"] boolValue];
    if ([params[@"data"] isKindOfClass:[TDFForceMenuVo class]]) {
        forceGood.forceMenuVo = params[@"data"];
        forceGood.status = [params[@"status"] integerValue];
        forceGood.callBack = params[@"callBack"];
    }
    return forceGood;
}

///参与排行的菜品
- (UIViewController *)Action_nativeMenusRankListViewController:(NSDictionary *)params
{
    MenusRankListView *menuRank = [[MenusRankListView alloc] initWithNibName:@"MenusRankListView" bundle:nil parent:nil];
    menuRank.needHideOldNavigationBar = [params[@"needHideOldNavigationBar"] boolValue];
    menuRank.callBack = params[@"callBack"];
    return menuRank;
    
}

///本店销量榜

- (UIViewController *)Action_nativeShopSalesRankViewController:(NSDictionary *)params
{
    ShopSalesRankView *shopSalesRankView = [[ShopSalesRankView alloc] initWithNibName:@"ShopSalesRankView" bundle:nil parent:nil];
    shopSalesRankView.needHideOldNavigationBar = YES;
    return shopSalesRankView;
}
///外卖设置
- (UIViewController *)Action_nativeTakeOutSetEditViewController:(NSDictionary *)params
{
    TakeOutSetEditView *takeOutSetEditView = [[TakeOutSetEditView alloc]init];
    takeOutSetEditView.needHideOldNavigationBar = YES;
    return takeOutSetEditView;
}


///可送外卖时段
- (UIViewController *)Action_nativeTakeOutTimeListViewController:(NSDictionary *)params
{
    TakeOutTimeListView *takeOutTimeListView = [[TakeOutTimeListView alloc]init];
    takeOutTimeListView.params = params;
    takeOutTimeListView.needHideOldNavigationBar =YES;
    return takeOutTimeListView;
}


///可送外卖时段编辑页
-(UIViewController *)Action_nativeTakeOutTimeEditViewController:(NSDictionary *)params
{
    TakeOutTimeEditView *timeEdit = [[TakeOutTimeEditView alloc] initWithNibName:@"TakeOutTimeEditView" bundle:nil parent:nil];
    timeEdit.action = [params[@"status"] intValue];
    timeEdit.selObj= params[@"data"];
    timeEdit.callBack = params[@"callBack"];
    timeEdit.needHideOldNavigationBar = YES;
    return timeEdit;
}

///送货人
- (UIViewController *)Action_nativeSenderListViewController:(NSDictionary *)params
{
    TDFSenderListViewController *senderListView = [[TDFSenderListViewController alloc]init];
    senderListView.params =params;
    return senderListView;
}


///送货人编辑页
-(UIViewController *)Action_nativeSenderEditViewController:(NSDictionary *)params
{
    SenderEditView *editView = [[SenderEditView alloc]initWithNibName:@"SenderEditView" bundle:nil parent:nil];
    editView.action = [params[@"status"]intValue];
    editView.sender = params[@"data"];
    editView.callBack = params[@"callBack"];
    editView.needHideOldNavigationBar = YES;
    return editView;
}


///黑名单
- (UIViewController *)Action_nativeShopBlackListViewController:(NSDictionary *)params
{
    ShopBlackListView *listView = [[ShopBlackListView alloc] init];
    listView.needHideOldNavigationBar = YES;
    return listView;
}
// 商品页首页尾
- (UIViewController *)Action_nativeHeaderFooterViewController:(NSDictionary *)params
{
    ESPageHeaderFooterController *headerView = [[ESPageHeaderFooterController alloc] init];
    return headerView;
}

//小二换肤设置
- (UIViewController *)Action_nativeExchangeSkinViewController:(NSDictionary *)params
{
    ESPlanEditerController *planEditer = [[ESPlanEditerController alloc] init];
    return planEditer;
}

///顾客点餐重复提醒
- (UIViewController *)Action_nativeOrderReminderViewController:(NSDictionary *)params
{
    TDFOrderReminderViewController *vc = [[TDFOrderReminderViewController alloc] init];
    
    return vc;
}

///预定设置
- (UIViewController *)Action_nativeReserveSetEditViewController:(NSDictionary *)params
{
    ReserveSetEditView *setEditView = [[ReserveSetEditView alloc] initWithNibName:@"ReserveSetEditView" bundle:nil parent:nil];
    setEditView.needHideOldNavigationBar = YES;
    return setEditView;
}

///可预定时段编辑页.
- (UIViewController *)Action_nativeReserveTimeEditViewController:(NSDictionary *)params
{
    ReserveTimeEditView *timeEdit = [[ReserveTimeEditView alloc] initWithNibName:@"ReserveTimeEditView" bundle:nil parent:nil];
    timeEdit.action = [params[@"status"] intValue];
    timeEdit.selObj= params[@"data"];
    timeEdit.kind= [params[@"kind"] intValue];
    timeEdit.callBack = params[@"callBack"];
    timeEdit.needHideOldNavigationBar = YES;
    return timeEdit;
}

///可预定时段列表页.
- (UIViewController *)Action_nativeReserveTimeListViewController:(NSDictionary *)params
{
    ReserveTimeListView *timeList = [[ReserveTimeListView alloc] init];
    timeList.params = params;
    timeList.needHideOldNavigationBar = YES;
    return timeList;
}

///可预定桌位列表页.
- (UIViewController *)Action_nativeReserveSeatListViewController:(NSDictionary *)params
{
    ReserveSeatListView *seatList = [[ReserveSeatListView alloc] init];
    seatList.params = params;
    seatList.needHideOldNavigationBar = YES;
    return seatList;
}

///可预定桌位编辑页.
- (UIViewController *)Action_nativeReserveSeatEditViewController:(NSDictionary *)params
{
    ReserveSeatEditView *seatEdit = [[ReserveSeatEditView alloc] initWithNibName:@"ReserveSeatEditView" bundle:nil parent:nil];
    seatEdit.times = params[@"time"];
    seatEdit.action = [params[@"status"] intValue];
    seatEdit.selObj= params[@"data"];
    seatEdit.callBack = params[@"callBack"];
    seatEdit.needHideOldNavigationBar = YES;
    return seatEdit;
}

///优惠方案列表页.
- (UIViewController *)Action_nativeSpecialListViewController:(NSDictionary *)params
{
    SpecialListView *specialList = [[SpecialListView alloc] init];
    specialList.params = params;
    specialList.needHideOldNavigationBar = YES;
    return specialList;
}

///优惠方案编辑页.
- (UIViewController *)Action_nativeSpecialEditViewController:(NSDictionary *)params
{
    SpecialEditView *speEdit = [[SpecialEditView alloc] init];
    speEdit.action = [params[@"status"] intValue];
    speEdit.selObj= params[@"data"];
    speEdit.callBack = params[@"callBack"];
    speEdit.needHideOldNavigationBar = YES;
    return speEdit;
}

///不接受预定日期列表页.
- (UIViewController *)Action_nativeReserveBandListViewController:(NSDictionary *)params
{
    ReserveBandListView *bandList = [[ReserveBandListView alloc] init];
    bandList.params = params;
    bandList.needHideOldNavigationBar = YES;
    return bandList;
}

///不接受预定日期编辑页.
- (UIViewController *)Action_nativeReserveBandEditViewController:(NSDictionary *)params
{
    ReserveBandEditView *bandEdit = [[ReserveBandEditView alloc] initWithNibName:@"ReserveBandEditView" bundle:nil parent:nil];
    bandEdit.action = [params[@"status"] intValue];
    bandEdit.selObj = params[@"data"];
    bandEdit.callBack = params[@"callBack"];
    bandEdit.needHideOldNavigationBar = YES;
    return bandEdit;
}

- (UIViewController *)Action_nativeTDFSeatBindViewController:(NSDictionary *)params {
    TDFSeatBindViewController *bvc = [[TDFSeatBindViewController alloc] initWithSeatType:params[@"seatType"]];
    return bvc;
}


@end
