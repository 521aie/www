//
//  StoresManagerView.h
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ItemTitle.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "ChainService.h"
#import "ServiceFactory.h"
#import "ShopVO.h"
#import "StoresView.h"
#import "EditItemRadio.h"
#import "TDFBranchCompanyListViewController.h"
#import "TDFRootViewController.h"
#import "EditItemList.h"

#define  BRAND_LIST 1
#define BRANCH_COMPANY 2
#define JOIN_MODE_LIST 3

@class NavigateTitle2,EditItemText,MBProgressHUD,EditItemView,EditItemList;
@interface StoresManagerView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,IEditItemRadioEvent,OptionSelectClient,IEditItemListEvent>

@property (nonatomic,copy) void (^editStoresCallBack)(BOOL orRefresh);
@property (nonatomic) BOOL changed;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic, weak) IBOutlet EditItemText *txtShopName;
@property (nonatomic, weak) IBOutlet EditItemView *lblShopCode;
@property (nonatomic, weak) IBOutlet EditItemList *listShopBrand;
@property (nonatomic, weak) IBOutlet EditItemText *txtEmail;
@property (nonatomic, weak) IBOutlet EditItemText *txtLinker;
@property (nonatomic, weak) IBOutlet EditItemText *txtMobile;
@property (nonatomic, weak) IBOutlet EditItemText *txtAddress;
@property (nonatomic, weak) IBOutlet EditItemRadio *superCompanyRadio;
@property (nonatomic, weak) IBOutlet EditItemList *superCompany;
@property (weak, nonatomic) IBOutlet EditItemList *listJoinMode;

@property (nonatomic, strong) EditItemList *obj;
@property (nonatomic ,strong) NSString *plateId;
@property (nonatomic ,strong) NSString *branchEntityId;
@property (nonatomic ,strong) NSString *branchId;
@property (nonatomic ,strong) NSString *branchName;
@property (nonatomic ,strong) NSString *code;
@property (nonatomic ,strong) NSString *shopId;
@property (nonatomic ,strong) ShopVO *shopVo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
