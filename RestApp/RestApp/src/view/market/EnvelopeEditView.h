//
//  CouponEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Shop.h"
#import "ItemTitle.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import <UIKit/UIKit.h>
#import "EditItemText.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "MBProgressHUD.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "CalendarClient.h"
#import "MemoInputClient.h"
#import "EnvelopeService.h"
#import "ISampleListEvent.h"
#import "DatePickerClient.h"
#import "MessageBoxClient.h"
#import "NumberInputClient.h"
#import "IEditItemMemoEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"

@class MarketModule;
@interface EnvelopeEditView : UIViewController<INavigateEvent,FooterListEvent,IEditItemListEvent,NumberInputClient,DatePickerClient,ISampleListEvent,IEditItemRadioEvent,MessageBoxClient>
{
    MarketModule *parent;
    
    EnvelopeService *service;
    
    MBProgressHUD *hud;
    
    Coupon *coupon;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet ItemTitle *baseTitle;
@property (nonatomic, strong) IBOutlet EditItemList *lsPublishFee;
@property (nonatomic, strong) IBOutlet EditItemList *lsPublishNum;
@property (nonatomic, strong) IBOutlet EditItemView *lblShopName;
@property (nonatomic, strong) IBOutlet EditItemList *lsConsumeFee;
@property (nonatomic, strong) IBOutlet EditItemList *lsPeriod;
@property (nonatomic, strong) IBOutlet ItemTitle *upgradeTitle;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoExpand;
@property (nonatomic, strong) IBOutlet EditItemList *lsExpandNum;
@property (nonatomic, strong) IBOutlet EditItemList *lsExpandFee;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalInfo;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblShop;
@property (nonatomic, strong) IBOutlet UILabel *lblUnit;
@property (nonatomic, strong) IBOutlet UILabel *lblPeriod;
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, assign) NSInteger action;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;

-(void) loadDataAction:(int)action isContinue:(BOOL)isContinue;

@end
