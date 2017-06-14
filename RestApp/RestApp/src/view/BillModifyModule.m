//
//  BillModifyModule.m
//  RestApp
//
//  Created by 栀子花 on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BillModifyModule.h"
#import "SystemUtil.h"
#import "MainModule.h"
#import "XHAnimalUtil.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "SecondMenuView.h"
#import "NavigateTitle2.h"
#import "ActionConstants.h"
#import "handleModify.h"
#import "autoModify.h"
#import "TDFMediator+BillModifyModule.h"

@implementation BillModifyModule

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule=parent;
        service=[ServiceFactory Instance].billModifyService;
        hud=[[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModule];
//    [self loadDatas];
}

- (void) viewWillLayoutSubviews
{
    CGRect frame = self.secondMenuView.view.frame;
    frame.size.width = SCREEN_WIDTH;
    self.secondMenuView.view.frame = frame;
}

-(void) backMenu
{
    [mainModule backMenuBySelf:self];
}

-(void)backNavigateMenuView
{
    [mainModule backMenuBySelf:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}


#pragma mart module part.
-(void) initModule
{
    self.title = NSLocalizedString(@"账单优化", nil);
    self.secondMenuView = [[SecondMenuView alloc] initWithNibName:@"SecondMenuView" bundle:nil delegate:self];
     self.secondMenuView.titleBox.lblTitle.text=NSLocalizedString(@"账单优化", nil);
    [self.view addSubview:self.secondMenuView.view];
}
-(void)loadDatas{
    [self showView:BILLMOD_SECOND_VIEW];
}

-(void) showView:(int) viewTag
{
    if (viewTag ==BILLMOD_SECOND_VIEW) {
        self.secondMenuView.view.hidden = NO;
         self.secondMenuView.titleBox.lblTitle.text=NSLocalizedString(@"账单优化", nil);
         [XHAnimalUtil animal:self type:kCATransitionPush direct:kCATransitionFromRight];
    }else if (viewTag == BILLMOD_HANDLE_VIEW){
        UIViewController *handleView =[[TDFMediator sharedInstance]TDFMediator_handleModifyViewController];
        [self.rootController pushViewController:handleView animated:YES];
        return;
    }else if (viewTag == BILLMOD_AUTO_VIEW){
        UIViewController *autoView =[[TDFMediator sharedInstance]TDFMediator_autoModifyViewController];
        [self.rootController pushViewController:autoView animated:YES];
        return;
    }
}
-(void) onMenuSelectHandle:(UIMenuAction *)action
{
    if ([action.code isEqualToString:PAD_HANDLE_OPERATION]) {
            [self showView:BILLMOD_HANDLE_VIEW];
            [self.handleModify loadDatas];
    } else if ([action.code isEqualToString:PAD_AUTO_OPERATION]) {
            [self showView:BILLMOD_AUTO_VIEW];
            [self.autoModify loadData];
    }
}
//创建二级菜单
-(NSMutableArray *) createList
{
    NSMutableArray* menuItems=[NSMutableArray array];
    UIMenuAction *action=[[UIMenuAction alloc] init:NSLocalizedString(@"手工优化账单", nil) detail:NSLocalizedString(@"人工处理一段时间内的账单", nil) img:@"ico_nav_shoudong.png" code:PAD_HANDLE_OPERATION];
    [menuItems addObject:action];
    action=[[UIMenuAction alloc] init:NSLocalizedString(@"自动优化账单", nil) detail:NSLocalizedString(@"系统每天定时处理指定日的账单", nil) img:@"ico_nav_zidong.png" code:PAD_AUTO_OPERATION];
    [menuItems addObject:action];
    return menuItems;
}

#pragma mark - 加载module下的页面
/*加载主页面*/
- (void)loadSecondMenuView
{
    if (self.secondMenuView) {
        self.secondMenuView.view.hidden = NO;
    }else{
        self.secondMenuView = [[SecondMenuView alloc] initWithNibName:@"SecondMenuView" bundle:nil delegate:self];
        [self.view addSubview:self.secondMenuView.view];
    }
}
@end
