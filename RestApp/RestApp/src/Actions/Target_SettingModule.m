//
//  Target_SettingModule.m
//  RestApp
//
//  Created by 黄河 on 16/8/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_SettingModule.h"
#import "OpenTimePlanView.h"
#import "SysParaEditView.h"
#import "ShopBaseView.h"
#import "TimeArrangeEditView.h"
#import "TimeArrangeListView.h"
#import "SystemUtil.h"
#import "HelpVideoView.h"
#import "PrinterParasEditView.h"
#import "ZeroListView.h"
#import "TailDealEditView.h"
#import "CancelQueuView.h"
#import "DataClearView.h"
#import "KindMenuStyleListView.h"
#import "FeePlanListView.h"
#import "FeePlanEditView.h"
#import "MenuTimeListView.h"
#import "MenuTimeEditView.h"
#import "SelectMenuListView.h"
#import "MenuTimePriceEditView.h"
#import "TDFKindPayDetailViewController.h"
#import "TDFAddNewCopousInfoViewController.h"
#import "TDFFunctionViewController.h"
#import "SelectMultiMenuListView.h"
#import "CustomerListView.h"
#import "DicItemEditView.h"
#import "TableEditView.h"
#import "SpecialReasonListView.h"
#import "ShopTemplateListView.h"
#import "ShopTemplateEditView.H"
#import "SignBillListView.h"
#import "SignBillEditView.h"
#import "SignBillDetailEditView.h"
#import "SignerEditView.h"
#import "TDFShopScreenAdViewController.h"
#import "TDFCallVoiceSettingViewController.h"
#import "DiscountPlanListView.h"
#import "DiscountPlanEditView.h"
#import "DiscountDetailEditView.h"
#import "DiscountMenuDetailEditView.h"
#import "TDFScheduleDateViewController.h"
#import "TDFBrandKindPayListViewController.h"
#import "TDFKindPayListViewController.h"
#import "TDFSmartOrderController.h"
#import "TDFLocalDeliveryViewController.h"

@implementation Target_SettingModule
///系统参数
- (UIViewController *)Action_nativeSysParaEditViewController:(NSDictionary *)params
{
    SysParaEditView *paraEditView = [[SysParaEditView alloc] initWithNibName:@"SysParaEditView" bundle:nil];
    return paraEditView;
}

///店家信息
- (UIViewController *)Action_nativeShopBaseViewController:(NSDictionary *)params
{
    ShopBaseView *baseView = [[ShopBaseView alloc] initWithNibName:@"ShopBaseView" bundle:nil];
    return baseView;
}

