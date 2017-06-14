//
//  SettingModule.m
//  RestApp
//
//  Created by zxh on 14-3-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "SettingModule.h"
#import "DicItemConstants.h"
#import "ServiceFactory.h"
#import "UIMenuAction.h"
#import "SingleCheckView.h"
#import "NavigateTitle2.h"
#import "SettingSecondView.h"
#import "MultiCheckView.h"
#import "NameValueListView.h"
#import "GridHeightConstants.h"
#import "SecondMenuCell.h"
#import "DataSingleton.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "SecondMenuView.h"
#import "SystemUtil.h"
#import "MainModule.h"
#import "SysParaEditView.h"
#import "SettingModuleEvent.h"
#import "ActionConstants.h"
#import "OpenTimePlanView.h"
#import "SettingService.h"
#import "RemoteEvent.h"
#import "ISampleListEvent.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "TDFKindPayDetailViewController.h"
#import "TDFAddNewCopousInfoViewController.h"
#import "TimeArrangeListView.h"
#import "LinkManListView.h"
#import "LinkManEditView.h"
#import "ShopTemplateListView.h"
#import "ShopTemplateEditView.h"
#import "PrinterParasEditView.h"
#import "KindMenuStyleListView.h"
#import "ZeroListView.h"
#import "TailDealEditView.h"
#import "DicItemEditView.h"
#import "SpecialReasonListView.h"
#import "FeePlanListView.h"
#import "FeePlanEditView.h"
#import "SignerEditView.h"
#import "DiscountPlanListView.h"
#import "DiscountPlanEditView.h"
#import "DiscountDetailEditView.h"
#import "TableEditView.h"
#import "SignBillListView.h"
#import "SignBillEditView.h"
#import "SignBillDetailEditView.h"
#import "CustomerListView.h"
#import "DataClearView.h"
#import "CancelBindView.h"
#import "CancelQueuView.h"
#import "XHAnimalUtil.h"
#import "TDFMediator+SettingModule.h"

@implementation SettingModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)controller
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = controller;
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainModule];
    
    [self showView:SECOND_MENU_VIEW];
}

- (void)backMenu
{
    [mainModule backMenuBySelf:self];
}

- (void)showMenu
{
    [self showView:SECOND_MENU_VIEW];
}

#pragma mart module part.
- (void)initMainModule
{
    self.discountPlanEditView.view.hidden = YES;
    self.secondMenuView = [[SettingSecondView alloc] initWithNibName:@"SettingSecondView"bundle:nil parent:self];
    [self.view addSubview:self.secondMenuView.view];
}

- (void)showView:(NSInteger)viewTag
{
    [self hideView];
 if (viewTag==SECOND_MENU_VIEW) {
        self.secondMenuView.view.hidden=NO;
        [self.secondMenuView refreshDataView];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromLeft];
    } else if (viewTag==MULTI_CHECK_VIEW) {
        [self loadMultiCheckView];
    } else if (viewTag==NAME_VALUE_VIEW) {
        [self loadNameValueView];
    } else if (viewTag==KIND_PAY_EDIT_VIEW) {
        [self loadKindPayEditView];
    } else if (viewTag==KIND_PAY_LIST_VIEW) {
        [self loadKindPayListView];
    } else if (viewTag==SHOPTEMPLATE_LIST_VIEW) {
        [self loadShopTemplateListView];
    } else if (viewTag==SHOPTEMPLATE_EDIT_VIEW) {
        [self loadShopTemplateEditView];
    } else if (viewTag==LINKMAN_LIST_VIEW) {
        [self loadLinkManListView];
    } else if (viewTag==LINKMAN_EDIT_VIEW) {
        [self loadLinkManEditView];
    } else if (viewTag==PRINTERPARAS_EDIT_VIEW) {
        [self loadPrinterParasEditView];
    } else if (viewTag==ZEROPARAS_MENU_VIEW) {
        [self loadZeroListView];
    } else if (viewTag==TAILDEAL_EDIT_VIEW) {
        [self loadTailDealEditView];
    } else if (viewTag==DICITEM_LIST_VIEW) {
        [self loadCustomerListView];
    } else if (viewTag==DICITEM_EDIT_VIEW) {
        [self loadDicItemEditView];
    } else if (viewTag==KINDMENUSTYLE_LIST_VIEW) {
        [self loadKindMenuStyleListView];
    } else if (viewTag==SPECIALREASON_LIST_VIEW) {
        [self loadSpecialReasonListView];
    } else if (viewTag==FEEPLAN_LIST_VIEW) {
        [self loadFeePlanListView];
    } else if (viewTag==FEEPLAN_EDIT_VIEW) {
        [self loadFeePlanEditView];
    } else if (viewTag==DISCOUNTPLAN_LIST_VIEW) {
        [self loadDiscountPlanListView];
    } else if (viewTag==DISCOUNTPLAN_EDIT_VIEW) {
        [self loadDiscountPlanEditView];
    } else if (viewTag==DISCOUNTDETAIL_EDIT_VIEW) {
        [self loadDiscountDetailEditView];
    } else if (viewTag==DISCOUNTD_MENU_ETAIL_EDIT_VIEW) {
        [self loadDiscountMenuDetailEditView];
    } else if (viewTag==SIGNBILL_LIST_VIEW) {
        [self loadSignBillListView];
    } else if (viewTag==SIGNBILL_EDIT_VIEW) {
        [self loadSignBillEditView];
    } else if (viewTag==SIGNBILL_DETAIL_EDIT_VIEW) {
        [self loadSignBillDetailEditView];
    } else if (viewTag==SIGNER_EDIT_VIEW) {
        [self loadSignerEditView];
    } else if (viewTag==DATA_CLEAR_VIEW) {
        [self loadDataClearView];
    } else if (viewTag==CANCEL_BIND_VIEW) {
        [self loadCancelBindView];
        [self.cancelBindView loadDatas];
    } else if (viewTag==TABLE_EDIT_VIEW) {
        [self loadTableEditView];
    } else if (viewTag==CUSTOMER_LIST_VIEW) {
        [self loadCustomerListView];
    } else if (viewTag==CANCEL_QUEU_VIEW) {
        [self loadCancelQueuView];
        [self.cancelQueuView loadDatas];
    } else if (viewTag == ADD_NEW_COUPONS) {
        [self loadAddNewCopousView];
    }
}

