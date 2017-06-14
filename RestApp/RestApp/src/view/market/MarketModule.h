//
//  MarketModule.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmsListView.h"
#import "SmsEditView.h"
#import "MultiCheckView.h"
#import "SmsReChargeView.h"
#import "LifeInfoEditView.h"
#import "LifeInfoListView.h"
#import "EnvelopeListView.h"
#import "MenuSelectHandle.h"
#import "MenuTimeEditView.h"
#import "MenuTimeEditView.h"
#import "MenuTimeListView.h"
#import "EnvelopeEditView.h"
#import "SmsTemplateView.h"
#import "EnvelopeDetailView.h"
#import "SelectMenuListView.h"
#import "SmsReciverListView.h"
#import "SmsOrderConfirmView.h"
#import "MenuTimePriceEditView.h"
#import "SelectMultiMenuListView.h"
@class MainModule, MBProgressHUD,SmsTemplateView;
@interface MarketModule : UIViewController
{
    MainModule *mainModule;
}
@property (nonatomic, strong) SmsListView* smsListView;
@property (nonatomic, strong) SmsEditView* smsEditView;
@property (nonatomic, strong) SmsTemplateView *smsTemplateView;
@property (nonatomic, strong) SmsReciverListView* smsReciverListView;
@property (nonatomic, strong) SmsReChargeView* smsReChargeView;
@property (nonatomic, strong) SmsOrderConfirmView* smsOrderConfirmView;

@property (nonatomic, strong) MultiCheckView* multiCheckView;
@property (nonatomic, strong) MenuTimeEditView *menuTimeEditView;
@property (nonatomic, strong) MenuTimePriceEditView *menuTimePriceEditView;
@property (nonatomic, strong) SelectMultiMenuListView *selectMultiMenuListView;
@property (nonatomic, strong) SelectMenuListView *selectMenuListView;
@property (nonatomic, strong) MenuTimeListView *menuTimeListView;

@property (nonatomic, strong) EnvelopeListView *envelopeListView;
@property (nonatomic, strong) EnvelopeEditView *envelopeEditView;
@property (nonatomic, strong) EnvelopeDetailView *envelopeDetailView;

@property (nonatomic, strong) LifeInfoListView *lifeInfoListView;
@property (nonatomic, strong) LifeInfoEditView *lifeInfoEditView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)backMenu;

- (void)backToMain;

-(void)backToPreviousView;

-(void)backToMemberViewView;

-(void)backLastView:(NSString *)modlue viewTag:(int)viewTag;

- (void)showView:(int)viewTag;

- (void)showActionCode:(NSString*)actCode;

-(void)showSMSRehargeViewActionCode:(int)remainNum action:(int)action;

-(void)showLifeInfoListActionCode:(NSString *)code action:(NSInteger)action;

-(void)showsmsListActionCode:(NSString *)code action:(NSInteger)action;
-(void)showenvelopeActionCode:(NSString *)code action:(NSInteger)action;
-(void)showmenuTimeListViewActionCode:(NSString*)code action:(int)action;
-(void)backNavigateMenuView;
@end