///营业结束时间
- (UIViewController *)Action_nativeOpenTimePlanViewController:(NSDictionary *)params
{
   OpenTimePlanView *openTime = [[OpenTimePlanView alloc] initWithNibName:@"OpenTimePlanView" bundle:nil];
    return openTime;
}
///营业班次列表
- (UIViewController *)Action_nativeTimeArrangeListViewController:(NSDictionary *)params{
    TimeArrangeListView *listView = [[TimeArrangeListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    listView.needHideOldNavigationBar = YES;
    return listView;
}

///营业班次编辑
- (UIViewController *)Action_nativeTimeArrangeEditViewController:(NSDictionary *)params{
    TimeArrangeEditView *editView = [[TimeArrangeEditView alloc]initWithNibName:@"TimeArrangeEditView" bundle:nil];
    editView.callBack = params[@"callBack"];
    editView.timeArrangeVO = params[@"data"];
    editView.action = [params[@"status"] intValue];

    return editView;
}

- (UIViewController *)Action_nativePrinterParasEditViewController:(NSDictionary *)params {
    PrinterParasEditView *printerParasEditView=[[PrinterParasEditView alloc] init];
    printerParasEditView.needHideOldNavigationBar = YES;
    return printerParasEditView;
}

- (UIViewController *)Action_nativeZeroListViewController:(NSDictionary *)params {

    ZeroListView *zeroListView=[[ZeroListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    return zeroListView;
}

- (UIViewController *)Action_nativeTailDealEditViewController:(NSDictionary *)params {
    TailDealEditView *tailDealEditView = [[TailDealEditView alloc] initWithNibName:@"TailDealEditView" bundle:nil];
    tailDealEditView.action = [params[@"action"] intValue];
    tailDealEditView.needHideOldNavigationBar = YES;
    return tailDealEditView;
}

///更换排队机
-(UIViewController *)Action_nativeCancelQueuViewController:(NSDictionary *)params{
    CancelQueuView *cancelQueueView = [[CancelQueuView alloc] initWithNibName:@"CancelQueuView" bundle:nil];
    return cancelQueueView;
}
///数据清理
-(UIViewController *)Action_nativeDataClearViewController:(NSDictionary *)params{
    DataClearView *dataClearView = [[DataClearView alloc] init];
    return dataClearView;
}

///店内屏幕广告
-(UIViewController *)Action_nativeShopScreenAdViewController:(NSDictionary *)params{
    TDFShopScreenAdViewController *vc = [[TDFShopScreenAdViewController alloc] init];

    return vc;
}

///叫号语音设置
-(UIViewController *)Action_nativeCallVoiceSettingViewController:(NSDictionary *)params{
    TDFCallVoiceSettingViewController *vc = [[TDFCallVoiceSettingViewController alloc] init];
    
    return vc;
}

//电子菜谱排版
-(UIViewController *)Action_nativeKindMenuStyleListView:(NSDictionary *)params{
    KindMenuStyleListView *kindMenuStyleListView = [[KindMenuStyleListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    return kindMenuStyleListView;
}

//附加费列表
-(UIViewController *)Action_nativeFeePlanListView:(NSDictionary *)params{
    FeePlanListView *feePlanListView = [[FeePlanListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    return feePlanListView;
}

///附加费编辑
- (UIViewController *)Action_nativeFeePlanEditView:(NSDictionary *)params{
    FeePlanEditView *feePlanEditView = [[FeePlanEditView alloc]init];
    feePlanEditView.callBack = params[@"callBack"];
    feePlanEditView.feePlan = params[@"data"];
    feePlanEditView.action = [params[@"status"] intValue];
    
    return feePlanEditView;
}

///打折方案
-(UIViewController *)Action_nativeDiscountPlanListView:(NSDictionary *)params
{
   DiscountPlanListView *discountPlanListView = [[DiscountPlanListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    return discountPlanListView;
}

///添加打折方案
-(UIViewController *)Action_nativeDiscountPlanEditView:(NSDictionary *)params
{
    DiscountPlanEditView *discountPlanEditView = [[DiscountPlanEditView alloc] initWithNibName:@"DiscountPlanEditView" bundle:nil];
    discountPlanEditView.callBack = params[@"callBack"];
    discountPlanEditView.discountPlan = params[@"data"];
    discountPlanEditView.action = [params[@"status"]intValue];
    return discountPlanEditView;
}

///分类折扣率
- (UIViewController *)Action_nativeDiscountDetailEditView:(NSDictionary *)params{
    DiscountDetailEditView *discountDetailEditView = [[DiscountDetailEditView alloc] initWithNibName:@"DiscountDetailEditView" bundle:nil];
    discountDetailEditView.datas = params[@"data"];
    discountDetailEditView.defaultRatio = [params[@"radio"]doubleValue];
    discountDetailEditView.callBack = params[@"callBack"];
    discountDetailEditView.needHideOldNavigationBar =YES;
    return discountDetailEditView;
}

///选择商品设置折扣率
-(UIViewController *)Action_nativeDiscountMenuDetailEditView:(NSDictionary *)params{
    DiscountMenuDetailEditView *discountMenuDetailEditView = [[DiscountMenuDetailEditView alloc] initWithNibName:@"DiscountMenuDetailEditView" bundle:nil];
    discountMenuDetailEditView.datas = params[@"data"];
    discountMenuDetailEditView.radio = params[@"radio"];
    discountMenuDetailEditView.callBack = params[@"callBack"];
    discountMenuDetailEditView.needHideOldNavigationBar =YES;
    return discountMenuDetailEditView;
}

//商品促销
-(UIViewController *)Action_nativeMenuTimeListView:(NSDictionary *)params{
    MenuTimeListView *menuTimeListView = [[MenuTimeListView alloc] initWithNibName:@"MenuTimeListView" bundle:nil];
    return menuTimeListView;
}

///商品促销编辑
- (UIViewController *)Action_nativeMenuTimeEditView:(NSDictionary *)params{
    MenuTimeEditView *menuTimeEditView = [[MenuTimeEditView alloc]init];
    menuTimeEditView.callBack = params[@"callBack"];
    menuTimeEditView.menuTime = params[@"data"];
    menuTimeEditView.action = [params[@"status"] intValue];

    return menuTimeEditView;
}

//选择商品页面
-(UIViewController *)Action_nativeSelectMenuListView:(NSDictionary *)params
{
    SelectMenuListView *selectMenuListView = [[SelectMenuListView alloc] initWithNibName:@"SelectMenuListView" bundle:nil];
    selectMenuListView.needHideOldNavigationBar = params[@"needHideOldNavigationBar"];
    [selectMenuListView loadData:params[@"headList"] nodes:params[@"nodes"] datas:params[@"datas"] dic:params[@"dic"] delegate:params[@"delegate"]];
 
    return selectMenuListView;
}

///商品促销价格编辑
- (UIViewController *)Action_nativeMenuTimePriceEditView:(NSDictionary *)params{
    MenuTimePriceEditView *menuTimePriceEditView = [[MenuTimePriceEditView alloc]initWithNibName:@"MenuTimePriceEditView" bundle:nil];
    menuTimePriceEditView.callBack = params[@"callBack"];
    menuTimePriceEditView.menuTimePrice = params[@"data"];
    menuTimePriceEditView.action = [params[@"status"] intValue];
    
    return menuTimePriceEditView;
}

///商品选择多页
- (UIViewController *)Action_nativeSelectMultiMenuListView:(NSDictionary *)params{
    SelectMultiMenuListView *selectMultiMenuListView = [[SelectMultiMenuListView alloc]initWithNibName:@"SelectMultiMenuListView" bundle:nil ];
    [selectMultiMenuListView loadMenus:params[@"oldArrs"] delegate:params[@"delegate"]];
    return selectMultiMenuListView;
}


//付款方式
- (UIViewController *)Action_nativeKindPayListView:(NSDictionary *)params;
{
    TDFKindPayListViewController *VC = [[TDFKindPayListViewController alloc] init];
    return VC;
    
}

//付款方式详情页
- (UIViewController *)Action_nativeKindPayEditView:(NSDictionary *)params
{
    TDFKindPayDetailViewController *kindEditView =[[TDFKindPayDetailViewController alloc] initWithParent:nil];
    kindEditView.dic =params;
    kindEditView.needHideOldNavigationBar =YES;
    return kindEditView;
    
}

//新增代金券
- (UIViewController *)Action_nativeTDFAddNewCopousInfoViewController:(NSDictionary *)params
{
    TDFAddNewCopousInfoViewController *newCoupons =[[TDFAddNewCopousInfoViewController alloc] initWithParent:nil];
    newCoupons.dic =params;
    newCoupons.needHideOldNavigationBar =YES;
    
    return newCoupons;
    
}
//客单备注
- (UIViewController *)Action_nativeCustomerListView:(NSDictionary *)params{
    CustomerListView *customerListView = [[CustomerListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    return customerListView;
}

//添加客单备注
- (UIViewController *)Action_nativeDicItemEditView:(NSDictionary *)params{
    DicItemEditView *dicItemEditView = [[DicItemEditView alloc]initWithNibName:@"DicItemEditView" bundle:nil];
    dicItemEditView.callBack = params[@"callBack"];
    dicItemEditView.dicItem = params[@"data"];
    dicItemEditView.action = [params[@"status"] intValue];
    dicItemEditView.titleName = params[@"title"];
    dicItemEditView.dicCode = params[@"code"];
    
    return dicItemEditView;
}

//排序：TableEditView
- (UIViewController *)Action_nativeTableEditView:(NSDictionary *)params{
    TableEditView *tableEditView = [[TableEditView alloc]initWithNibName:@"TableEditView" bundle:nil];
    tableEditView.needHideOldNavigationBar = params[@"needHideOldNavigationBar"];
    [tableEditView initDelegate:params[@"delegate"] event:params[@"event"] action:[params[@"action"] intValue] title:params[@"titleName"]];
    [tableEditView reload:params[@"dataTemps"] error:nil];

    return tableEditView;
}

//特殊操作原因
- (UIViewController *)Action_nativeSpecialReasonListView:(NSDictionary *)params{
    SpecialReasonListView *specialReasonListView = [[SpecialReasonListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    return specialReasonListView;

}

//收银单据模板列表
- (UIViewController *)Action_nativeShopTemplateListView:(NSDictionary *)params{
    ShopTemplateListView *shopTemplateListView = [[ShopTemplateListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    return shopTemplateListView;
}

///收银单据模板编辑
- (UIViewController *)Action_nativeShopTemplateEditView:(NSDictionary *)params{
    ShopTemplateEditView *shopTemplateEditView = [[ShopTemplateEditView alloc]initWithNibName:@"ShopTemplateEditView" bundle:nil];
    shopTemplateEditView.callBack = params[@"callBack"];
    shopTemplateEditView.shopTemplate = params[@"data"];
    shopTemplateEditView.action = [params[@"status"] intValue];
    return shopTemplateEditView;
}

//智能收银点菜单
- (UIViewController *)Action_nativeTDFSmartOrderController:(NSDictionary *)params {

    TDFSmartOrderController *vc = [[TDFSmartOrderController alloc]init];
    vc.code = params[@"code"];
    vc.callBack = params[@"callBack"];
    return vc;
}

//挂账设置列表
- (UIViewController *)Action_nativeSignBillListView:(NSDictionary *)params{
    SignBillListView *signBillListView = [[SignBillListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    return signBillListView;
}

///挂账设置编辑
- (UIViewController *)Action_nativeSignBillEditView:(NSDictionary *)params{
    SignBillEditView *signBillEditView = [[SignBillEditView alloc]initWithNibName:@"SignBillEditView" bundle:nil];
    signBillEditView.callBack = params[@"callBack"];
    signBillEditView.kindPay = params[@"data"];
    signBillEditView.action = [params[@"status"] intValue];
    signBillEditView.isContinue = [params[@"isContinue"] boolValue];
    return signBillEditView;
}

///挂账人编辑
- (UIViewController *)Action_nativeSignBillDetailEditView:(NSDictionary *)params{
    SignBillDetailEditView *signBillDetailEditView = [[SignBillDetailEditView alloc]initWithNibName:@"SignBillDetailEditView" bundle:nil];
    signBillDetailEditView.callBack = params[@"callBack"];
    signBillDetailEditView.kindPay = params[@"data"];
    signBillDetailEditView.action = [params[@"status"] intValue];
    signBillDetailEditView.option = params[@"option"];
    return signBillDetailEditView;
}

///签字人编辑
- (UIViewController *)Action_nativeSignerEditView:(NSDictionary *)params{
    SignerEditView *signerEditView = [[SignerEditView alloc]initWithNibName:@"SignerEditView" bundle:nil];
    signerEditView.kindPay = params[@"data"];
    signerEditView.callBack = params[@"callBack"];
    signerEditView.action = [params[@"status"] intValue];
    signerEditView.option = params[@"option"];
    return signerEditView;
}

///功能大全
- (UIViewController *)Action_nativeTDFFunctionViewController:(NSDictionary *)params
{
    TDFFunctionViewController *functionVC = [[TDFFunctionViewController alloc] init];
    return functionVC;
}

///帮助视频
- (UIViewController *)Action_nativeHelpVideoViewController:(NSDictionary *)params
{
    HelpVideoView *helpVideoView = [[HelpVideoView alloc] initWithNibName:@"HelpVideoView" bundle:nil parent:nil];
    return helpVideoView;
}

- (UIViewController *)Action_nativeTDFScheduleDateViewController:(NSDictionary *)params{
    TDFScheduleDateViewController *vc = [TDFScheduleDateViewController new];
    vc.selectDatas = [NSMutableArray arrayWithArray:params[@"data"]];
    vc.completionBlock = params[@"callBack"];
    return vc;
}

- (UIViewController *)Action_nativeTDFBrandKindPayListViewController:(NSDictionary *)params {
    TDFBrandKindPayListViewController *VC = [[TDFBrandKindPayListViewController alloc] init];
    return VC;
}


- (UIViewController *)Action_nativeTDFLocalDeliveryViewController:(NSDictionary *)params
{
    BOOL isHangzhouLocation = [[[Platform Instance] getkey:CITY_ID] isEqualToString:@"78"];
    if (!isHangzhouLocation) {
        [AlertBox show:NSLocalizedString(@"您所在的区域暂未开通该项服务，请耐心等候", nil)];
        return nil;
    }
    TDFLocalDeliveryViewController  *vc   = [[TDFLocalDeliveryViewController  alloc] init ];
    return vc;
}
@end
