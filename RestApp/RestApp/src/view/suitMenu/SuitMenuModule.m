//
//  SuitMenuModule.m
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuModule.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "XHAnimalUtil.h"
#import "SortTableEditView.h"
#import "MainModule.h"
#import "MenuCodeView.h"
#import "SystemUtil.h"
#import "SuitMenuChangeEditView.h"
#import "SpecialTagListView.h"
#import "SpecialTagEditView.h"
#import "MultiCheckView.h"
#import "MultiMasterManagerView.h"
#import "TableEditView.h"
#import "SuitMenuEditView.h"
#import "UnitListView.h"
#import "SelectMenuListView.h"
#import "MenuDetailEditView.h"
#import "UnitEditView.h"
#import "SuitMenuKindEditView.h"
#import "SuitTasteListView.h"
#import "SuitTasteEditView.h"
#import "SuitKindTasteEditView.h"
#import "SuitUnitListView.h"
#import "SuitUnitEditView.h"
#import "KindMenuListView.h"
@implementation SuitMenuModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainModule];
}

#pragma mart module part.
- (void)initMainModule
{
    self.specialTagListView = [[SpecialTagListView alloc] initWithNibName:@"SpecialTagListView" bundle:nil parent:self moduleName:@"suitmenu"];
    self.specialTagEditView = [[SpecialTagEditView alloc] initWithNibName:@"SpecialTagEditView" bundle:nil parent:self moduleName:@"suitmenu"];
    [self.view addSubview:self.specialTagListView.view];
    [self.view addSubview:self.specialTagEditView.view];
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
#pragma ui change
- (void)hideView
{
    for(UIView* view in [self.view subviews]){
        [view setHidden:YES];
    }
}

- (void)showView:(NSInteger) viewTag
{
    [self hideView];
    if(viewTag==MULTI_CHECK_VIEW) {
        [self loadMultiCheckView];
    } else if (viewTag==MULTI_HEAD_CHECK_VIEW) {
        [self loadMultiHeadCheckView];
    } else if (viewTag==SUITMENU_EDIT_VIEW) {
        [self loadSuitMenuEditView];
    } else if (viewTag==MENUDETAIL_EDIT_VIEW) {
        [self loadMenuDetailEditView];
    } else if (viewTag==SUITMENU_SELECTMENU_VIEW) {
        [self loadSelectMenuListView];
    } else if (viewTag==SUITMENUCHANGE_EDIT_VIEW) {
        [self loadSuitMenuChangeEditView];
    } else if (viewTag==SUITMENUKIND_EDIT_VIEW) {
        [self loadSuitMenuKindEditView];
    } else if (viewTag==SUITMENUTASTE_LIST_VIEW) {
        [self loadTasteListview];
    } else if (viewTag==SUITMENUTASTE_EDIT_VIEW) {
        [self loadTasteEditView];
    } else if (viewTag==SUITMENU_KINDTASTE_EDIT_VIEW) {
        [self loadKindTasteEditView];
    } else if (viewTag==TABLE_EDIT_VIEW) {
        [self loadTableEditView];
    } else if (viewTag==SUITUNIT_LIST_VIEW) {
        [self loadUnitListView];
    } else if (viewTag==SUITUNIT_EDIT_VIEW) {
        [self loadUnitEditView];
    } else if (viewTag==SPECIAL_TAG_LIST_VIEW) {
        self.specialTagListView.view.hidden=NO;
    } else if (viewTag==SPECIAL_TAG_EDIT_VIEW) {
        self.specialTagEditView.view.hidden=NO;
    }  else if (viewTag==SORT_TABLE_EDIT_VIEW) {   //表格编辑页.
        [self loadSortNewTableEditView];
    }
}
- (void)backMenu
{
    [mainModule backMenuBySelf:self];
}
-(void)backNavigateMenuView
{
    
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}

//加载多选页.
- (void)loadMultiCheckView
{
    if (self.multiCheckView) {
        self.multiCheckView.view.hidden=NO;
    } else {
        self.multiCheckView=[[MultiCheckView alloc] init];
        [self.view addSubview:self.multiCheckView.view];
    }
}

//加载子表
- (void)loadMultiHeadCheckView
{
    if (self.multiHeadCheckView) {
        self.multiHeadCheckView.view.hidden=NO;
    } else {
        self.multiHeadCheckView=[[MultiMasterManagerView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
        [self.view addSubview:self.multiHeadCheckView.view];
    }
}

//加载套餐编辑页
- (void)loadSuitMenuEditView
{
    if (self.suitMenuEditView) {
        self.suitMenuEditView.view.hidden=NO;
    } else {
        self.suitMenuEditView=[[SuitMenuEditView alloc] initWithNibName:@"SuitMenuEditView" bundle:nil parent:self];
        [self.view addSubview:self.suitMenuEditView.view];
    }
}

//加载表格排序.
- (void)loadTableEditView
{
    if (self.tableEditView) {
        self.tableEditView.view.hidden=NO;
    } else {
        self.tableEditView=[[TableEditView alloc] initWithNibName:@"TableEditView" bundle:nil];
        [self.view addSubview:self.tableEditView.view];
    }
}

//加载详细编辑页
- (void)loadMenuDetailEditView
{
    if (self.menuDetailEditView) {
        self.menuDetailEditView.view.hidden=NO;
    } else {
        self.menuDetailEditView=[[MenuDetailEditView alloc] init];
        [self.view addSubview:self.menuDetailEditView.view];
    }
}

//套餐选择商品页.
- (void)loadSelectMenuListView
{
    if (self.selectMenuListView) {
        self.selectMenuListView.view.hidden=NO;
    } else {
        self.selectMenuListView=[[SelectMenuListView alloc] initWithNibName:@"SelectMenuListView" bundle:nil];
        [self.view addSubview:self.selectMenuListView.view];
    }
}

//套餐选择可换商品 .
- (void)loadSuitMenuChangeEditView
{
    if (self.suitMenuChangeEditView) {
        self.suitMenuChangeEditView.view.hidden=NO;
    } else {
        self.suitMenuChangeEditView=[[SuitMenuChangeEditView alloc] initWithNibName:@"SuitMenuChangeEditView" bundle:nil parent:self];
        [self.view addSubview:self.suitMenuChangeEditView.view];
    }
}

//套餐分类编辑页
- (void)loadSuitMenuKindEditView
{
    if (self.suitMenuKindEditView) {
        self.suitMenuKindEditView.view.hidden=NO;
    } else {
        self.suitMenuKindEditView=[[SuitMenuKindEditView alloc] init];
        [self.view addSubview:self.suitMenuKindEditView.view];
    }
}

//口味列表页
- (void)loadTasteListview
{
    if (self.tasteListView) {
        self.tasteListView.view.hidden=NO;
    } else {
        self.tasteListView=[[SuitTasteListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.tasteListView.view];
    }
}

//口味编辑页
- (void)loadTasteEditView
{
    if (self.tasteEditView) {
        self.tasteEditView.view.hidden=NO;
    } else {
        self.tasteEditView=[[SuitTasteEditView alloc] initWithNibName:@"TasteEditView" bundle:nil parent:self];
        [self.view addSubview:self.tasteEditView.view];
    }
}

//口味分类编辑页
- (void)loadKindTasteEditView
{
    if (self.kindTasteEditView) {
        self.kindTasteEditView.view.hidden=NO;
    } else {
        self.kindTasteEditView=[[SuitKindTasteEditView alloc] initWithNibName:@"KindTasteEditView" bundle:nil parent:self];
        [self.view addSubview:self.kindTasteEditView.view];
    }
}

//商品单位页
- (void)loadUnitListView
{
    if (self.unitListView) {
        self.unitListView.view.hidden=NO;
    } else {
        self.unitListView=[[SuitUnitListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.unitListView.view];
    }
}

//商品单位编辑页
- (void)loadUnitEditView
{
    if (self.unitEditView) {
        self.unitEditView.view.hidden=NO;
    } else {
        self.unitEditView=[[SuitUnitEditView alloc] initWithNibName:@"UnitEditView" bundle:nil parent:self];
        [self.view addSubview:self.unitEditView.view];
    }
}

- (void)loadSortNewTableEditView
{
    if (self.sortTableEditView) {
        self.sortTableEditView.view.hidden = NO;
    } else {
        self.sortTableEditView=[[SortTableEditView alloc] initWithNibName:@"TableEditView" bundle:nil];
        [self.view addSubview:self.sortTableEditView.view];
    }
}

-(void)showTargetView{
    [self showView:SUITMENU_EDIT_VIEW];
}


@end
