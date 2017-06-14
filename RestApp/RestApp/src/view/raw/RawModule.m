//
//  RawModule.m
//  RestApp
//
//  Created by yanl on 15/2/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RawModule.h"
#import "MBProgressHUD.h"
#import "MainModule.h"
#import "SystemUtil.h"
#import "SecondRawView.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "ActionConstants.h"
#import "KindRawListView.h"
#import "ServiceFactory.h"
#import "KindRawEditView.h"
#import "RawEditView.h"
#import "RawUnitListView.h"
#import "RawUnitEditView.h"
#import "SubUnitView.h"
#import "BatchRawListView.h"
#import "MatchingKindMenu.h"
#import "MatchingEditView.h"
#import "MatchingRawEditView.h"
#import "MatchingRawSelectView.h"
#import "ScanView.h"
#import "RawPaginationListView.h"
#import "RemoteEvent.h"
#import "MatchingMenuListView.h"

@implementation RawModule

// 实现指定初始化方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        service = [ServiceFactory Instance].rawService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

// 返回主菜单
- (void)backMenu
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
    if (self.secondRawView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.secondRawView];
    }
    if (self.rawPaginationListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.rawPaginationListView];
    }
    if (self.kindRawListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.kindRawListView];
    }
    if (self.kindRawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.kindRawEditView];
    }
    if (self.rawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.rawEditView];
    }
    if (self.unitListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.unitListView];
    }
    if (self.unitEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.unitEditView];
    }
    if (self.subUnitView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.subUnitView];
    }
    if (self.batchRawListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.batchRawListView];
    }
    if (self.matchingMenuListView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingMenuListView];
    }
    if (self.matchingKindMenuView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingKindMenuView];
    }
    if (self.matchingEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingEditView];
    }
    if (self.matchingRawEditView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingRawEditView];
    }
    if (self.matchingRawSelectView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.matchingRawSelectView];
    }
    if (self.scanView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.scanView];
    }
}

