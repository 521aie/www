//
//  BillModifyModule.h
//  RestApp
//
//  Created by 栀子花 on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSelectHandle.h"
#import "TDFRootViewController.h"

@class MainModule,BillModifyService, MBProgressHUD;
@class SecondMenuView;
@class handleModify,autoModify;



@interface BillModifyModule :TDFRootViewController <MenuSelectHandle>
{
    MainModule *mainModule;
    BillModifyService *service;
    MBProgressHUD *hud;
}

@property (nonatomic, strong)SecondMenuView *secondMenuView;
@property (nonatomic, strong)handleModify *handleModify;
@property (nonnull, strong)autoModify *autoModify;
@property (nonatomic,strong) UINavigationController *rootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;

- (void)backMenu;
- (void)backNavigateMenuView;

- (void)showView:(int) viewTag;
//-(void)loadDatas;

@end
