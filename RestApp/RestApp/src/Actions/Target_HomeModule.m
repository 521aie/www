//
//  Target_HomeModule.m
//  RestApp
//
//  Created by 黄河 on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFBarcodeViewController.h"
#import "ChainBusinessDetailView.h"
#import "SysNotificationView.h"
#import "BusinessDetailView.h"
#import "BusinesssOrderView.h"
#import "BranchBusinessDay.h"
#import "Target_HomeModule.h"
#import "OrderDetailView.h"
#import "PrintBillView.h"
#import "ChangePwdView.h"
#import "UserInfoView.h"
#import "ReportModule.h"
#import "SystemUtil.h"
#import "TDFScanVipController.h"
#import "TDFShopKeeperDataController.h"
#import "TDFTakeMealController.h"
#import "TDFSignBillController.h"
#import "TDFSubShopCompareController.h"

@implementation Target_HomeModule

///系统通知
- (UIViewController *)Action_nativeSysNotificationViewController:(NSDictionary *)params
{
    SysNotificationView *syst = [[SysNotificationView alloc]init];
    return syst;
}


///(单店)营业汇总
-(UIViewController *)Action_nativeBusinessDetailViewController:(NSDictionary *)params
{
    BusinessDetailView *business = [[BusinessDetailView alloc] initWithNibName:@"BusinessDetailView"bundle:nil];
    business.currYear = [params[@"year"] integerValue];
    business.currMonth = [params[@"month"] integerValue];
    business.currDay = [params[@"day"] integerValue];
    business.needHideOldNavigationBar = NO;
    
    return business;
}
///(连锁)营业汇总
-(UIViewController *)Action_nativeChainBusinessDetailViewController:(NSDictionary *)params
{
    ChainBusinessDetailView *chainBusinessDetailView = [[ChainBusinessDetailView alloc]initWithNibName:@"ChainBusinessDetailView" bundle:nil];
    chainBusinessDetailView.currYear = [params[@"year"] integerValue];
    chainBusinessDetailView.currMonth = [params[@"month"] integerValue];
    chainBusinessDetailView.currDay = [params[@"day"] integerValue];
    chainBusinessDetailView.idsArr = params[@"idArray"];
    chainBusinessDetailView.needHideOldNavigationBar = NO;
    return chainBusinessDetailView;
}
///(连锁)门店营业额对比
-(UIViewController *)Action_nativeBranchBusinessDayViewController:(NSDictionary *)params
{
    BranchBusinessDay *branchBusinessDay = [[BranchBusinessDay alloc] initWithNibName:@"BranchBusinessDay" bundle:nil];
    branchBusinessDay.dataDic = params;
    branchBusinessDay.needHideOldNavigationBar = NO;
    return branchBusinessDay;
}

///扫描二维码
- (UIViewController *)Action_nativeTDFBarcodeViewController:(NSDictionary *)params{
    TDFBarcodeViewController *vc = [[TDFBarcodeViewController alloc] init];
    return vc;
}
///打印账单统计
- (UIViewController *)Action_nativePrintBillViewController:(NSDictionary *)params{
    PrintBillView *printBill = [[PrintBillView alloc]initWithNibName:@"PrintBillView"  bundle:nil];
    printBill.dateStr = params[@"date"];
    printBill.needHideOldNavigationBar = YES;
    return printBill;
}

///账单详情
- (UIViewController *)Action_nativeOrderDetailViewController:(NSDictionary *)params
{
    OrderDetailView *orderDetailView = [[OrderDetailView alloc] initWithNibName:@"OrderDetailView" bundle:nil];
    orderDetailView.type = [params[@"eventType"] integerValue];
    orderDetailView.orderId = params[@"orderID"];
    orderDetailView.totalPayId = params[@"totalPayID"];
    orderDetailView.needHideOldNavigationBar = YES;
    return orderDetailView;
}

///会员消费记录
- (UIViewController *)Action_nativeBusinesssOrderViewController:(NSDictionary *)params
{
    BusinesssOrderView *businessOrderView = [[BusinesssOrderView alloc] initWithNibName:@"BusinesssOrderView" bundle:nil];
    businessOrderView.eventType = [params[@"eventType"] integerValue];
    businessOrderView.customerRegisterId = params[@"customerRegistId"];
    businessOrderView.extraPoJoName = params[@"extraPoJoName"];
    businessOrderView.mobile = params[@"mobile"];
    businessOrderView.name = params[@"name"];
    businessOrderView.needHideOldNavigationBar = YES;
    return businessOrderView;
}

///修改密码
- (UIViewController *)Action_nativeChangePwdViewController:(NSDictionary *)params
{
    ChangePwdView* changePwd = [[ChangePwdView alloc]initWithNibName:@"ChangePwdView"bundle:nil];
    return changePwd;
}

///用户信息
- (UIViewController *)Action_nativeUserInfoViewController:(NSDictionary *)params
{
    UserInfoView *userInfo = [[UserInfoView alloc]init];
    return userInfo;
}

///报表
- (UIViewController *)Action_nativeReportModuleController:(NSDictionary *)params {
    ReportModule *reportModule = [[ReportModule alloc] initWithNibName:@"ReportModule"bundle:nil parent:nil];
    return reportModule;
}

///扫码即会员
- (UIViewController *)Action_nativeTDFScanVipController:(NSDictionary *)params {
    
    return [TDFScanVipController new];
}

///新店家资料
- (UIViewController *)Action_nativeTDFShopKeeperDataController:(NSDictionary *)params {

    return [TDFShopKeeperDataController new];
}

///取餐模块
- (UIViewController *)Action_nativeTDFTakeMealControllr:(NSDictionary *)params {

    return [TDFTakeMealController new];
}

///挂帐模块
- (UIViewController *)Action_nativeTDFSignBillController:(NSDictionary *)params {

    return [TDFSignBillController new];
}

///门店营业额对比
- (UIViewController *)Action_nativeTDFSubShopCompareController:(NSDictionary *)params {

    TDFSubShopCompareController *vc = [TDFSubShopCompareController new];
    
    vc.TypeStr = params[@"type"];
    vc.dateStr = params[@"date"];
    
    return vc;
}
@end
