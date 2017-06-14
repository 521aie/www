//
//  FeePlanListView.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FeePlanListView.h"
#import "SettingModule.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "FeePlanEditView.h"
#import "TDFSettingService.h"
#import "FeePlan.h"
#import "HelpDialog.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "GridColHead.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"
@implementation FeePlanListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"附加费", nil);
    self.needHideOldNavigationBar = YES;
    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"feePlan" title:NSLocalizedString(@"附加费", nil) foots:nil];
    [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp|TDFFooterButtonTypeAdd];
}

//- (void) leftNavigationButtonAction:(id)sender
//{
//    if (isnavigatemenupush) {
//        isnavigatemenupush =NO;
//        [self.navigationController popViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
//        [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
//    }
//}

#pragma 数据加载
-(void)loadDatas
{
    
    [self  showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listFeePlanSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated: YES];
        NSArray *list = [data objectForKey:@"data"];
        self.datas=[JsonHelper transList:list objName:@"FeePlan"];
        [self.mainGrid reloadData];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];


}

-(void) footerAddButtonAction:(UIButton *)sender
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_FeePlanEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
         @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"feeplan"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    FeePlan* editObj=(FeePlan*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_FeePlanEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
         @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:REMOTE_FEEPLAN_LIST object:nil];
}

-(void) dataChange:(NSNotification*) notification{
    [self configNavigationBar:NO];
}


#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"附加费名称", nil) col2:NSLocalizedString(@"费用类型", nil)];
    [headItem initColLeft:15 col2:130];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
