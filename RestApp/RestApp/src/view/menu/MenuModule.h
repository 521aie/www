//
//  MenuModule.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialTagModule.h"
#import "ISampleListEvent.h"
#import "MenuDetailEditView.h"
#import "SelectMenuListView.h"
#import "SuitMenuChangeEditView.h"
#import "SuitMenuKindEditView.h"
#import "SuitTasteListView.h"
#import "SuitTasteEditView.h"
#import "SuitKindTasteEditView.h"
#import "SuitUnitEditView.h"
#define TDFCHAINMWNU  5
@class MainModule,MenuService,MenuListView,MenuEditView,BatchMenuListView,MultiMasterManagerView;
@class MBProgressHUD,SingleCheckView,TreeNodeSortView,MenuSpecDetailEditView,MultiCheckManageView,SelectSpecView;
@class KindMenuEditView,KindMenuListView,MultiCheckView,TableEditView,MenuKabawEditView,KindTasteEditView,SortTableEditView;
@class UnitListView,UnitEditView,MakeListView,MakeEditView,SpecListView,SpecEditView,TasteEditView,MenuMakeEditView;
@class MainModule,MenuListView,AdditionListView,KindAdditionEditView,MenuAdditionEditView,MenuCodeView,SuitMenuEditView,SuitUnitListView;

@interface MenuModule : SpecialTagModule 
{
    MainModule *mainModule;
    
    MenuService *service;
    
    MBProgressHUD *hud;
}
@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, strong) TableEditView *tableEditView;
@property (nonatomic, strong) MultiCheckView* multiCheckView;
@property (nonatomic, strong) MultiMasterManagerView* multiHeadCheckView;
@property (nonatomic, strong) SuitMenuEditView* suitMenuEditView;
@property (nonatomic, strong) MenuDetailEditView* menuDetailEditView;
@property (nonatomic, strong) SelectMenuListView* selectMenuListView;
@property (nonatomic, strong) SuitMenuChangeEditView* suitMenuChangeEditView;
@property (nonatomic, strong) SuitMenuKindEditView* suitMenuKindEditView;
@property (nonatomic, strong) SuitTasteEditView* tasteEditView;
@property (nonatomic, strong) SuitKindTasteEditView* kindTasteEditView;
@property (nonatomic, strong) SuitTasteListView* tasteListView;
@property (nonatomic, strong) SuitUnitListView* suitUnitListView;
@property (nonatomic, strong) UnitListView* unitListView;
@property (nonatomic, strong) UnitEditView* unitEditView;
@property (nonatomic, strong) SuitUnitEditView* suitUnitEditView;
@property (nonatomic, strong) MenuCodeView *menuCodeView;
@property (nonatomic, strong) SortTableEditView *sortTableEditView;
@property (nonatomic, strong) MultiCheckManageView* multiCheckManageView;
@property (nonatomic, strong) SelectSpecView* selectSpecView;
@property (nonatomic, strong) MenuSpecDetailEditView* menuSpecDetailEditView;
@property (nonatomic, strong) MenuListView *menuListView;
@property (nonatomic, strong) BatchMenuListView* batchMenuListView;
@property (nonatomic, strong) MenuEditView *menuEditView;
@property (nonatomic, strong) MenuKabawEditView* menuKabawEditView;
@property (nonatomic, strong) KindMenuListView* kindMenuListView;
@property (nonatomic, strong) KindMenuEditView* kindMenuEditView;
@property (nonatomic, strong) MakeListView* makeListView;
@property (nonatomic, strong) MakeEditView* makeEditView;
@property (nonatomic, strong) MenuMakeEditView* menuMakeEditView;
@property (nonatomic, strong) SpecListView* specListView;
@property (nonatomic, strong) SpecEditView* specEditView;
@property (nonatomic, strong) AdditionListView* additionListView;
@property (nonatomic, strong) KindAdditionEditView* kindAdditionEditView;
@property (nonatomic, strong) MenuAdditionEditView* menuAdditionEditView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)showView:(NSInteger)viewTag;

- (void)loadMenus;
- (void)loadMenuKinds;
- (void)loadMenuMakes;
- (void)loadMenuAdditions;
- (void)loadMenuTastes;
- (void)loadMenuSpecs;
- (void)backMenu;
-(void)backNavigateMenuView;

@end
