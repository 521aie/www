//
//  UnitEditView.h
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameItemVO.h"
#import "EditItemText.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NavigateTitle.h"
#import "FooterListView.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "TDFRootViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "NavigationToJump.h"

@class MenuModule;
@interface UnitEditView : TDFRootViewController<INavigateEvent,FooterListEvent>
{
    MenuModule *parent;
    
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
@property (nonatomic, assign) BOOL changed;
@property (nonatomic, strong) NameItemVO* unit;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, assign)  id <NavigationToJump> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parent;

- (void)loadData:(NameItemVO *)objTemp action:(NSInteger)action;

@end