// 隐藏视图
- (void)hideView
{
    for (UIView *view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

// 显示视图
- (void) showView:(int)viewTag
{
  

    [self hideView];
    if (viewTag == RAW_CONTROL_VIEW) {
        [self loadSecondRawView];
        self.secondRawView.titleBox.lblTitle.text = NSLocalizedString(@"原料管理", nil);
        [self.secondRawView loadDatas];
        [XHAnimalUtil animal:self type:kCATransition direct:kCATransitionFromLeft];
    } else if (viewTag == RAW_GOODS_LIST_VIEW) {
        [self loadRawPagitionView];
    } else if (viewTag == KINDRAW_LIST_VIEW) {
        [self loadKindRawListView];
    } else if (viewTag == KINDRAW_EDIT_VIEW) {
        [self loadKindRawEditView];
    } else if (viewTag == RAW_EDIT_VIEW) {
        [self loadRawEditView];
    } else if (viewTag == RAW_UNIT_LIST_VIEW) {
        [self loadRawUnitListView];
    } else if (viewTag == RAW_UNIT_EDIT_VIEW) {
        [self loadRawUnitEditView];
    } else if (viewTag == RAW_SUBUNIT_EDIT_VIEW) {
        [self loadRawSubUnitEditView];
    } else if (viewTag == BATCH_MULTI_RAW_VIEW) {
        [self loadBatchRawView];
    } else if (viewTag == MATCHING_LIST_VIEW) {
        [self loadMatchingMenuListView];
        [self.matchingMenuListView loadMenus];
    } else if (viewTag == MATCHING_EDIT_VIEW) {
        [self loadMatchingEditView];
    } else if (viewTag == MATCHING_RAW_EDIT_VIEW) {
        [self loadMatchingRawEditView];
    } else if (viewTag == MATCHING_RAW_SELECT_VIEW) {
        [self loadMatchingRawSelectView];
    } else if (viewTag == RAW_SCAN_VIEW) {
        [self loadScanView];
    }
}

#pragma data load init

// 数据加载
-(void) loadDatas;
{
    // 调用显示视图方法
    [self showView:RAW_CONTROL_VIEW];
}

// 菜单选择事件处理
- (void) onMenuSelectHandle:(UIMenuAction *)action
{
    if ([action.code isEqualToString:SUPPLY_RAW]) {
        [self showView:RAW_GOODS_LIST_VIEW];
        [self.rawPaginationListView searchData:0];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    } else if ([action.code isEqualToString:SUPPLY_MENU_RAW]) {
        [self showView:MATCHING_LIST_VIEW];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    }
}

// 创建原料管理菜单
- (NSMutableArray *)createList
{
    // 创建菜单数组
    NSMutableArray *rawItems = [NSMutableArray array];
    
    // 创建原料管理菜单
    UIMenuAction *action = [[UIMenuAction alloc] init:NSLocalizedString(@"原料", nil) detail:@"" img:@"ico_yuanliao" code:SUPPLY_RAW];
    
    // 放入集合
    [rawItems addObject:action];
    
    // 创建商品原料配比菜单
    action = [[UIMenuAction alloc] init:NSLocalizedString(@"商品原料配比", nil) detail:NSLocalizedString(@"各商品的原料配比", nil) img:@"ico_yuanliaopeibi" code:SUPPLY_MENU_RAW];
    
    // 放入集合
    [rawItems addObject:action];
    
    return rawItems;
}

#pragma mark - module页面
/*加载主页面*/
- (void)loadSecondRawView
{
    if (self.secondRawView) {
        self.secondRawView.view.hidden = NO;
    } else {
        self.secondRawView = [[SecondRawView alloc] initWithNibName:[SystemUtil getXibName:@"SecondRawView"] bundle:nil delegate:self];
        [self.view addSubview:self.secondRawView.view];
    }
}

/*加载商品配比分类*/

// 加载原料分页列表
- (void)loadRawPagitionView
{
    if (self.rawPaginationListView) {
        self.rawPaginationListView.view.hidden = NO;
    } else {
        self.rawPaginationListView = [[RawPaginationListView alloc] initWithNibName:[SystemUtil getXibName:@"RawPaginationListView"] bundle:nil parent:self];
        [self.view addSubview:self.rawPaginationListView.view];
    }
}

// 加载原料分类一览
- (void)loadKindRawListView
{
    if (self.kindRawListView) {
        self.kindRawListView.view.hidden = NO;
    } else {
        self.kindRawListView = [[KindRawListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.kindRawListView.view];
    }
    [self.kindRawListView loadKinds];
}

// 加载原料分类编辑视图
- (void) loadKindRawEditView
{
    if (self.kindRawEditView) {
        self.kindRawEditView.view.hidden = NO;
    } else {
        self.kindRawEditView = [[KindRawEditView alloc] initWithNibName:[SystemUtil getXibName:@"KindRawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.kindRawEditView.view];
    }
}

// 加载原料编辑视图
- (void)loadRawEditView
{
    if (self.rawEditView) {
        self.rawEditView.view.hidden = NO;
    } else {
        self.rawEditView = [[RawEditView alloc] initWithNibName:[SystemUtil getXibName:@"RawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.rawEditView.view];
    }
}

- (void)loadRawUnitListView
{
    if (self.unitListView) {
        self.unitListView.view.hidden = NO;
    } else {
        self.unitListView = [[RawUnitListView alloc] initWithNibName:@"SampleListView" bundle:nil parent:self];
        [self.view addSubview:self.unitListView.view];
    }
}

// 加载单位编辑视图
- (void)loadRawUnitEditView
{
    if (self.unitEditView) {
        self.unitEditView.view.hidden = NO;
    } else {
        self.unitEditView = [[RawUnitEditView alloc] initWithNibName:@"RawUnitEditView" bundle:nil parent:self];
        [self.view addSubview:self.unitEditView.view];
    }
}

// 加载辅助单位编辑视图
- (void)loadRawSubUnitEditView
{
    if (self.subUnitView) {
        self.subUnitView.view.hidden = NO;
    } else {
        self.subUnitView = [[SubUnitView alloc] initWithNibName:[SystemUtil getXibName:@"SubUnitView"] bundle:nil parent:self];
        [self.view addSubview:self.subUnitView.view];
    }
}

// 加载批量处理视图
- (void)loadBatchRawView
{
    if (self.batchRawListView) {
        self.batchRawListView.view.hidden = NO;
    } else {
        self.batchRawListView = [[BatchRawListView alloc] initWithNibName:[SystemUtil getXibName:@"BatchRawListView"] bundle:nil parent:self];
        [self.view addSubview:self.batchRawListView.view];
    }
}

// 加载商品原料配比列表
- (void)loadMatchingMenuListView
{
    if (self.matchingMenuListView) {
        self.matchingMenuListView.view.hidden = NO;
    } else {
        self.matchingMenuListView = [[MatchingMenuListView alloc] initWithNibName:[SystemUtil getXibName:@"MatchingMenuListView"] bundle:nil parent:self];
        [self.view addSubview:self.matchingMenuListView.view];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    }
}

// 加载商品原料配比编辑页面
- (void)loadMatchingEditView
{
    if (self.matchingEditView) {
        self.matchingEditView.view.hidden = NO;
    } else {
        self.matchingEditView = [[MatchingEditView alloc] initWithNibName:[SystemUtil getXibName:@"MatchingEditView"] bundle:nil parent:self];
        [self.view addSubview:self.matchingEditView.view];
    }
}

// 加载加工原料编辑页面
- (void)loadMatchingRawEditView
{
    if (self.matchingRawEditView) {
        self.matchingRawEditView.view.hidden = NO;
    } else {
        self.matchingRawEditView = [[MatchingRawEditView alloc] initWithNibName:[SystemUtil getXibName:@"MatchingRawEditView"] bundle:nil parent:self];
        [self.view addSubview:self.matchingRawEditView.view];
    }
}

// 加载商品原料配比原料选择页面
- (void)loadMatchingRawSelectView
{
    if (self.matchingRawSelectView) {
        self.matchingRawSelectView.view.hidden = NO;
    } else {
        self.matchingRawSelectView = [[MatchingRawSelectView alloc] initWithNibName:[SystemUtil getXibName:@"MatchingRawSelectView"] bundle:nil parent:self];
        [self.view addSubview:self.matchingRawSelectView.view];
    }
}

// 加载扫一扫视图
- (void)loadScanView
{
    if (self.scanView) {
        self.scanView.view.hidden = NO;
    } else {
        self.scanView = [[ScanView alloc] initWithNibName:[SystemUtil getXibName:@"ScanView"] bundle:nil];
        [self.view addSubview:self.scanView.view];
    }
}

@end
