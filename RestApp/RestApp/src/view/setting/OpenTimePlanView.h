//
//  OpenTimePlanView.h
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "PairPickerClient.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"
@class SettingService,MBProgressHUD,NavigateTitle2,OpenTimePlan;
@class EditItemList,ItemEndNote,FooterListView;
@interface OpenTimePlanView : TDFRootViewController<INavigateEvent,IEditItemListEvent,PairPickerClient,FooterListEvent>{
    SettingService *service;
}

@property (nonatomic) BOOL changed;
@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;



@property (nonatomic, weak) IBOutlet EditItemList *lsEndType;
@property (nonatomic, weak) IBOutlet UILabel *lblNote;

@property (nonatomic) OpenTimePlan* openTimePlan;
@property (nonatomic) NSMutableDictionary* dic;
@property (nonatomic) NSArray* keys;
@property (nonatomic) NSArray* timesToday;
@property (nonatomic) NSArray* timesTomorrow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) loadData;
@end