- (void)hideView
{
    for (UIView *view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

- (void)showActionCode:(NSString*)actCode
{
    if ([actCode isEqualToString:PAD_SETTING]/*系统设置*/) {
        [self loadSysParaEditView];
    } else if ([actCode isEqualToString:PAD_SHOPINFO]/*店家信息*/) {
        [self loadShopBaseView];
    } else if ([actCode isEqualToString:PAD_OPEN_TIME]/*营业结束时间*/){
        [self loadOpenTimePlanView];
    } else if ([actCode isEqualToString:PAD_KIND_PAY]){
        [self showView:KIND_PAY_LIST_VIEW];
//        [self.kindPayListView loadDatas];
    } else if ([actCode isEqualToString:PAD_BILL_TEMPLATE]){
        [self showView:SHOPTEMPLATE_LIST_VIEW];
//        [self.shopTemplateListView loadDatas];
    } else if ([actCode isEqualToString:PAD_TIME_ARRANGE]){
        [self loadTimeArrangeListView];
    } else if ([actCode isEqualToString:PAD_ZM_SMS]){
        [self showView:LINKMAN_LIST_VIEW];
        [self.linkManListView loadDatas];
    } else if ([actCode isEqualToString:PAD_CASH_OUTPUT]){
        [self loadPrinterParasEditView];
    } else if ([actCode isEqualToString:PAD_ZERO_PARA]){
        [self loadZeroListView];
    } else if ([actCode isEqualToString:PAD_TABLE_ITEM]){
//        [self showView:CUSTOMER_LIST_VIEW];
//        [self.customerListView loadDatas];
    } else if ([actCode isEqualToString:PAD_SPECIAL_OPERATE]){
//        [self showView:SPECIALREASON_LIST_VIEW];
//        [self.specialReasonListView loadDatas];
   }
 //        else if ([actCode isEqualToString:PAD_FEE_PLAN]){
//        [self showView:FEEPLAN_LIST_VIEW];
//        [self.feePlanListView loadDatas];
//    }
        else if ([actCode isEqualToString:PAD_DISCOUNT_PLAN]){
//        [self showView:DISCOUNTPLAN_LIST_VIEW];
//        [self.discountPlanListView loadDatas];
            [self loadDiscountPlanListView];
    } else if ([actCode isEqualToString:PAD_SIGN_PERSON]){
        [self showView:SIGNBILL_LIST_VIEW];
//        [self.signBillListView loadDatas];
    }
 //       else if ([actCode isEqualToString:MARKET_EMENU_STYLE]){
//        [self showView:KINDMENUSTYLE_LIST_VIEW];
//        [self.kindMenuStyleListView loadDatas];
////    } else if ([actCode isEqualToString:PAD_DATA_CLEAR]){
////        [self showView:DATA_CLEAR_VIEW];
////        [self.dataClearView loadData];
//    } else if ([actCode isEqualToString:PAD_CANCEL_BIND]){
      //  [self showView:CANCEL_BIND_VIEW];
//    } else if ([actCode isEqualToString:PAD_CHANGE_QUEUE]){
//        [self showView:CANCEL_QUEU_VIEW];
//    }
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}

- (void)loadNameValueView
{
    if (self.nameValueView) {
        self.nameValueView.view.hidden = NO;
    } else {
        self.nameValueView = [[NameValueListView alloc] init];
        [self.view addSubview:self.nameValueView.view];
    }
}

//系统参数
- (void)loadSysParaEditView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sysParaEditViewController];
    [self.rootController pushViewController:viewController animated:YES];
}
//店家信息
- (void)loadShopBaseView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopBaseViewController];
    [self.rootController pushViewController:viewController animated:YES];
}
//营业结束时间
- (void)loadOpenTimePlanView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_openTimePlanViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadKindPayEditView
{
//    if (self.kindPayEditView) {
//        self.kindPayEditView.view.hidden = NO;
//    } else {
//        self.kindPayEditView=[[TDFKindPayDetailViewController alloc] initWithParent:self];
//        [self.view addSubview:self.kindPayEditView.view];
//    }
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_KindPayEditViewWithData:nil action:0 delegate:nil];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadKindPayListView
{
//    if (self.kindPayListView) {
//        self.kindPayListView.view.hidden = NO;
//    } else {
//        self.kindPayListView=[[KindPayListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.kindPayListView.view];
//    }
//    UIViewController *viewController  =[[TDFMediator sharedInstance] TDFMediator_KindPayListView];
//    [self.rootController pushViewController: viewController animated:YES];
}


