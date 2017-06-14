//
//  SmartOrder.m
//  RestApp
//
//  Created by iOS香肠 on 16/3/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFOrderRdDetailViewController.h"
#import "orderRecommendView.h"
#import "orderDetailsView.h"
#import "SmartOrderModel.h"
#import "SpecialTagEditView.h"
#import "SpecialTagListView.h"
#import "orderRemindView.h"
#import "OrderListView.h"
#import "orderSetView.h"
#import "MainModule.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"

@implementation SmartOrderModel

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)controller
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        mainModel =controller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainModule];
}

-(void)initMainModule
{
    self.orderListView = [[OrderListView alloc] init];
    CGRect frame = self.orderListView.view.frame;
    frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.orderListView.view.frame = frame;

    [self.view addSubview:self.orderListView.view];
}

- (void)loadData
{
    [self showView:SMART_ORDER_LIST_VIEW];
}

-(void)backMenu
{
    if (self.back) {
        self.back();
    }
}

- (void)hideView
{
    for (UIView* view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

-(void)showView:(NSInteger)viewTag
{
    [self hideView];
    if (viewTag ==SMART_ORDER_LIST_VIEW ) {
        [self loadOrderList];
    }
    else if (viewTag == SMART_ORDER_SET_VIEW) {
        [self loadOrderSet];
    }
    else if (viewTag == SMART_ORDER_SET_REACT_VIEW) {
        [self loadSmartOrderSettingRNModel];
    }
    else if (viewTag == SMART_ORDER_DETAIS_VIEW) {
        
        [self loadOrderDetailsView];
    }
    else if (viewTag == SMARAT_ORDER_RECOMMEND_VIEW)
    {
        [self loadOrderRecommendView];
    }

    else if (viewTag == SMARAT_ORDER_RDDETAIL_VITE)
    {
//        [self loadOrderRdDetailView];
    }

    else if (viewTag == SMARAT_ORDER_REMAIND_VIEW )
    {
        [self loadOrderRemindView];
    }
    else if (viewTag==SPECIAL_TAG_LIST_VIEW) {
        [self loadSpecialTagListView];
        [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromTop];
    }
    else if (viewTag ==SPECIAL_TAG_EDIT_VIEW)
    {
        [self loadSpecialTagEditView];
    }
}

- (void)loadSpecialTagListView
{
    if (self.specialTagListView) {
        self.specialTagListView.view.hidden = NO;
    } else {
        self.specialTagListView = [[SpecialTagListView alloc] initWithNibName:@"SpecialTagListView" bundle:nil parent:self moduleName:@"order"];
        [self.view addSubview:self.specialTagListView.view];
    }
}




-(void)loadOrderList
{
    if (self.orderListView) {
        self.orderListView.view.hidden=NO;
    }
    else
    {
        self.orderListView =[[OrderListView alloc]initWithNibName:@"OrderListView" bundle:nil parent:self];
        [self.view addSubview:self.orderListView.view];
    }
    [self.orderListView  reloadData];
}

-(void)loadOrderSet
{
    if (self.orderSetView) {
        self.orderSetView.view.hidden =NO;
    }
    else
    {
        self.orderSetView =[[orderSetView alloc]initWithNibName:@"orderSetView" bundle:nil parent:self];
        CGRect frame = self.orderSetView.view.frame;
        frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
        self.orderSetView.view.frame = frame;
        
        [self.view addSubview:self.orderSetView.view];
    }
    
}

-(void)loadSmartOrderSettingRNModel
{
    if (self.smartOrderSettingRNModel) {
        self.smartOrderSettingRNModel.view.hidden =NO;
    }
    else
    {
        self.smartOrderSettingRNModel = [[SmartOrderSettingRNModel alloc] init];
        [self.view addSubview:self.smartOrderSettingRNModel.view];
    }
    
}

-(void)loadOrderDetailsView
{
   if (self.orderDetailsView) {
       self.orderDetailsView.view.hidden=NO;
    }
    else
    {
        self.orderDetailsView =[[orderDetailsView alloc]initWithNibName:@"orderDetailsView" bundle:nil parent:self];
        [self.orderDetailsView.view setWidth:SCREEN_WIDTH];
        [self.orderDetailsView.view setHeight:SCREEN_HEIGHT];
        [self.view addSubview:self.orderDetailsView.view];

    }

 }
    


-(void)loadOrderRecommendView;
{
    if (self.orderRecommendView) {
        self.orderRecommendView.view.hidden =NO;
    }
    else
    {
        self.orderRecommendView =[[orderRecommendView alloc]initWithNibName:@"orderRecommendView" bundle:nil parent:self];
        
        CGRect frame = self.orderRecommendView.view.frame;
        frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.orderRecommendView.view.frame = frame;
        
        [self.view addSubview:self.orderRecommendView.view];
    }
}

-(void)loadOrderRdDetailView
{

    if (self.tdfOrderRd) {
        self.tdfOrderRd.view.hidden =NO;
    }
    else
    {
        self.tdfOrderRd =[[TDFOrderRdDetailViewController alloc] initWithparent:self];
        [self.view addSubview:self.tdfOrderRd.view];
    }
    
}

-(void)loadOrderRemindView
{
    if (self.orderRemindView) {
        self.orderRemindView.view.hidden =NO;
    } else {
        self.orderRemindView =[[orderRemindView alloc]initWithNibName:@"orderRemindView" bundle:nil parent:self];
        
        [self.view addSubview:self.orderRemindView.view];
    }
}

- (void)loadSpecialTagEditView
{
    if (self.specialTagEditView) {
        self.specialTagEditView.view.hidden = NO;
    } else {
        self.specialTagEditView = [[SpecialTagEditView alloc] initWithNibName:@"SpecialTagEditView" bundle:nil parent:self moduleName:@"order"];
        [self.view addSubview:self.specialTagEditView.view];
    }
}

@end
