//
//  LinkManEditView.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"

@class LinkMan,FooterListView;
@class SettingModule,SettingService,MBProgressHUD;
@class EditItemText,EditItemList,NavigateTitle2,SingleCheckHandle;
@interface LinkManEditView : UIViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,UIActionSheetDelegate,FooterListEvent>
{
    SettingModule *parent;
    
    SettingService *service;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet EditItemText *txtMobile;
@property (nonatomic, strong) IBOutlet EditItemList *lsReceiveTime;
@property (nonatomic, strong) IBOutlet EditItemList *lsDateKind;
@property (nonatomic, strong) IBOutlet EditItemList *lsSmsKind;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) LinkMan* linkMan;

@property (nonatomic) NSInteger action;
@property (nonatomic) BOOL changed;

- (IBAction)btnDelClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)_parent;

- (void)loadData:(LinkMan*) tempVO action:(NSInteger)action;


@end
