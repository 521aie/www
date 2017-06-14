//
//  ReserveSeatEditView.h
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "NumberInputClient.h"
#import "TDFRootViewController.h"

@class KabawModule,KabawService,MBProgressHUD;
@class EditItemList,EditItemText,EditItemList,NavigateTitle2;
@class ReserveSeat;
typedef void (^ReserveSeatEditViewCallBack) (void);
@interface ReserveSeatEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,NumberInputClient,UIActionSheetDelegate>{
//    KabawModule *parent;
    KabawService *service;
//    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic, copy)ReserveSeatEditViewCallBack callBack;
@property (nonatomic, weak) IBOutlet EditItemList *lsTime;
@property (nonatomic, weak) IBOutlet EditItemText *txtName;
@property (nonatomic, weak) IBOutlet EditItemText *txtNum;
@property (nonatomic, weak) IBOutlet EditItemText *txtLower;
@property (nonatomic, weak) IBOutlet EditItemText *txtMax;
@property (nonatomic, weak) IBOutlet EditItemList *lsMoney;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic,strong) NSMutableArray* times;

@property (nonatomic) BOOL changed;
@property (nonatomic,strong) ReserveSeat* selObj;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parent;

//- (void)loadTimeData:(NSMutableArray *)timedata;
//
//- (void)loadData:(ReserveSeat *) tempVO action:(int)action;

- (IBAction)btnDelClick:(id)sender;

@end
