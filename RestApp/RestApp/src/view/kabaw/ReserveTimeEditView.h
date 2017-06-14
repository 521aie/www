//
//  ReserveTimeEditView.h
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "SingleCheckHandle.h"
#import "TimePickerClient.h"
#import "TDFRootViewController.h"
@class KabawModule,KabawService,MBProgressHUD;
@class EditItemList,EditItemText,EditItemList,NavigateTitle2;
@class ReserveTime;
typedef void(^ReserveTimeEditViewCallBack)(int kind);
@interface ReserveTimeEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,TimePickerClient,UIActionSheetDelegate>{
//    KabawModule *parent;
    KabawService *service;
//    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic, copy)ReserveTimeEditViewCallBack callBack;
@property (nonatomic, weak) IBOutlet EditItemList *lsBtime;
@property (nonatomic, weak) IBOutlet EditItemList *lsEtime;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) ReserveTime* selObj;
@property (nonatomic) int action;
@property (nonatomic) int kind;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;

//-(void) loadData:(ReserveTime*) tempVO kind:(int)kind action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
