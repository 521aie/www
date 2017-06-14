//
//  SettingModule.h
//  RestApp
//
//  Created by zxh on 14-3-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSelectHandle.h"
#import "ISampleListEvent.h"
#import "DiscountMenuDetailEditView.h"
@class MainModule,SettingService,TableEditView,ZeroListView,CustomerListView;
@class SettingSecondView,SysParaEditView,OpenTimePlanView,TDFKindPayDetailViewController,TDFAddNewCopousInfoViewController,DiscountMenuDetailEditView;
@class LinkManListView,LinkManEditView,ShopTemplateEditView,ShopTemplateListView,KindPayListView;
@class TailDealEditView,DicItemEditView,SpecialReasonListView;
@class NameValueListView,SingleCheckView,MultiCheckView,KindMenuStyleListView,TimeArrangeListView;
@class FeePlanListView,FeePlanEditView,DiscountPlanListView,DiscountPlanEditView,DiscountDetailEditView,PrinterParasEditView;
@class SignBillListView,SignBillEditView,DataClearView,CancelBindView,SignBillDetailEditView,SignerEditView,CancelQueuView,FuctionView;

@interface SettingModule : UIViewController
{
    MainModule *mainModule;
    
    SettingService *service;
}

@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, strong) SettingSecondView *secondMenuView;
@property (nonatomic, strong) TableEditView *tableEditView;
@property (nonatomic, strong) SysParaEditView *sysParaEditView;
@property (nonatomic, strong) CustomerListView *customerListView;
@property (nonatomic, strong) MultiCheckView *multiCheckView;
@property (nonatomic, strong) OpenTimePlanView *openTimePlanView;
@property (nonatomic, strong) NameValueListView *nameValueView;
@property (nonatomic, strong) TDFKindPayDetailViewController *kindPayEditView;
@property (nonatomic, strong) TDFAddNewCopousInfoViewController *addNewCopous;
@property (nonatomic, strong) KindPayListView *kindPayListView;
@property (nonatomic, strong) TimeArrangeListView *timeArrangeListView;
@property (nonatomic, strong) LinkManListView *linkManListView;
@property (nonatomic, strong) LinkManEditView *linkManEditView;
@property (nonatomic, strong) ShopTemplateEditView *shopTemplateEditView;
@property (nonatomic, strong) ShopTemplateListView *shopTemplateListView;
@property (nonatomic, strong) PrinterParasEditView *printerParasEditView;
@property (nonatomic, strong) KindMenuStyleListView *kindMenuStyleListView;
@property (nonatomic, strong) ZeroListView *zeroListView;
@property (nonatomic, strong) TailDealEditView *tailDealEditView;
@property (nonatomic, strong) DicItemEditView *dicItemEditView;
@property (nonatomic, strong) SpecialReasonListView *specialReasonListView;
@property (nonatomic, strong) FeePlanListView *feePlanListView;
@property (nonatomic, strong) FeePlanEditView *feePlanEditView;
@property (nonatomic, strong) DiscountPlanListView *discountPlanListView;
@property (nonatomic, strong) DiscountPlanEditView *discountPlanEditView;
@property (nonatomic, strong) DiscountDetailEditView *discountDetailEditView;
@property (nonatomic, strong) DiscountMenuDetailEditView *discountMenuDetailEditView;
@property (nonatomic, strong) SignBillListView *signBillListView;
@property (nonatomic, strong) SignBillEditView *signBillEditView;
@property (nonatomic, strong) SignerEditView *signerEditView;
@property (nonatomic, strong) SignBillDetailEditView *signBillDetailEditView;
@property (nonatomic, strong) DataClearView *dataClearView;
@property (nonatomic, strong) CancelBindView *cancelBindView;
@property (nonatomic, strong) CancelQueuView *cancelQueuView;
@property (nonatomic, strong) FuctionView *fucntionview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)controller;

- (void)showView:(NSInteger)viewTag;

- (void)showActionCode:(NSString *)actCode;

- (void)showMenu;

- (void)backMenu;

-(void)backNavigateMenuView;

-(void)showFuctionViewWithdata:(NSMutableArray *)data;
@end
