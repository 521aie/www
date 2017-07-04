//
//  AreaListView.m
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "RemoteEvent.h"
#import "AreaListView.h"
#import "AreaEditView.h"
#import "XHAnimalUtil.h"
#import "SeatListView.h"
#import "RemoteResult.h"
#import "TableEditView.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "TDFSeatService.h"
#import "UIViewController+HUD.h"
#import "TDFMediator+SeatModule.h"
#import "TDFMediator+SettingModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation AreaListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.needHideOldNavigationBar = YES;
    [self initNotification];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add",@"del",@"sort", nil];
    [self initDelegate:self event:@"area" title:NSLocalizedString(@"区域", nil) foots:arr];

    self.footView.hidden = YES;
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd | TDFFooterButtonTypeSort | TDFFooterButtonTypeHelp];

    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"关闭", nil)];
    [self loadAreas];
    self.title = NSLocalizedString(@"区域", nil);
}

#pragma 消息处理部分.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:SeatModule_Data_Change object:nil];
}

- (void) leftNavigationButtonAction:(id)sender
{
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 数据加载
- (void)loadAreas
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    __weak __typeof(self)wself = self;
    [[[TDFSeatService alloc] init] areasWithSaleOutFlag:@"false" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [wself.progressHud setHidden:YES];
        [wself loadFinishError:nil obj:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [wself.progressHud setHidden:YES];
        [wself loadFinishError:error obj:nil];
    }];
}

//#pragma 实现协议 ISampleListEvent
- (void)closeListEvent:(NSString*)event
{
    if ([event isEqualToString:@"sort"]) {
    }
}

- (void)footerAddButtonAction:(UIButton *)sender {
    [self showAddEvent:nil];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"seatarea"];
}

- (void)footerSortButtonAction:(UIButton *)sender {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"sort"  action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:[self.datas mutableCopy] error:nil needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showAddEvent:(NSString*)event
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_AreaEditViewWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadAreas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    if ([ObjectUtil isEmpty:self.datas] || self.datas.count<2) {
        [AlertBox show:NSLocalizedString(@"请至少添加两条内容,才能进行排序.", nil)];
        return;
    }
    if ([event isEqualToString:@"sortinit"]) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TableEditView:self event:@"sort"  action:ACTION_CONSTANTS_SORT title:NSLocalizedString(@"排序", nil) dataTemps:[self.datas mutableCopy] error:nil needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {

        [UIHelper showHUD:NSLocalizedString(@"正在排序", nil) andView:self.view andHUD:self.progressHud];
        //        [service sortAreas:ids Target:self Callback:@selector(sortFinish:)];
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] sortAreaWithIds:ids sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself sortFinish:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself sortFinish:error];
        }];
    }
}

//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    Area *editObj=(Area*)obj;
    TDFMediator *mediator = [[TDFMediator alloc] init];
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_AreaEditViewWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadAreas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dataChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.datas=[dic objectForKey:@"head_list"];
    [self.mainGrid reloadData];
}

- (void)loadFinishError:(NSError *)error obj:(id)obj
{
    [self.progressHud hide:YES];
    
    if (error) {
        [AlertBox show:[error localizedDescription]];
        return;
    }
    
    self.areaList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    self.datas = self.areaList;
    [self.mainGrid reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:SeatModule_Area_Change object:self.areaList] ;
}

- (void)sortFinish:(NSError *)error
{
    [self.progressHud hide:YES];
    
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    [self loadAreas];
    [[NSNotificationCenter defaultCenter] postNotificationName:SeatModule_Area_Change object:self.areaList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TDFSeatChanged" object:nil];
}

- (void)remoteLoadData:(NSString *) responseStr
{
    NSDictionary *map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"areas"];
    self.areaList=[JsonHelper transList:list objName:@"Area"];
    self.datas=self.areaList;
    [self.mainGrid reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:SeatModule_Area_Change object:self.areaList] ;
}

- (void)showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"seatarea"];
}

@end