- (void)loadTimeArrangeListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TimeArrangeListViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadLinkManEditView
{
    if (self.linkManEditView) {
        self.linkManEditView.view.hidden = NO;
    } else {
        self.linkManEditView=[[LinkManEditView alloc] initWithNibName:@"LinkManEditView"bundle:nil parent:self];
        [self.view addSubview:self.linkManEditView.view];
    }
}

- (void)loadLinkManListView
{
    if (self.linkManListView) {
        self.linkManListView.view.hidden = NO;
    } else {
        self.linkManListView=[[LinkManListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.linkManListView.view];
    }
}

- (void)loadShopTemplateEditView
{
//    if (self.shopTemplateEditView) {
//        self.shopTemplateEditView.view.hidden = NO;
//    } else {
//        self.shopTemplateEditView=[[ShopTemplateEditView alloc] initWithNibName:@"ShopTemplateEditView"bundle:nil parent:self];
//        [self.view addSubview:self.shopTemplateEditView.view];
//    }
}

- (void)loadShopTemplateListView
{
//    if (self.shopTemplateListView) {
//        self.shopTemplateListView.view.hidden = NO;
//    } else {
//        self.shopTemplateListView=[[ShopTemplateListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.shopTemplateListView.view];
//    }
}

- (void)loadPrinterParasEditView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_PrinterParasEditViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadKindMenuStyleListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_KindMenuStyleListView];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadZeroListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_ZeroListViewController];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadTailDealEditView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TailDealEditViewControllerWithAction:ACTION_CONSTANTS_ADD];
    [self.rootController pushViewController:viewController animated:YES];
}

- (void)loadCustomerListView
{
//    if (self.customerListView) {
//        self.customerListView.view.hidden = NO;
//    } else {
//        self.customerListView=[[CustomerListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.customerListView.view];
//    }
}

- (void)loadDicItemEditView
{
//    if (self.dicItemEditView) {
//        self.dicItemEditView.view.hidden = NO;
//    } else {
//        self.dicItemEditView=[[DicItemEditView alloc] initWithNibName:@"DicItemEditView"bundle:nil parent:self];
//        [self.view addSubview:self.dicItemEditView.view];
//    }
}

- (void)loadSpecialReasonListView
{
//    if (self.specialReasonListView) {
//        self.specialReasonListView.view.hidden = NO;
//    } else {
//        self.specialReasonListView=[[SpecialReasonListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.specialReasonListView.view];
//    }
}

- (void)loadFeePlanListView
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_FeePlanListView];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadFeePlanEditView
{
//    if (self.feePlanEditView) {
//        self.feePlanEditView.view.hidden = NO;
//    } else {
//        self.feePlanEditView=[[FeePlanEditView alloc] initWithNibName:@"FeePlanEditView"bundle:nil parent:self];
//        [self.view addSubview:self.feePlanEditView.view];
//    }
}

