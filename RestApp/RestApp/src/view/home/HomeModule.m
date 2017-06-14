//
//  HomeModule.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeView.h"
#import "EntryView.h"
#import "HomeModule.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"

static HomeModule *instance;

@implementation HomeModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
        instance = self;
    }
    return self;
}


- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

+ (HomeModule *)sharedInstance
{
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainModule];
}

- (void)initMainModule
{
    self.homeView = [[HomeView alloc] initWithNibName:@"HomeView5" bundle:nil parent:self];
    self.entryView = [[EntryView alloc] init];
  
    [self.view addSubview:self.homeView.view];
    [self.homeView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.entryView.view];
}

- (void)initHomeDataView
{
    [self.homeView loadBusiness];
}

- (void)initEntryDataView
{
    [self.entryView loadShopData];
}

- (void)showDetailView
{
    
}

- (void)showChainDetailView
{

}

- (void)showHomeView
{
    [self hideView];
    self.entryView.view.hidden = YES;
    self.homeView.view.hidden = NO;
}

- (void)showEntryView
{
    [self hideView];
    self.homeView.view.hidden = YES;
    self.entryView.view.hidden = NO;
}

- (void)showPrintBillView
{
    
}

- (void)showOrderDetail
{
    
}

- (void)showBranchBusinessDayDetail
{
    
}

- (void)showOrderList
{
    
}

- (void)selectModule:(UIMenuAction *)menu;
{
    [mainModule onMenuSelectHandle:menu];
} 

- (void)forwardToModule:(NSString *)code
{
    [mainModule forwardToModule:code];
}

- (void)hideView
{
    for (UIView *view in [self.view subviews]) {
        [view setHidden:YES];
    }
}

@end
