//
//  LogisticModule.m
//  RestApp
//
//  Created by hm on 15/1/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockModule.h"
#import "StockSearchView.h"
#import "ServiceFactory.h"
#import "SecondMenuView.h"
#import "SystemUtil.h"
#import "MBProgressHUD.h"
#import "UIMenuAction.h"
#import "MainModule.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "StockCheckListView.h"
#import "StockCheckEditView.h"
#import "StockCheckRawEditView.h"
#import "StockAdjustListView.h"
#import "StockAdjustEditView.h"
#import "StockRawEditView.h"
#import "StockAdjustReasonListView.h"
#import "StockAdjustReasonEditView.h"
#import "ActionConstants.h"
#import "StockRawSelectView.h"
#import "StoreHouseListView.h"
#import "StoreHouseEditView.h"
#import "MultiCheckView.h"
#import "StockQueryView.h"
#import "StockQueryListView.h"
#import "ScanView.h"
#import "MatchingKindMenu.h"
#import "StockFiltrateListView.h"
#import "PaperExportListView.h"
#import "StoreMultiMenuListView.h"
@implementation StockModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;

}

-(void) backMenu
{
    //[self removeNotification];
    [mainModule backMenuBySelf:self];
}
-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}
- (void)removeNotification
{
    if (self.stockFiltrateListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockFiltrateListView];
    }
    if (self.paperExportListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.paperExportListView];
    }
    if (self.matchingKindMenuView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingKindMenuView];
    }
    if (self.stockRawSelectView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockRawSelectView];
    }
    if (self.stockAdjustReasonListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockAdjustReasonListView];
    }
    if (self.stockAdjustReasonEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockAdjustReasonEditView];
    }
    if (self.stockAdjustListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockAdjustListView];
    }
    if (self.stockAdjustEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockAdjustEditView];
    }
    if (self.stockRawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockRawEditView];
    }
    if (self.stockQueryView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockQueryView];
    }
    if (self.stockQueryListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockQueryListView];
    }
    if (self.stockCheckListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockCheckListView];
    }
    if (self.stockCheckEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockCheckEditView];
    }
    if (self.stockCheckRawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stockCheckRawEditView];
    }
    if (self.storeHouseListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.storeHouseListView];
    }
    if (self.storeHouseEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.storeHouseEditView];
    }
    if (self.storeMultiMenuListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.storeMultiMenuListView];
    }
    if (self.multiCheckView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.multiCheckView];
    }
}