- (void)loadDiscountPlanListView
{
//    self.discountPlanEditView.view.hidden=YES;
//    if (self.discountPlanListView) {
//        self.discountPlanListView.view.hidden = NO;
//    } else {
//        self.discountPlanListView=[[DiscountPlanListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.discountPlanListView.view];
//    }
}

- (void)loadDiscountPlanEditView
{
//    if (self.discountPlanEditView) {
//        self.discountPlanEditView.view.hidden = NO;
//    } else {
//        self.discountPlanEditView=[[DiscountPlanEditView alloc] initWithNibName:@"DiscountPlanEditView"bundle:nil parent:self];
//        [self.view addSubview:self.discountPlanEditView.view];
//    }
}

- (void)loadDiscountDetailEditView
{
//    if (self.discountDetailEditView) {
//        self.discountDetailEditView.view.hidden = NO;
//    } else {
//        self.discountDetailEditView=[[DiscountDetailEditView alloc] initWithNibName:@"DiscountDetailEditView"bundle:nil parent:self];
//        [self.view addSubview:self.discountDetailEditView.view];
//    }
}

- (void)loadDiscountMenuDetailEditView
{
//    if (self.discountMenuDetailEditView) {
//        self.discountMenuDetailEditView.view.hidden = NO;
//    } else {
//        self.discountMenuDetailEditView=[[DiscountMenuDetailEditView alloc] initWithNibName:@"DiscountMenuDetailEditView"bundle:nil parent:self];
//        [self.view addSubview:self.discountMenuDetailEditView.view];
//    }
}

- (void)loadSignBillListView
{
//    if (self.signBillListView) {
//        self.signBillListView.view.hidden = NO;
//    } else {
//        self.signBillListView=[[SignBillListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.signBillListView.view];
//    }
}

- (void)loadSignBillEditView
{
//    if (self.signBillEditView) {
//        self.signBillEditView.view.hidden = NO;
//    } else {
//        self.signBillEditView=[[SignBillEditView alloc] initWithNibName:@"SignBillEditView"bundle:nil parent:self];
//        [self.view addSubview:self.signBillEditView.view];
//    }
}

- (void)loadSignBillDetailEditView
{
//    if (self.signBillDetailEditView) {
//        self.signBillDetailEditView.view.hidden = NO;
//    } else {
//        self.signBillDetailEditView=[[SignBillDetailEditView alloc] initWithNibName:@"SignBillDetailEditView"bundle:nil parent:self];
//        [self.view addSubview:self.signBillDetailEditView.view];
//    }
}

- (void)loadSignerEditView
{
//    if (self.signerEditView) {
//        self.signerEditView.view.hidden = NO;
//    } else {
//        self.signerEditView=[[SignerEditView alloc] initWithNibName:@"SignerEditView"bundle:nil parent:self];
//        [self.view addSubview:self.signerEditView.view];
//    }
}


- (void)loadDataClearView
{
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_DataClearViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadCancelBindView
{
    if (self.cancelBindView) {
        self.cancelBindView.view.hidden = NO;
    } else {
        self.cancelBindView=[[CancelBindView alloc] initWithNibName:@"CancelBindView"bundle:nil parent:self];
        [self.view addSubview:self.cancelBindView.view];
    }
}

- (void)loadCancelQueuView
{
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_CancelQueuViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadTableEditView
{
    if (self.tableEditView) {
        self.tableEditView.view.hidden = NO;
    } else {
        self.tableEditView = [[TableEditView alloc] initWithNibName:@"TableEditView" bundle:nil];
        [self.view addSubview:self.tableEditView.view];
    }
}

- (void)loadMultiCheckView
{
    if (self.multiCheckView) {
        self.multiCheckView.view.hidden = NO;
    } else {
        self.multiCheckView=[[MultiCheckView alloc] init];
        [self.view addSubview:self.multiCheckView.view];
    }
}

-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}


- (void)loadAddNewCopousView
{
//    if (self.addNewCopous) {
//        self.addNewCopous.view.hidden = NO;
//    }else{
//        self.addNewCopous = [[TDFAddNewCopousInfoViewController alloc] initWithParent:self];
//        [self.view addSubview:self.addNewCopous.view];
//    }
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_TDFAddNewCopousInfoViewControllerWithData:nil action:0 delegate:nil];
    [self.rootController pushViewController:viewController animated:YES];
}
@end
