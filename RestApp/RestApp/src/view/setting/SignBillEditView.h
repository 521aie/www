//
//  SignBillEditView.h
//  RestApp
//
//  Created by zxh on 14-4-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController.h"

typedef void(^SignBillEditViewCallBack) ();
@class KindPayDetailOption,KindPay,KindPayDetail;
@class SettingService,FooterListView;
@class EditItemText,NavigateTitle2,ItemTitle,EditItemView,EditItemRadio;
@interface SignBillEditView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,INavigateEvent,ISampleListEvent,FooterListEvent>
{
    SettingService *service;
}

@property (nonatomic,copy)SignBillEditViewCallBack callBack;
@property (nonatomic, strong) UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;


@property (nonatomic, strong) ItemTitle *baseTitle;
@property (nonatomic, strong) EditItemView *lblType;
@property (nonatomic, strong) EditItemText *txtName;
@property (nonatomic, strong) EditItemRadio *rdoIsInclude;
@property (nonatomic, strong) UIButton *btnDel;

@property (nonatomic, strong) ItemTitle *titleSigner;
@property (nonatomic, strong) UITableView* mainGrid;

@property (nonatomic, strong) KindPayDetailOption* delOption;
@property (nonatomic, strong) KindPay* kindPay;
@property (nonatomic, strong) NSMutableArray* optionList;
@property (nonatomic, strong) NSString* continueEvent;
@property (nonatomic) NSInteger action;
@property (nonatomic) bool isContinue;

- (IBAction)btnDelClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
