//
//  MenuModule.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "SuitMenuModule.h"
#import "MenuModule.h"
#import "MainModule.h"
#import "SystemUtil.h"
#import "SuitMenuEditView.h"
#import "MultiMasterManagerView.h"
#import "MultiCheckManageView.h"
#import "MenuService.h"
#import "ServiceFactory.h"
#import "MenuListView.h"
#import "MenuEditView.h"
#import "SuitUnitListView.h"
#import "SingleCheckView.h"
#import "SelectSpecView.h"
#import "XHAnimalUtil.h"
#import "MultiCheckView.h"
#import "MultiDetailView.h"
#import "MenuSpecDetailEditView.h"
#import "KindMenuListView.h"
#import "KindMenuEditView.h"
#import "UnitListView.h"
#import "TableEditView.h"
#import "UnitListView.h"
#import "UnitEditView.h"
#import "KindTasteEditView.h"
#import "BatchMenuListView.h"
#import "MakeListView.h"
#import "MakeEditView.h"
#import "SpecListView.h"
#import "SpecEditView.h"
#import "TasteEditView.h"
#import "MenuMakeEditView.h"
#import "TreeNodeSortView.h"
#import "AdditionListView.h"
#import "KindAdditionEditView.h"
#import "MenuAdditionEditView.h"
#import "SpecialTagListView.h"
#import "SpecialTagEditView.h"
#import "orderDetailsView.h"
#import "MenuCodeView.h"
#import "TDFMediator+MenuModule.h"
#import "SortTableEditView.h"

@implementation MenuModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        service = [ServiceFactory Instance].menuService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

