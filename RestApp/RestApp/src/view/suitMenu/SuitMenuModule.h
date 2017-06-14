//
//  SuitMenuModule.h
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialTagModule.h"
#import "MenuModule.h"
@class MainModule,MBProgressHUD;
@class MultiCheckView,MultiMasterManagerView,TableEditView;
@class SuitMenuEditView,SuitUnitListView,SuitUnitEditView,MenuDetailEditView;
@class SuitMenuChangeEditView,SuitMenuKindEditView;
@class SuitTasteListView,SuitKindTasteEditView,SuitTasteEditView,SortTableEditView;
@interface SuitMenuModule : SpecialTagModule
{
    MBProgressHUD *hud;
    
    MainModule *mainModule;
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
@property (nonatomic, strong) SuitUnitListView* unitListView;
@property (nonatomic, strong) SuitUnitEditView* unitEditView;
@property (nonatomic, strong) SortTableEditView *sortTableEditView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)showView:(NSInteger)viewTag;

- (void)loadMenus;

- (void)backMenu;

-(void)backNavigateMenuView;

@end
