//
//  PantryEditView.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Pantry.h"
#import "AsyncSocket.h"
#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "SelectMenuHandle.h"
#import "MultiCheckHandle.h"
#import "SelectMenuClient.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "TDFRootViewController.h"
@class TransService,MenuService,MBProgressHUD,FooterListView;
@class EditItemText,EditItemList,EditItemRadio,EditMultiList,ItemTitle,NavigateTitle2,SingleCheckHandle,ZMTable;
@interface PantryEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,AsyncSocketDelegate,NumberInputClient,SelectMenuHandle,UIActionSheetDelegate,ISampleListEvent,MultiCheckHandle,IEditItemRadioEvent,SelectMenuClient>
{
    
    TransService *service;
    
    MenuService* menuService;

    AsyncSocket *clientSocket;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) EditItemList *txtType;
@property (nonatomic, strong) ItemTitle *baseTitle;
@property (nonatomic, strong) EditItemText *txtName;
@property (nonatomic, strong) EditItemList *lsWidth;
@property (nonatomic, strong) EditItemRadio *rdoIsCut;
@property (nonatomic, strong) EditItemList *lsIp;
@property (nonatomic, strong) EditItemList *lsCharCount;
@property (nonatomic, strong) EditItemList *lsPrintNum;

@property (nonatomic, strong) EditItemRadio *rdoIsTotalPrint;
@property (nonatomic, strong) EditItemRadio *rdoIsAllArea;

@property (nonatomic, strong) ItemTitle *titleKind;
@property (nonatomic, strong) ZMTable *kindGrid;

@property (nonatomic, strong) ItemTitle *titleMenu;
@property (nonatomic, strong) ZMTable *menuGrid;

@property (nonatomic, strong) ItemTitle *titleArea;
@property (nonatomic, strong) ZMTable *areaGrid;
@property (nonatomic, strong) UILabel *printHintLib;

@property (nonatomic, strong) UIView *testDiv;
@property (nonatomic, strong) UITextView *lblTip;
@property (nonatomic, strong) UIButton *btnDel;

@property (nonatomic, strong) Pantry* pantry;
@property (nonatomic, strong) NSMutableArray* datas;
@property (nonatomic, strong) NSMutableArray* kinds;
@property (nonatomic, strong) NSMutableArray* menus;

@property (nonatomic, strong) NSMutableArray* pantryPlanAreas;
@property (nonatomic, strong) NSMutableArray* areas;
@property (nonatomic, copy)void(^callBack)(void);
@property (nonatomic, strong) NSMutableArray* kindMenus;
@property (nonatomic, strong) NSString* continueEvent;

@property (nonatomic, assign) int action;
@property (nonatomic, assign) bool isContinue;
@property (nonatomic, assign) bool chainDataManageable;
@property (nonatomic, assign) NSInteger isAllArea;
@property (nonatomic, strong) NSMutableArray *PrintTypeArr;
@property (nonatomic, strong) NSString *plateEntityId;
- (void)loadData:(Pantry*) tempVO action:(int)action isContinue:(BOOL)isContinue;

- (IBAction)btnTest:(id)sender;

- (IBAction)btnDelClick:(id)sender;

- (void)initdata;

@end
