//
//  SignerEditView.h
//  RestApp
//
//  Created by zxh on 14-7-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"

typedef void(^SignerEditViewCallBack) ();
@class SettingService;
@class EditItemList,EditItemView,EditItemText,EditItemRadio,NavigateTitle2,FooterListView;
@class KindPay,KindPayDetailOption;
@interface SignerEditView : TDFRootViewController<INavigateEvent,FooterListEvent>{
    SettingService *service;
}
@property (nonatomic,copy)SignerEditViewCallBack callBack;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemView *lblKind;
@property (nonatomic, weak) IBOutlet EditItemText *txtName;

@property (nonatomic) BOOL changed;
@property (nonatomic) KindPay* kindPay;
@property (nonatomic) KindPayDetailOption* option;
@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
