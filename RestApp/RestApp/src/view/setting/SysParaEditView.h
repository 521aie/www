//
//  SysParaEditView.h
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "EditItemList.h"
#import "ItemTitle.h"
#import "EditItemRadio.h"
#import "ItemBase.h"
#import "NavigateTitle.h"
#import "SettingService.h"
#import "ConfigVO.h"
#import "FooterListEvent.h"
#import "NumberInputClient.h"
#import "IEditItemRadioEvent.h"
#import "MBProgressHUD.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"
@class NavigateTitle2,FooterListView;
@interface SysParaEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,IEditItemRadioEvent,FooterListEvent,NumberInputClient>
{
    SettingService *service;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) ItemTitle *baseTitle;
@property (nonatomic, strong) EditItemList *lsLanguage;
@property (nonatomic, strong) EditItemRadio *rdoIsMultiOrder;
@property (nonatomic, strong) EditItemRadio *rdoIsSeatLabel;

@property (nonatomic, strong) EditItemRadio *rdoIsLimitTime;
@property (strong, nonatomic) EditItemRadio *rdoIsConfirmRight;
@property (nonatomic, strong) EditItemList *lsLimitTimeEnd;
@property (nonatomic, strong) EditItemList *lsLimitTimeWarn;
@property (nonatomic, strong) ItemTitle *dishParaTitle;
@property (nonatomic, strong) EditItemRadio *rdoMergeSendInstance;
@property (nonatomic, strong) EditItemRadio *rdoMergeInstance;

@property (nonatomic, strong) ItemTitle *feeParaTitle;
@property (nonatomic, strong) EditItemRadio *rdoServiceFee;
@property (nonatomic, strong) EditItemRadio *rdoLowFee;
@property (nonatomic, strong) EditItemRadio *rdoAdjustFee;
@property (nonatomic,strong) ItemTitle *shouyin;
@property (nonatomic,strong) EditItemRadio *shouyineffect;

@property (nonatomic, strong) ConfigVO* mergeSendInstanceConfig;
@property (nonatomic, strong) ConfigVO* mergeInstanceConfig;

@property (nonatomic, strong) ConfigVO* multiOrderConfig;
@property (nonatomic, strong) ConfigVO* limitTimeConfig;
@property (nonatomic, strong) ConfigVO* languageConfig;
@property (nonatomic, strong) ConfigVO*  isComfirmRight;
@property (nonatomic, strong) ConfigVO* isServiceFeeDiscountConfig;
@property (nonatomic, strong) ConfigVO* minConsumeModeConfig;
@property (nonatomic, strong) ConfigVO* isSetMinConsumeModeConfig;
@property (nonatomic, strong) ConfigVO *isPermissionCashConfig;
@property (nonatomic, strong) ConfigVO* isSeatLabelConfig;
@property (nonatomic, strong) ConfigVO* limitTimeEndConfig;
@property (nonatomic, strong) ConfigVO* limitTimeWarnConfig;

@property (nonatomic) BOOL changed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) initMainView;

-(void) loadData;

@end
