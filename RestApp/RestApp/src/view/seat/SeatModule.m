//
//  SeatModule.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Area.h"
#import "Seat.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "SeatModule.h"
#import "MainModule.h"
#import "SystemUtil.h"
#import "RemoteEvent.h"

#import "SeatEditView.h"
#import "XHAnimalUtil.h"
#import "SeatListView.h"
#import "AreaListView.h"
#import "AreaEditView.h"
#import "TableEditView.h"
#import "SeatListPanel.h"
#import "ServiceFactory.h"
#import "INameValueItem.h"
#import "SingleCheckView.h"

@implementation SeatModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSeatData) name:@"TDFSeatChanged" object:nil];
}

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
- (void)initMainModule
{
//    self.seatListView = [[SeatListView alloc] initWithNibName:@"SeatListView"bundle:nil parent:self];
//
//    [self.view addSubview:self.seatListView.view];
}

- (void)hideView
{
    for (UIView* view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

-(void) showView:(NSInteger) viewTag
{
    [self hideView];
    if (viewTag==SEAT_LIST_VIEW) {
        self.seatListView.view.hidden=NO;
    } else if (viewTag==SEAT_EDIT_VIEW) {
        [self loadSeatEditView];
    } else if (viewTag==TABLE_EDIT_VIEW) {   //表格编辑页.
        [self loadTableEditView];
    } else if (viewTag==AREA_LIST_VIEW) {
        [self loadAreaListView];
    } else if (viewTag==AREA_EDIT_VIEW) {
        [self loadAreaEditView];
    }
}

-(void) removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.seatEditView];
}

#pragma data load init
- (void)loadSeatData
{
    [self showView:SEAT_LIST_VIEW];
//    [self.seatListView loadSeat];
}

#pragma load ui
//加载短信发送页.
- (void)loadSeatEditView
{
//    if (self.seatEditView) {
//        self.seatEditView.view.hidden=NO;
//    } else {
//        self.seatEditView=[[SeatEditView alloc] initWithNibName:@"SeatEditView"bundle:nil parent:self];
//        [self.view addSubview:self.seatEditView.view];
//    }
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

//加载区域列表.
- (void)loadAreaListView
{
//    if (self.areaListView) {
//        self.areaListView.view.hidden=NO;
//    } else {
//        self.areaListView=[[AreaListView alloc] initWithNibName:@"SampleListView"bundle:nil parent:self];
//        [self.view addSubview:self.areaListView.view];
//        [self.areaListView loadAreas];
//    }
}

//加载区域列表.
- (void)loadAreaEditView
{
//    if (self.areaEditView) {
//        self.areaEditView.view.hidden=NO;
//    } else {
//        self.areaEditView=[[AreaEditView alloc] initWithNibName:@"AreaEditView"bundle:nil parent:self];
//        [self.view addSubview:self.areaEditView.view];
//    }
}

@end

