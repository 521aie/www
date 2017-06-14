//
//  SpecialEditView.h
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ItemBase.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "MultiCheckHandle.h"
#import "TimePickerClient.h"
#import "DatePickerClient.h"
#import "OptionPickerClient.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"
@class KabawModule,KabawService,SettingService,NavigateTitle2,ItemEndNote,EditItemList,EditItemText,EditItemRadio,ItemTitle,EditMultiList;
@class Special,MBProgressHUD,FooterListView;
@interface SpecialEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditMultiListEvent,MultiCheckHandle,IEditItemRadioEvent,TimePickerClient,DatePickerClient,OptionPickerClient,UIActionSheetDelegate,FooterListEvent>
{
    KabawModule *parent;
    
    KabawService *service;
    
    SettingService* settingService;
    
//    MBProgressHUD *hud;
}

@property (nonatomic) BOOL changed;
@property (nonatomic, retain)  UIView *titleDiv;     //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) ItemTitle *baseTitle;
@property (nonatomic, strong)  EditItemText *txtName;

@property (nonatomic, strong)  ItemTitle *titleValid;
@property (nonatomic, strong)  EditItemRadio *rdoIsDate;
@property (nonatomic, strong)  EditItemList *lsStartDate;
@property (nonatomic, strong)  EditItemList *lsEndDate;

@property (nonatomic, strong)  EditItemRadio *rdoIsTime;
@property (nonatomic, strong)  EditItemList *lsStartTime;
@property (nonatomic, strong)  EditItemList *lsEndTime;

@property (nonatomic, strong)  EditItemRadio *rdoIsWeek;
@property (nonatomic, strong)  EditMultiList *mlsWeek;

@property (nonatomic, strong)  ItemTitle *titleSpecial;
@property (nonatomic, strong)  EditItemList *lsMode;
@property (nonatomic, strong)  EditItemList *lsRatio;
@property (nonatomic, strong)  EditItemRadio *rdoIsForce;
@property (nonatomic, strong)  EditItemList *lsPlan;
@property (nonatomic, strong)  UIButton *btnDel;
@property (nonatomic, copy) void(^callBack)(void);
@property (nonatomic) Special* selObj;
@property (nonatomic) NSMutableArray* plans;
@property (nonatomic) int action;

-(void) loadData:(Special*) tempVO action:(int)action;

@end
