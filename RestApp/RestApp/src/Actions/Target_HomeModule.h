//
//  Target_HomeModule.h
//  RestApp
//
//  Created by 黄河 on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_HomeModule : NSObject

///系统通知
- (UIViewController *)Action_nativeSysNotificationViewController:(NSDictionary *)params;

///(单店)营业汇总
-(UIViewController *)Action_nativeBusinessDetailViewController:(NSDictionary *)params;

///打印账单统计
- (UIViewController *)Action_nativePrintBillViewController:(NSDictionary *)params;

///账单详情
- (UIViewController *)Action_nativeOrderDetailViewController:(NSDictionary *)params;

///会员消费记录
- (UIViewController *)Action_nativeBusinesssOrderViewController:(NSDictionary *)params;

///扫描二维码
- (UIViewController *)Action_nativeTDFBarcodeViewController:(NSDictionary *)params;

///(连锁)营业汇总
-(UIViewController *)Action_nativeChainBusinessDetailViewController:(NSDictionary *)params;

///(连锁)门店营业额对比
-(UIViewController *)Action_nativeBranchBusinessDayViewController:(NSDictionary *)params;
///修改密码
- (UIViewController *)Action_nativeChangePwdViewController:(NSDictionary *)params;
///用户信息
- (UIViewController *)Action_nativeUserInfoViewController:(NSDictionary *)params;

///报表
- (UIViewController *)Action_nativeReportModuleController:(NSDictionary *)params;

///扫码即会员
- (UIViewController *)Action_nativeTDFScanVipController:(NSDictionary *)params;

///新店家资料
- (UIViewController *)Action_nativeTDFShopKeeperDataController:(NSDictionary *)params;

///取餐模块
- (UIViewController *)Action_nativeTDFTakeMealControllr:(NSDictionary *)params;

///挂帐模块
- (UIViewController *)Action_nativeTDFSignBillController:(NSDictionary *)params;

///门店营业额对比
- (UIViewController *)Action_nativeTDFSubShopCompareController:(NSDictionary *)params;
@end
