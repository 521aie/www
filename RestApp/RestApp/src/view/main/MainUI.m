//
//  MainUI.m
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainUI.h"
#import "TDFOtherMenuViewController.h"
#import "SystemUtil.h"
#import "MainModule.h"
#import "NavigateMenu.h"
#import "AppController.h"
#import "BackgroundHelper.h"
#import "XHMenuController.h"
#import "TDFRightMenuController.h"

@implementation MainUI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(AppController *)appControllerTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appController = appControllerTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainModule];
    [self initNotification];
}

- (void)initMainModule
{
    self.mainModule = [[MainModule alloc] initWithNibName:@"MainModule"bundle:nil];
    self.menuController = [[XHMenuController alloc] initWithRootViewController:self.mainModule];
    
    self.navigateMenu = [[NavigateMenu alloc] initWithNibName:@"NavigateMenu" bundle:nil parent:self.mainModule];
    self.menuController.leftController = self.navigateMenu;
    
    self.otherMenu = [[TDFRightMenuController alloc] init];
    self.menuController.rightController = self.otherMenu;
    
    [self.view addSubview:self.menuController.view];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainShow:) name:UI_MAIN_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherShow:) name:UI_OTHER_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherHidden:) name:UI_OTHER_HIDDEN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateShow:) name:UI_NAVIGATE_SHOW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateHidden:) name:UI_NAVIGATE_HIDDEN_NOTIFICATION object:nil];
}

- (void)mainShow:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)otherHidden:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)otherShow:(NSNotification *) notification
{
    [self.menuController showRightController];
}

- (void)navigateHidden:(NSNotification *) notification
{
    [self.menuController showRootController];
}

- (void)navigateShow:(NSNotification *) notification
{
    [self.menuController showLeftController];
}

@end
