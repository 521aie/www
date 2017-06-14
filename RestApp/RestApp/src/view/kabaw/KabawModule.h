//
//  KabawModule.h
//  RestApp
//
//  Created by zxh on 14-5-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSelectHandle.h"
#import "SpecialTagModule.h"

@class MainModule,SettingService,MenuService,SecondMenuView,BaseSetingView;
@class SingleCheckView,MultiCheckView,BellEditView,GiftListView,GiftEditView,MapLocationView;
@class KindCardListView,CardCoverListView,KabawMenuEditView,BaseSetingView,ShopCodeView;
@class TakeOutSetEditView;
@class SenderListView,SenderEditView,TakeOutTimeListView,TakeOutTimeEditView,ShopEditView,KabawMenuListView,KabawMenuEditView,BaseSetingView;
@class MoneyRuleListView,MoneyRuleEditView,MoneyRuleMenuView,QueuKindListView,SpecialTagListView,SpecialTagEditView,BaseSetingView;
@interface KabawModule :  SpecialTagModule<MenuSelectHandle>
{
    MainModule *mainModule;
    
    SettingService *settingservice;
    
    MenuService *menuService;
}

@property (nonatomic, strong) UINavigationController *rootController;

@property (nonatomic, strong) SecondMenuView *secondMenuView;
@property (nonatomic, strong) MultiCheckView* multiCheckView;
@property (nonatomic, strong) BellEditView* bellEditView;
@property (nonatomic, strong) GiftListView* giftListView;
@property (nonatomic, strong) GiftEditView* giftEditView;
@property (nonatomic, strong) KindCardListView* kindCardListView;
@property (nonatomic, strong) CardCoverListView* cardCoverListView;
@property (nonatomic, strong) TakeOutSetEditView* takeOutSetEditView;
@property (nonatomic, strong) SenderListView* senderListView;
@property (nonatomic, strong) SenderEditView* senderEditView;
@property (nonatomic, strong) TakeOutTimeListView* takeOutTimeListView;
@property (nonatomic, strong) TakeOutTimeEditView* takeOutTimeEditView;
@property (nonatomic, strong) ShopEditView* shopEditView;
@property (nonatomic, assign)BOOL isShow;
//@property (nonatomic, strong) ShopCodeView* shopCodeView;
//@property (nonatomic, strong) BaseSetingView *baseSetingView;

@property (nonatomic, strong) KabawMenuListView* kabawMenuListView;
@property (nonatomic, strong) KabawMenuEditView* kabawMenuEditView;
@property (nonatomic, strong) MoneyRuleMenuView* moneyRuleMenuView;
@property (nonatomic, strong) MoneyRuleListView* moneyRuleListView;
@property (nonatomic, strong) MoneyRuleEditView* moneyRuleEditView;
//@property (nonatomic, strong) QueuKindListView *queuKindListView;
//@property (nonatomic, strong) ShopBlackListView *shopBlackListView;
@property (nonatomic, strong) MapLocationView* mapLocationView;
//@property (nonatomic, strong) ShopSalesRankView *shopSalesRankView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)controller;

- (void)showView:(int) viewTag;

- (void)showMenu;

- (void)backToMain;

- (void)showActionCode:(NSString*)actCode;

- (void)backNavigateMenuView;

- (void)showShopEditViewWithBackIndex:(NSInteger)backIndex;
@end
