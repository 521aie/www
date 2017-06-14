//
//  SignBillDetailEditView.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPay.h"
#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "EditItemView.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "INavigateEvent.h"
#import "SettingService.h"
#import "FooterListEvent.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "KindPayDetailOption.h"
#import "TDFRootViewController.h"

typedef void(^SignBillDetailEditViewCallBack) ();

@interface SignBillDetailEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,UIActionSheetDelegate,FooterListEvent>
{
    SettingService *service;
}
@property (nonatomic,copy)SignBillDetailEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemList *lsKind;
@property (nonatomic, strong) IBOutlet EditItemView *lblKind;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) KindPay* kindPay;
@property (nonatomic, strong) KindPayDetailOption* option;
@property (nonatomic, strong) NSMutableArray* details;

@property (nonatomic) BOOL changed;
@property (nonatomic) NSInteger action;

- (IBAction)btnDelClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
