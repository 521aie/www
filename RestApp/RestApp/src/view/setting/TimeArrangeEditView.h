//
//  TimeArrangeEditView.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "TimePickerClient.h"
#import "SingleCheckHandle.h"
#import "IEditItemListEvent.h"
#import "TDFRootViewController.h"
@class TimeArrangeVO,FooterListView;
@class SettingService,MBProgressHUD;
@class EditItemList,EditItemText,EditItemList,NavigateTitle2;
typedef void(^TimeArrangeEditViewCallBack) ();
@interface TimeArrangeEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,TimePickerClient,UIActionSheetDelegate,FooterListEvent>
{
    SettingService *service;
}

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic,copy)TimeArrangeEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemList *lsBtime;
@property (nonatomic, strong) IBOutlet EditItemList *lsEtime;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) TimeArrangeVO* timeArrangeVO;
@property (nonatomic) BOOL changed;
@property (nonatomic) NSInteger action;

- (IBAction)btnDelClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)loadData:(TimeArrangeVO*) tempVO action:(int)action;

@end
