//
//  DiscountPlanEditView.h
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "IEditItemRadioEvent.h"
#import "IEditMultiListEvent.h"
#import "IEditItemListEvent.h"
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerClient.h"
#import "MultiCheckHandle.h"
#import "ItemTitle.h"
#import "ItemBase.h"

typedef void(^DiscountPlanEditViewCallBack)();
@class SettingModule,SettingService,MBProgressHUD;
@class EditItemList,EditMultiList,EditItemView,EditItemText,EditItemRadio,NavigateTitle2,FooterListView;
@class DiscountPlan;
@interface DiscountPlanEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditItemRadioEvent,IEditMultiListEvent,MultiCheckHandle,OptionPickerClient,UIActionSheetDelegate,DatePickerClient,FooterListEvent>{
    
//    SettingModule *parent;
    
    SettingService *service;
    
}

@property(nonatomic,copy)DiscountPlanEditViewCallBack callBack;
@property (nonatomic,strong) IBOutlet ItemTitle *baseTitle;
@property (nonatomic,strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemList *lsMode;
@property (nonatomic, strong) IBOutlet EditItemList *lsRadio;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsRadio;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsAllKind;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsMenu;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsKind;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsAllUser;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsUsers;
@property (nonatomic, strong) IBOutlet ItemTitle *titleValid;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsDate;
@property (nonatomic, strong) IBOutlet EditItemList *lsStartDate;
@property (nonatomic, strong) IBOutlet EditItemList *lsEndDate;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsTime;
@property (nonatomic, strong) IBOutlet EditItemList *lsStartTime;
@property (nonatomic, strong) IBOutlet EditItemList *lsEndTime;
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsWeek;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsWeek;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) DiscountPlan* discountPlan;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray* item1s;
@property (nonatomic, strong) NSMutableArray* discountDetailList;
@property (nonatomic, strong) NSMutableArray* menuRatioList;
@property (nonatomic, strong) NSMutableArray* kindRatioList;
@property (nonatomic, strong) NSMutableArray* discountDetailList1;
@property (nonatomic, strong) NSMutableArray* allDetailList;
@property (nonatomic, strong) NSMutableArray* allMenuDetailList;
@property (nonatomic, strong) NSMutableArray* userDiscountPlanVOList;
@property (nonatomic, strong) NSMutableArray* userVOList;
@property (nonatomic, strong) NSMutableArray* headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableArray* treeNodeTemps;
@property (nonatomic, strong) NSMutableArray* week;
@property (nonatomic, assign) int action;
@property (nonatomic, assign) BOOL changed;
@property (nonatomic, assign) BOOL date;
-(IBAction)btnDelClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loadData:(DiscountPlan*) kindPayTemp action:(int)action;

-(void) refreshMenu:(NSMutableArray*)arrs;

-(void) refreshKind:(NSMutableArray*)arrs;

@end
