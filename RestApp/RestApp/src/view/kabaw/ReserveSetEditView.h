//
//  ResertSetEditView.h
//  RestApp
//
//  Created by zxh on 14-5-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReserveSet.h"
#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "IEditMultiListEvent.h"
#import "IEditItemRadioEvent.h"
#import "NumberInputClient.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"

@class NavigateTitle2,EditItemList,EditItemText,EditItemRadio,EditMultiList;
@class KabawModule,KabawService,MBProgressHUD;
@interface ReserveSetEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,NumberInputClient,IEditMultiListEvent,IEditItemRadioEvent,OptionPickerClient>
{
    KabawService *service;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsReserve;
@property (nonatomic, weak) IBOutlet EditItemList *lsFee;
@property (nonatomic, weak) IBOutlet EditItemText *txtReserveDay;
@property (nonatomic, weak) IBOutlet EditItemList *lsMode;
@property (nonatomic, weak) IBOutlet EditItemText *txtAdvanceDay;
@property (nonatomic, strong) EditItemRadio *rdoIsAdult;
@property (nonatomic, strong) EditMultiList *mlsTime;
@property (nonatomic, strong) EditMultiList *mlsSeat;
@property (nonatomic, strong) EditMultiList *mlsSpecial;
@property (nonatomic, strong) EditMultiList *mlsBand;

@property (nonatomic) BOOL changed;
@property (nonatomic) ReserveSet* reserveSet;
@property (nonatomic) NSMutableArray* times;
@property (nonatomic) NSMutableArray* seats;
@property (nonatomic) NSMutableArray* specails;
@property (nonatomic) NSMutableArray* bands;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;

//-(void) loadDatas;

@end
