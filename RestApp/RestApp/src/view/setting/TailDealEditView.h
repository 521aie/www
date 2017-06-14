//
//  TailDealEditView.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "SingleCheckHandle.h"

@class SettingService,MBProgressHUD;
@class EditItemText,EditItemList,NavigateTitle,NavigateTitle2,SingleCheckHandle;
@class TailDeal;

@interface TailDealEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    SettingService *service;
}

@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NavigateTitle2* titleBox;

@property (nonatomic, weak) IBOutlet EditItemText *txtVal;
@property (nonatomic, weak) IBOutlet EditItemText *txtDealVal;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) TailDeal* tailDeal;
@property (nonatomic) int action;

-(IBAction)btnDelClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) loadData:(TailDeal*) tailDealTemp action:(int)action;

@end