#pragma mark - 隐藏module下所有初始化的view
- (void) hideView
{
    for (UIView *view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

- (void)showView:(int)viewTag {
    
    if (viewTag == STOCK_SEARCH_VIEW ) {
        [self loadStockSearchView];
        [self.view bringSubviewToFront:self.stockSearchView.view];
        [self.stockSearchView oper];
        return;
    }
    
  
    [self hideView];
    
    if (viewTag == STOCK_SECOND_VIEW) {
        
        [self loadSecondMenuView];
        self.secondMenuView.titleBox.lblTitle.text = NSLocalizedString(@"库存管理", nil);
        
    } else if (viewTag == STOCK_RAW_SELECT_VIEW) {
        
        [self loadStockRawSelectView];
        
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
        
    } else if (viewTag == STOCK_ADJUST_LIST_VIEW) {  //库存调整单列表
        
        [self loadStockAdjustListView];
        
    } else if (viewTag == STOCK_ADJUST_EDIT_VIEW) {
        
        [self loadStockAdjustEditView];
        
    } else if (viewTag == STOCK_RAW_EDIT_VIEW) {
        
        [self loadStockRawEditView];
        
    } else if (viewTag == STOCK_QUERY_VIEW) {
        
        [self loadStockQueryView];
        
    } else if (viewTag == STOCK_QUERY_LIST_VIEW) {
        
        [self loadStockQueryListView];
        
    } else if (viewTag == STOCK_ADJUST_REASON_LIST_VIEW) {
        
        [self loadStockAdjustReasonListView];
        
    }else if (viewTag == STOCK_ADJUST_REASON_EDIT_VIEW) {
        
        [self loadStockAdjustReasonEditView];
        
    // 仓库一览页面
    } else if (viewTag == STOCK_STOREHOUSE_LIST_VIEW) {
        
        [self loadStoreHouseListView];
        
    }else if (viewTag == STOCK_STOREHOUSE_EDIT_VIEW) {
        
        [self loadStoreHouseEditView];
        
    } else if (viewTag == STOCK_STOREHOUSE_KINDMENU_SELECT_VIEW) {
        
        [self loadStoreHouseKindMenuSelectView];
        
    } else if (viewTag == STOCK_STOREHOUSE_MENU_SELECT_VIEW) {
        
        [self loadStoreHouseMenuSelectView];
        
    } else if (viewTag == STOCK_CHECK_LIST_VIEW) {
        
        [self loadStockCheckListView];

    } else if (viewTag == STOCK_CHECK_EDIT_VIEW) {
        
        [self loadStockCheckEditView];
        
    } else if (viewTag == STOCK_CHECK_RAW_EDIT_VIEW) {
        
        [self loadStockCheckRawEditView];
        
    } else if (viewTag == STOCK_QUERY_SCAN_VIEW) {
        
        [self loadScanView];

    }else if (viewTag == STOCK_FILTRATE_LIST_VIEW) {

        [self loadStockFiltrateListView];
    
    }else if (viewTag == STOCK_EXPORT_LIST_VIEW) {
    
        [self loadPaperExportListView];
    }
}

-(void) loadDatas;
{
    [self showView:STOCK_SECOND_VIEW];
}

#pragma mark - MenuSelectHandle协议方法创建二级菜单

- (NSMutableArray *)createList {
    NSMutableArray *items = [NSMutableArray array];
    
    UIMenuAction *action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存查询", nil) detail:@"" img:@"ico_kucunchaxun.png" code:SUPPLY_STOCK];
    [items addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存调整", nil) detail:@"" img:@"ico_kucuntiaozheng.png" code:SUPPLY_CHANGE];
    [items addObject:action];
    
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"库存盘存", nil) detail:@"" img:@"ico_pancun.png" code:SUPPLY_STORE];
    [items addObject:action];
    
    // 仓库管理菜单添加
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"仓库管理", nil) detail:@"" img:@"ico_cangku.png" code:SUPPLY_WAREHOUSE];
    [items addObject:action];
    
    return items;
}

