//
//  SenderEditView.h
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"

@class KabawModule,KabawService,MBProgressHUD;
@class EditItemText,EditItemList,NavigateTitle2,SingleCheckHandle;
@class DeliveryMan;
typedef void(^SenderEditViewCallBack) (void);
@interface SenderEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,UIActionSheetDelegate>{
    KabawService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic,copy) SenderEditViewCallBack callBack;
@property (nonatomic, weak) IBOutlet EditItemList *lsSex;
@property (nonatomic, weak) IBOutlet EditItemText *txtName;
@property (nonatomic, weak) IBOutlet EditItemText *txtMobile;
@property (nonatomic, weak) IBOutlet EditItemText *txtIdCard;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) DeliveryMan* sender;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;

-(void) loadData:(DeliveryMan*) tempVO action:(int)action;
-(IBAction)btnDelClick:(id)sender;
@end
