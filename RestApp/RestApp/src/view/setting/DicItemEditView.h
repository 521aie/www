//
//  DicItemEditView.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "SingleCheckHandle.h"
#import "DicItemConstants.h"
#import "TDFRootViewController.h"
typedef void(^DicItemEditViewCallBack) ();
@class SettingService;
@class EditItemText,EditItemList,NavigateTitle,NavigateTitle2,SingleCheckHandle;
@class DicItem;

@interface DicItemEditView : TDFRootViewController<INavigateEvent,UIActionSheetDelegate>{
    SettingService *service;
}
@property (nonatomic,copy)DicItemEditViewCallBack callBack;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *container;


@property (nonatomic, retain) IBOutlet EditItemText *txtName;
@property (nonatomic, retain) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) DicItem* dicItem;
@property (nonatomic) int action;

@property (nonatomic,strong) NSString* dicCode;
@property (nonatomic,strong) NSString* titleName;

-(IBAction)btnDelClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