#pragma mark - 捕捉页面itemslist事件
-(void) onMenuSelectHandle:(UIMenuAction *)action {
    
    if ([action.code isEqualToString:SUPPLY_STOCK]) {

        [self showView:STOCK_QUERY_VIEW];
        
    }else if ([action.code isEqualToString:SUPPLY_CHANGE]) {
        
        [self showView:STOCK_ADJUST_LIST_VIEW];
        
        [self.stockAdjustListView loadDatas:nil action:ACTION_STOCK_ADJUST_LIST];
        [self.stockSearchView resetLblVal];
        
    }else if ([action.code isEqualToString:SUPPLY_STORE]) {
        
        [self showView:STOCK_CHECK_LIST_VIEW];
        
        [self.stockCheckListView loadDatas:nil action:ACTION_STOCK_CHECK_LIST];
        [self.stockSearchView resetLblVal];
   
    // 仓库管理页面时
    } else if ([action.code isEqualToString:SUPPLY_WAREHOUSE]) {
        
        // 显示仓库一览视图
        [self showView:STOCK_STOREHOUSE_LIST_VIEW];
        
        [self.storeHouseListView loadStoreHouses];
    }
    
    [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
}
#pragma mark - 加载module下页面
/*加载module页面*/
- (void)loadSecondMenuView
{
    if (self.secondMenuView) {
        self.secondMenuView.view.hidden= NO;
    }else{
        self.secondMenuView = [[SecondMenuView alloc] initWithNibName:@"SecondMenuView" bundle:nil delegate:self];
        [self.view addSubview:self.secondMenuView.view];
    }
}

/*导出页面*/
- (void)loadPaperExportListView
{
    if (self.paperExportListView) {
        self.paperExportListView.view.hidden = NO;
    }else{
    
        self.paperExportListView = [[PaperExportListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperExportListView"] bundle:nil];
        [self.view addSubview:self.paperExportListView.view];
    }
}


/*加载库存调整页面*/
- (void)loadStockAdjustListView
{
    if (self.stockAdjustListView) {
        self.stockAdjustListView.view.hidden = NO;
    }else{
        self.stockAdjustListView = [[StockAdjustListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil parent:self];
        [self.view addSubview:self.stockAdjustListView.view];
    }
}

/*加载库存盘存页面*/
- (void)loadStockCheckListView
{
    if (self.stockCheckListView) {
        self.stockCheckListView.view.hidden = NO;
    }else{
    
        self.stockCheckListView = [[StockCheckListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil parent:self];
        [self.view addSubview:self.stockCheckListView.view];
    }
}

/*加载筛选页面*/
- (void)loadStockSearchView
{
    if (self.stockSearchView) {
        self.stockSearchView.view.hidden = NO;
    }else{
        self.stockSearchView = [[StockSearchView alloc] initWithNibName:[SystemUtil getXibName:@"StockSearchView"] bundle:nil parent:self];
        [self.view addSubview:self.stockSearchView.view];
    }
}

/*加载导出筛选页面*/
- (void)loadStockFiltrateListView
{
    if (self.stockFiltrateListView) {
        self.stockFiltrateListView.view.hidden = NO;
    }else{
        self.stockFiltrateListView = [[StockFiltrateListView alloc] initWithNibName:[SystemUtil getXibName:@"FiltrateListView"] bundle:nil parent:self];
        [self.view addSubview:self.stockFiltrateListView.view];
    }
}


/*加载选择原料页面*/
- (void)loadStockRawSelectView
{
    if (self.stockRawSelectView) {
        self.stockRawSelectView.view.hidden = NO;
    }else{
        //原料添加页面.
        self.stockRawSelectView = [[StockRawSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StockRawSelectView"] bundle:nil parent:self];
    }
    [self.view addSubview:self.stockRawSelectView.view];
    
}

/*选择原料分类页面*/


// 加载仓库一览视图
- (void)loadStoreHouseListView
{
    if (self.storeHouseListView) {
        
        self.storeHouseListView.view.hidden = NO;

    } else {
        
        self.storeHouseListView = [[StoreHouseListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        
        [self.view addSubview:self.storeHouseListView.view];
        
    }
}

// 加载仓库编辑页面视图
- (void)loadStoreHouseEditView
{
    if (self.storeHouseEditView) {
        
        self.storeHouseEditView.view.hidden = NO;
        
    } else {
        
        self.storeHouseEditView = [[StoreHouseEditView alloc] initWithNibName:[SystemUtil getXibName:@"StoreHouseEditView"] bundle:nil parent:self];
        
        [self.view addSubview:self.storeHouseEditView.view];
    }
}

// 加载仓库商品选择视图
- (void)loadStoreHouseMenuSelectView
{
    if (self.storeMultiMenuListView) {
        self.storeMultiMenuListView.view.hidden = NO;
    }else{
        self.storeMultiMenuListView = [[StoreMultiMenuListView alloc] initWithNibName:[SystemUtil getXibName:@"StoreMultiMenuListView"] bundle:nil];
        [self.view addSubview:self.storeMultiMenuListView.view];
    }
}

// 加载仓库商品分类选择视图
- (void)loadStoreHouseKindMenuSelectView
{
    if (self.multiCheckView) {
        
        self.multiCheckView.view.hidden = NO;
        
    } else {
        
        self.multiCheckView=[[MultiCheckView alloc] init];
        
        [self.view addSubview:self.multiCheckView.view];
    }
}

/*加载库存调整单页面*/
- (void)loadStockAdjustEditView
{
    if (self.stockAdjustEditView) {
        self.stockAdjustEditView.view.hidden = NO;
    }else{
        self.stockAdjustEditView = [[StockAdjustEditView alloc] initWithNibName:[SystemUtil getXibName:@"StockAdjustEditView"] bundle:nil parent:self];
        [self.view addSubview:self.stockAdjustEditView.view];
    }

}

/*加载调整单原料详情页*/
- (void)loadStockRawEditView
{
    if (self.stockRawEditView) {
        self.stockRawEditView.view.hidden = NO;
    }else{
        self.stockRawEditView =[[StockRawEditView alloc] initWithNibName:[SystemUtil getXibName:@"StockRawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.stockRawEditView.view];
    }
}

/*加载调整原因列表页面*/
- (void)loadStockAdjustReasonListView
{
    if (self.stockAdjustReasonListView) {
        self.stockAdjustReasonListView.view.hidden = NO;
    }else{
        self.stockAdjustReasonListView = [[StockAdjustReasonListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.stockAdjustReasonListView.view];
    }

}

/*加载调整原因添加页面*/
- (void)loadStockAdjustReasonEditView
{
    if (self.stockAdjustReasonEditView) {
        self.stockAdjustReasonEditView.view.hidden = NO;
    }else{
        self.stockAdjustReasonEditView = [[StockAdjustReasonEditView alloc] initWithNibName:[SystemUtil getXibName:@"StockAdjustReasonEditView"] bundle:nil parent:self];
        [self.view addSubview:self.stockAdjustReasonEditView.view];
    }
}

/*加载盘存单详情页面*/
- (void)loadStockCheckEditView
{
    if (self.stockCheckEditView) {
        self.stockCheckEditView.view.hidden = NO;
    }else{
        self.stockCheckEditView = [[StockCheckEditView alloc] initWithNibName:[SystemUtil getXibName:@"StockCheckEditView"] bundle:nil parent:self];
        [self.view addSubview:self.stockCheckEditView.view];
    }
}

/*加载盘存原料详情页*/
- (void)loadStockCheckRawEditView
{
    if (self.stockCheckRawEditView) {
        self.stockCheckRawEditView.view.hidden = NO;
    }else{
        self.stockCheckRawEditView = [[StockCheckRawEditView alloc] initWithNibName:[SystemUtil getXibName:@"StockCheckRawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.stockCheckRawEditView.view];
    }
}

// 加载库存查询视图
- (void)loadStockQueryView
{
    if (self.stockQueryView) {
        
        self.stockQueryView.view.hidden = NO;
        
    } else {
        
        self.stockQueryView = [[StockQueryView alloc]initWithNibName:[SystemUtil getXibName:@"StockQueryView"]  bundle:nil parent:self];
        
        [self.view addSubview:self.stockQueryView.view];
    }
}

// 加载库存列表视图
- (void)loadStockQueryListView
{
    if (self.stockQueryListView) {
        
        self.stockQueryListView.view.hidden = NO;
        
    } else {
        
        self.stockQueryListView = [[StockQueryListView alloc]initWithNibName:[SystemUtil getXibName:@"StockQueryListView"] bundle:nil parent:self];
        
        [self.view addSubview:self.stockQueryListView.view];
    }
}

// 加载扫一扫视图
- (void)loadScanView
{
    if (self.scanView) {
        
        self.scanView.view.hidden = NO;
        
    } else {
        
        // 扫一扫页面
        self.scanView = [[ScanView alloc] initWithNibName:[SystemUtil getXibName:@"ScanView"] bundle:nil];
        
        [self.view addSubview:self.scanView.view];
    }
}

@end