-(void)showTargetView{
    [self showView:SUITMENU_EDIT_VIEW];
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
#pragma mart module part.
- (void)initMainModule
{
    self.menuListView=[[MenuListView alloc] init];
    [self.view addSubview:self.menuListView.view];
}

#pragma data load init
- (void)loadMenus
{
    [self showView:MENU_LIST_VIEW];
    [self.menuListView loadMenus];
}

- (void)loadMenuKinds
{
    [self showView:KINDMENU_LIST_VIEW];
    [self.kindMenuListView loadKindMenuData];
}

- (void)loadMenuMakes
{
    [self showView:MAKE_LIST_VIEW];
    [self.makeListView reLoadData];
}

- (void)loadMenuAdditions
{
    [self showView:ADDITION_LIST_VIEW];
    [self.additionListView loadDatas];
}

- (void)loadMenuSpecs
{
    [self showView:SPEC_LIST_VIEW];
    [self.specListView reLoadData];
}

- (void)loadMenuTastes
{
    [self showView:SUITMENUTASTE_LIST_VIEW];
    [self.tasteListView loadDatas];
}

- (void)hideView
{
    for (UIView* view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

- (void)showView:(NSInteger)viewTag
{
    [self hideView];
    if (viewTag==MULTI_CHECK_VIEW) {
        [self loadMultiCheckView];
    } else if (viewTag==MULTI_HEAD_CHECK_VIEW) {
        [self loadMultiHeadCheckView];
    } else if (viewTag==MULTI_CHECK_MANAGER_VIEW) {
        [self loadMultiCheckManageView];
    } else if (viewTag==MENU_LIST_VIEW) {
        self.menuListView.view.hidden = NO;        
    } else if (viewTag==MENU_EDIT_VIEW) {
        [self loadMenuEditView];
    } else if (viewTag==KINDMENU_LIST_VIEW) {
        [self loadKindMenuListView];
    } else if (viewTag==KINDMENU_EDIT_VIEW) {
        [self loadKindMenuEditView];
    } else if (viewTag==TABLE_EDIT_VIEW) {   //表格编辑页.
        [self loadTableEditView];
    }  else if (viewTag==SORT_TABLE_EDIT_VIEW) {   //表格编辑页.
        [self loadSortNewTableEditView];
    }else if (viewTag==UNIT_LIST_VIEW) {
        [self loadUnitListView];
    } else if (viewTag==UNIT_EDIT_VIEW) {
        [self loadUnitEditView];
    } else if (viewTag==MAKE_LIST_VIEW) {
        [self loadMakeListView];
    } else if (viewTag==MAKE_EDIT_VIEW){
        [self loadMakeEditView];
    }else if (viewTag==SPEC_LIST_VIEW) {
        [self loadSpecListView];
    } else if (viewTag==SPEC_EDIT_VIEW) {
        [self loadSpecEditView];
    } else if (viewTag==TASTE_EDIT_VIEW) {
        [self loadTasteEditView];
    } else if (viewTag==BATCH_MULTI_MENU_VIEW) {
        [self loadBatchMenuListView];
    } else if (viewTag==KINDTASTE_EDIT_VIEW) {
        [self loadKindTasteEditView];
    } else if (viewTag==ADDITION_LIST_VIEW) {
        [self loadAdditionListView];
    } else if (viewTag==KINDADDITION_EDIT_VIEW) {
        [self loadKindAdditionEditView];
    } else if (viewTag==MENUADDITION_EDIT_VIEW ) {
        [self loadMenuAdditionEditView];
    } else if (viewTag==MENUMAKE_EDIT_VIEW) {
        [self loadMenuMakeEditView];
    } else if (viewTag==SELECT_SPEC_VIEW) {
        [self loadSelectSpecView];
    } else if (viewTag==MENUSPECDETAIL_EDIT_VIEW) {
        [self loadMenuSpecDetailEditView];
    } else if (viewTag==SPECIAL_TAG_LIST_VIEW) {
        [self loadSpecialTagListView];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
    } else if (viewTag==SPECIAL_TAG_EDIT_VIEW) {
        [self loadSpecialTagEditView];
    }
    else if (viewTag ==MUNU_DETAIL_VIEW)
    {
        [self loadOrderDetailsView];
    }else if (viewTag == MENU_CODE_VIEW){
        [self loadMenuCodeView];
    }else if(viewTag==MULTI_CHECK_VIEW) {
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
        [self loadSuitUnitListView];
    } else if (viewTag==SUITUNIT_EDIT_VIEW) {
        [self loadSuitUnitEditView];
    } else if (viewTag==SPECIAL_TAG_LIST_VIEW) {
        self.specialTagListView.view.hidden=NO;
    } else if (viewTag==SPECIAL_TAG_EDIT_VIEW) {
        self.specialTagEditView.view.hidden=NO;
    } else if (viewTag == SUITMENU_CODE_VIEW){
        [self loadMenuCodeView];
    }  else if (viewTag==SORT_TABLE_EDIT_VIEW) {   //表格编辑页.
        [self loadSortNewTableEditView];
    }

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

//商品单位编辑页
- (void)loadSuitUnitEditView
{
    if (self.suitUnitEditView) {
        self.suitUnitEditView.view.hidden=NO;
    } else {
        self.suitUnitEditView=[[SuitUnitEditView alloc] initWithNibName:@"UnitEditView" bundle:nil parent:self];
        [self.view addSubview:self.suitUnitEditView.view];
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
        self.unitListView=[[UnitListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.unitListView.view];
    }
}

//商品单位页
- (void)loadSuitUnitListView
{
    if (self.suitUnitListView) {
        self.suitUnitListView.view.hidden=NO;
    } else {
        self.suitUnitListView=[[SuitUnitListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.suitUnitListView.view];
    }
}

//商品单位编辑页
- (void)loadUnitEditView
{
    if (self.unitEditView) {
        self.unitEditView.view.hidden=NO;
    } else {
        self.unitEditView=[[UnitEditView alloc] initWithNibName:@"UnitEditView" bundle:nil parent:self];
        [self.view addSubview:self.unitEditView.view];
    }
}

/**
 * 菜肴二维码
 */
-(void)loadMenuCodeView{
    
    if (self.menuCodeView) {
        self.menuCodeView.view.hidden = NO;
    }else{
        self.menuCodeView= [[MenuCodeView alloc] initWithNibName:@"MenuCodeView" bundle:nil parent:self];
        [self.view addSubview:self.menuCodeView.view];
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

//-(void)showTargetView{
//    [self showView:SUITMENU_EDIT_VIEW];
//}
//
//-(void)showTargetView{
//    [self showView:MENU_EDIT_VIEW];
//}

- (void)loadMenuEditView
{
    if (self.menuEditView) {
        self.menuEditView.view.hidden = NO;
    } else {
        self.menuEditView=[[MenuEditView alloc] initWithNibName:@"MenuEditView" bundle:nil parent:self];
        [self.view addSubview:self.menuEditView.view];
    }
}

- (void)loadSelectSpecView
{
    if (self.selectSpecView) {
        self.selectSpecView.view.hidden = NO;
    } else {
        self.selectSpecView=[[SelectSpecView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
        [self.view addSubview:self.selectSpecView.view];
    }
}

- (void)loadMultiCheckManageView
{
    if (self.multiCheckManageView) {
        self.multiCheckManageView.view.hidden = NO;
    } else {
        self.multiCheckManageView=[[MultiCheckManageView alloc] initWithNibName:@"MultiHeadCheckView" bundle:nil];
        [self.view addSubview:self.multiCheckManageView.view];
    }
}

- (void)loadKindMenuListView
{
    if (self.kindMenuListView) {
        self.kindMenuListView.view.hidden = NO;
    } else {
            self.kindMenuListView=[[KindMenuListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.kindMenuListView.view];
    }
}

- (void)loadKindMenuEditView
{
    if (self.kindMenuEditView) {
        self.kindMenuEditView.view.hidden = NO;
    } else {
        self.kindMenuEditView=[[KindMenuEditView alloc] init];
        [self.view addSubview:self.kindMenuEditView.view];
    }
}

- (void)loadMakeListView
{
    if (self.makeListView) {
        self.makeListView.view.hidden = NO;
    } else {
         self.makeListView=[[MakeListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.makeListView.view];
    }
}

- (void)loadMakeEditView
{
    if (self.makeEditView) {
        self.makeEditView.view.hidden = NO;
    } else {
       self.makeEditView =[[MakeEditView alloc] init];
        [self.view addSubview:self.makeEditView.view];
    }
}

- (void)loadMenuMakeEditView
{
    if (self.menuMakeEditView) {
        self.menuMakeEditView.view.hidden = NO;
    } else {
        self.menuMakeEditView=[[MenuMakeEditView alloc] initWithNibName:@"MenuMakeEditView" bundle:nil parent:self];
        [self.view addSubview:self.menuMakeEditView.view];
    }
}

- (void)loadSpecListView
{
    if (self.specListView) {
        self.specListView.view.hidden = NO;
    } else {
        self.specListView=[[SpecListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.specListView.view];
    }

}

- (void)loadSpecEditView
{
    if (self.specEditView) {
        self.specEditView.view.hidden = NO;
    } else {
          self.specEditView=[[SpecEditView alloc] initWithNibName:@"SpecEditView" bundle:nil parent:self];
        [self.view addSubview:self.specEditView.view];
    }

}


- (void)loadMenuSpecDetailEditView
{
    if (self.menuSpecDetailEditView) {
        self.menuSpecDetailEditView.view.hidden = NO;
    } else {
          self.menuSpecDetailEditView=[[MenuSpecDetailEditView alloc] initWithNibName:@"MenuSpecDetailEditView" bundle:nil parent:self];
        [self.view addSubview:self.menuSpecDetailEditView.view];
    }
}

- (void)loadBatchMenuListView
{
    if (self.batchMenuListView) {
        self.batchMenuListView.view.hidden = NO;
    } else {
          self.batchMenuListView=[[BatchMenuListView alloc] initWithNibName:@"SelectMultiMenuListView" bundle:nil parent:self];
        [self.view addSubview:self.batchMenuListView.view];
    }
}

- (void)loadAdditionListView
{
    if (self.additionListView) {
        self.additionListView.view.hidden = NO;
    } else {
        self.additionListView=[[AdditionListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.additionListView.view];
    }
}

- (void)loadKindAdditionEditView
{
    if (self.kindAdditionEditView) {
        self.kindAdditionEditView.view.hidden = NO;
    } else {
         self.kindAdditionEditView=[[KindAdditionEditView alloc] initWithNibName:@"KindAdditionEditView" bundle:nil parent:self];
        [self.view addSubview:self.kindAdditionEditView.view];
    }
}

- (void)loadMenuAdditionEditView
{
    if (self.menuAdditionEditView) {
        self.menuAdditionEditView.view.hidden = NO;
    } else {
         self.menuAdditionEditView=[[MenuAdditionEditView alloc] initWithNibName:@"MenuAdditionEditView" bundle:nil parent:self];
        [self.view addSubview:self.menuAdditionEditView.view];
    }
}

- (void)loadSpecialTagListView
{
    if (self.specialTagListView) {
        self.specialTagListView.view.hidden = NO;
    } else {
          self.specialTagListView = [[SpecialTagListView alloc] initWithNibName:@"SpecialTagListView" bundle:nil parent:self moduleName:@"menu"];
        [self.view addSubview:self.specialTagListView.view];
    }
}

- (void)loadSpecialTagEditView
{
    if (self.specialTagEditView) {
        self.specialTagEditView.view.hidden = NO;
    } else {
        self.specialTagEditView = [[SpecialTagEditView alloc] initWithNibName:@"SpecialTagEditView" bundle:nil parent:self moduleName:@"menu"];
        [self.view addSubview:self.specialTagEditView.view];
    }
}


-(void)loadOrderDetailsView
{
    if (self.orderDetailsView) {
        
        self.orderDetailsView.view.hidden=NO;
    }
    else
    {
        self.orderDetailsView =[[orderDetailsView alloc]initWithMenuNibName:@"orderDetailsView" bundle:nil parent:self];
        [self.view addSubview:self.orderDetailsView.view];
    }
}

@end
