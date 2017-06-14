//
//  ShopBaseView.h
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "TDFRootViewController.h"
@class NavigateTitle2,EditItemText,MBProgressHUD,SettingService,ShopDetail,ItemEndNote,FooterListView;

@interface ShopBaseView : TDFRootViewController<INavigateEvent,FooterListEvent>{
     SettingService *service;
}

@property (nonatomic) BOOL changed;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic, weak) IBOutlet EditItemText *txtShopName;
@property (nonatomic, weak) IBOutlet EditItemText *txtEmail;
@property (nonatomic, weak) IBOutlet EditItemText *txtLinker;
@property (nonatomic, weak) IBOutlet EditItemText *txtMobile;
@property (nonatomic, weak) IBOutlet UILabel *lblNote;
@property (nonatomic) ShopDetail* shopDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) loadData;
@end
