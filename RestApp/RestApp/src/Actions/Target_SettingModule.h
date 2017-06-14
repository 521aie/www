//
//  Target_SettingModule.h
//  RestApp
//
//  Created by 黄河 on 16/8/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_SettingModule : NSObject

///系统参数
- (UIViewController *)Action_nativeSysParaEditViewController:(NSDictionary *)params;

///店家信息
- (UIViewController *)Action_nativeShopBaseViewController:(NSDictionary *)params;

///营业结束时间
- (UIViewController *)Action_nativeOpenTimePlanViewController:(NSDictionary *)params;

///营业班次列表
- (UIViewController *)Action_nativeTimeArrangeListViewController:(NSDictionary *)params;

///营业班次编辑
- (UIViewController *)Action_nativeTimeArrangeEditViewController:(NSDictionary *)params;

//收银打印
-(UIViewController *)Action_nativePrinterParasEditViewController:(NSDictionary *)params;

//零头处理方式
-(UIViewController *)Action_nativeZeroListViewController:(NSDictionary *)params;

//添加不吉利尾数
-(UIViewController *)Action_nativeTailDealEditViewController:(NSDictionary *)params;

///更换排队机
-(UIViewController *)Action_nativeCancelQueuViewController:(NSDictionary *)params;

///数据清理
-(UIViewController *)Action_nativeDataClearViewController:(NSDictionary *)params;

///店内屏幕广告
-(UIViewController *)Action_nativeShopScreenAdViewController:(NSDictionary *)params;

///叫号语音设置
-(UIViewController *)Action_nativeCallVoiceSettingViewController:(NSDictionary *)params;

//电子菜谱排版
-(UIViewController *)Action_nativeKindMenuStyleListView:(NSDictionary *)params;

//附加费列表
-(UIViewController *)Action_nativeFeePlanListView:(NSDictionary *)params;

///附加费编辑
- (UIViewController *)Action_nativeFeePlanEditView:(NSDictionary *)params;

///打折方案
-(UIViewController *)Action_nativeDiscountPlanListView:(NSDictionary *)params;

///添加打折方案
-(UIViewController *)Action_nativeDiscountPlanEditView:(NSDictionary *)params;

///分类折扣率
- (UIViewController *)Action_nativeDiscountDetailEditView:(NSDictionary *)params;

///选择商品设置折扣率
-(UIViewController *)Action_nativeDiscountMenuDetailEditView:(NSDictionary *)params;

//商品促销
-(UIViewController *)Action_nativeMenuTimeListView:(NSDictionary *)params;

///商品促销编辑
- (UIViewController *)Action_nativeMenuTimeEditView:(NSDictionary *)params;

//选择商品页面
-(UIViewController *)Action_nativeSelectMenuListView:(NSDictionary *)params;

///商品促销价格编辑
- (UIViewController *)Action_nativeMenuTimePriceEditView:(NSDictionary *)params;

///商品选择多页
- (UIViewController *)Action_nativeSelectMultiMenuListView:(NSDictionary *)params;


//付款方式
- (UIViewController *)Action_nativeKindPayListView:(NSDictionary *)params;

//付款方式详情页
- (UIViewController *)Action_nativeKindPayEditView:(NSDictionary *)params;

//新增优惠券
-  (UIViewController *)Action_nativeTDFAddNewCopousInfoViewController:(NSDictionary *)params;

//客单备注
- (UIViewController *)Action_nativeCustomerListView:(NSDictionary *)params;

//添加客单备注
- (UIViewController *)Action_nativeDicItemEditView:(NSDictionary *)params;

//排序：TableEditView
- (UIViewController *)Action_nativeTableEditView:(NSDictionary *)params;

//特殊操作原因
- (UIViewController *)Action_nativeSpecialReasonListView:(NSDictionary *)params;

//收银单据模板列表
- (UIViewController *)Action_nativeShopTemplateListView:(NSDictionary *)params;

///收银单据模板编辑
- (UIViewController *)Action_nativeShopTemplateEditView:(NSDictionary *)params;

//智能收银点菜单
- (UIViewController *)Action_nativeTDFSmartOrderController:(NSDictionary *)params;

//挂账设置列表
- (UIViewController *)Action_nativeSignBillListView:(NSDictionary *)params;

///挂账设置编辑
- (UIViewController *)Action_nativeSignBillEditView:(NSDictionary *)params;

///挂账人编辑
- (UIViewController *)Action_nativeSignBillDetailEditView:(NSDictionary *)params;

///签字人编辑
- (UIViewController *)Action_nativeSignerEditView:(NSDictionary *)params;

///功能大全
- (UIViewController *)Action_nativeTDFFunctionViewController:(NSDictionary *)params;

///帮助视频
- (UIViewController *)Action_nativeHelpVideoViewController:(NSDictionary *)params;

//选择日期
- (UIViewController *)Action_nativeTDFScheduleDateViewController:(NSDictionary *)params;

//连锁付款方式
- (UIViewController *)Action_nativeTDFBrandKindPayListViewController:(NSDictionary *)params;

//开通顺丰同城快递
- (UIViewController *)Action_nativeTDFLocalDeliveryViewController:(NSDictionary *)params;

@end
