//
//  TakeOutTimeEditViewTableViewController.h
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "SingleCheckHandle.h"
#import "TimePickerClient.h"
#import "NumberInputClient.h"
#import "TDFRootViewController.h"
@class KabawModule,MBProgressHUD;
@class EditItemList,EditItemText,EditItemList,EditItemRadio,NavigateTitle2;
@class KabawService,TDFTakeOutTime;
typedef void(^TakeOutTimeEditViewCallBack)(void);
@interface TakeOutTimeEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,TimePickerClient,IEditItemRadioEvent,UIActionSheetDelegate>{
    KabawService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic,copy)TakeOutTimeEditViewCallBack callBack;
@property (nonatomic, weak) IBOutlet EditItemList *lsBtime;
@property (nonatomic, weak) IBOutlet EditItemList *lsEtime;
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoLimit;
@property (nonatomic, weak) IBOutlet EditItemText *txtNum;
@property (nonatomic, strong)  UILabel *lblHelp;
@property (nonatomic, strong)  UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) TDFTakeOutTime* selObj;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;

-(void) loadData:(TDFTakeOutTime*) tempVO action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
