//
//  ReserveBandEditView.h
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "DatePickerClient.h"
#import "SingleCheckHandle.h"
#import "IEditItemListEvent.h"
#import "TDFRootViewController.h"
@class KabawModule,KabawService,MBProgressHUD,ReserveBand;
@class EditItemList,EditItemText,EditItemList,NavigateTitle2,FooterListView;
@interface ReserveBandEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,DatePickerClient,UIActionSheetDelegate,FooterListEvent>
{
    KabawService *service;
}

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) void(^callBack)(void);
@property (nonatomic, strong) IBOutlet EditItemList *lsStartDate;
@property (nonatomic, strong) IBOutlet EditItemList *lsEndDate;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) ReserveBand* selObj;

@property (nonatomic) BOOL changed;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parent;

-(void) loadData:(ReserveBand*) tempVO action:(int)action;

-(IBAction)btnDelClick:(id)sender;

@end
