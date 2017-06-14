//
//  SpecEditView.h
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "TDFMenuService.h"
#import "TDFRootViewController.h"
#import "NavigationToJump.h"
#import <libextobjc/EXTScope.h>

@class MenuModule,MenuService,NavigateTitle2,EditItemText,ItemTitle,MBProgressHUD,FooterListView;
@class SpecDetail;
@interface SpecEditView : TDFRootViewController<INavigateEvent,NumberInputClient,IEditItemListEvent,FooterListEvent,UIActionSheetDelegate>{
    MenuModule *parent;
    MenuService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;


@property (nonatomic, weak) IBOutlet EditItemText *txtName;
@property (nonatomic, weak) IBOutlet EditItemList *lsRawScale;
@property (nonatomic, weak) IBOutlet EditItemList *lsSpecPrice;

@property (nonatomic, weak) IBOutlet UILabel* lblTip;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) SpecDetail* specDetail;
@property (nonatomic) int action;
@property (nonatomic) int isAdjust;
@property (nonatomic ,strong) NSDictionary *sourceDic;
@property (nonatomic ,assign) id <NavigationToJump> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
-(void) loadData:(SpecDetail*) objTemp action:(int)action;
-(IBAction)btnDelClick:(id)sender;

@end
