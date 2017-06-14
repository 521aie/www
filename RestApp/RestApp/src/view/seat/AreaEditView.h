//
//  AreaEditView.h
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "TDFRootViewController.h"

typedef void(^AreaEditViewCallBack) ();

@class NavigateTitle2,EditItemText,FooterListView;
@class Area;
@interface AreaEditView : TDFRootViewController<INavigateEvent,FooterListEvent,UIActionSheetDelegate>

@property (nonatomic,copy)AreaEditViewCallBack callBack;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, assign) BOOL changed;
@property (nonatomic, assign) Area *area;
@property (nonatomic, assign) NSInteger action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
