//
//  Target_KabawModule.h
//  RestApp
//
//  Created by hulatang on 16/7/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_KabawModule : NSObject
///顾客端设置
- (UIViewController *)Action_nativeTDFKabawModulViewController:(NSDictionary *)params;

///店家资料
-(UIViewController *)Action_nativeShopEditViewController:(NSDictionary *)params;

///定位
-(UIViewController *)Action_nativeMapLocationViewController:(NSDictionary *)params;

///基础设置
- (UIViewController *)Action_nativeBaseSetingViewController:(NSDictionary *)params;

///店铺二维码
- (UIViewController *)Action_nativeShopCodeViewController:(NSDictionary *)params;

///店家微信公众号设置
-(UIViewController *)Action_nativeWXOfficialAccountController:(NSDictionary *)params;

///本店销量排行
-(UIViewController *)Action_nativeShopSalesRankViewController:(NSDictionary *)params;

///外卖设置
- (UIViewController *)Action_nativeTakeOutSetEditViewController:(NSDictionary *)params;

///可送外卖时段列表页
- (UIViewController *)Action_nativeTakeOutTimeListViewController:(NSDictionary *)params;

///可送外卖时段编辑页
-(UIViewController *)Action_nativieTakeOutTimeEditViewController:(NSDictionary *)params;

///送货人
- (UIViewController *)Action_nativeSenderListViewController:(NSDictionary *)params;

///送货人编辑页
-(UIViewController *)Action_nativeSenderEditViewController:(NSDictionary *)params;

///排队桌位类型
- (UIViewController *)Action_nativeQueuKindListViewController:(NSDictionary *)params;

///必选商品
- (UIViewController *)Action_nativeSelectGoodsViewController:(NSDictionary *)params;

///添加必选商品列表
- (UIViewController *)Action_nativeMustSelectGoodsListViewController:(NSDictionary *)params;

///添加必选商品
- (UIViewController *)Action_nativeAddForceGoodViewController:(NSDictionary *)params;

///参与排行的菜品
- (UIViewController *)Action_nativeMenusRankListViewController:(NSDictionary *)params;

///黑名单
- (UIViewController *)Action_nativeShopBlackListViewController:(NSDictionary *)params;
// 小二个性化换肤
- (UIViewController *)Action_nativeExchangeSkinViewController:(NSDictionary *)params;
// 商品页首页尾
- (UIViewController *)Action_nativeHeaderFooterViewController:(NSDictionary *)params;
///顾客点餐重复提醒
- (UIViewController *)Action_nativeOrderReminderViewController:(NSDictionary *)params;

///预定设置
- (UIViewController *)Action_nativeReserveSetEditViewController:(NSDictionary *)params;

///可预定时段编辑页.
- (UIViewController *)Action_nativeReserveTimeEditViewController:(NSDictionary *)params;

///可预定时段列表页.
- (UIViewController *)Action_nativeReserveTimeListViewController:(NSDictionary *)params;

///可预定桌位列表页.
- (UIViewController *)Action_nativeReserveSeatListViewController:(NSDictionary *)params;

///可预定桌位编辑页.
- (UIViewController *)Action_nativeReserveSeatEditViewController:(NSDictionary *)params;

///优惠方案列表页.
- (UIViewController *)Action_nativeSpecialListViewController:(NSDictionary *)params;

///优惠方案编辑页.
- (UIViewController *)Action_nativeSpecialEditViewController:(NSDictionary *)params;

///不接受预定日期列表页.
- (UIViewController *)Action_nativeReserveBandListViewController:(NSDictionary *)params;

///不接受预定日期编辑页.
- (UIViewController *)Action_nativeReserveBandEditViewController:(NSDictionary *)params;

///  排队设置
- (UIViewController *)Action_nativeQueueSettingViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeTDFSeatBindViewController:(NSDictionary *)params;
@end
