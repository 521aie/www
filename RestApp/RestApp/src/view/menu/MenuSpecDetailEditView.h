//
//  MenuSpecDetailEditView.h
//  RestApp
//
//  Created by zxh on 14-8-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NumberInputClient.h"
#import "IEditItemListEvent.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"

@class MenuModule,MenuService,NavigateTitle2,EditItemView,MBProgressHUD,FooterListView;
@class MenuSpecDetail,Menu;
@interface MenuSpecDetailEditView : TDFRootViewController<INavigateEvent,NumberInputClient,IEditItemListEvent,UIActionSheetDelegate,FooterListEvent>{
    MenuModule *parent;
    MenuService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemView *lblName;
@property (nonatomic, weak) IBOutlet EditItemView *lblRawScale;
@property (nonatomic, weak) IBOutlet EditItemView *lblPriceRatio;
@property (nonatomic, weak) IBOutlet EditItemView *lblDefaultPrice;
@property (nonatomic, weak) IBOutlet EditItemList *lsPrice;
@property (nonatomic, weak) IBOutlet UIButton *btnDel;

@property (nonatomic) BOOL changed;
@property (nonatomic) MenuSpecDetail* menuSpecDetail;
@property (nonatomic) Menu* menu;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary *sourceDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
-(void) loadData:(MenuSpecDetail*)objTemp menu:(Menu*)menu action:(int)action;
-(IBAction)btnDelClick:(id)sender;


@end
