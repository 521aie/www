//
//  TakeOutTimeListView.m
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TakeOutTimeListView.h"
#import "TDFMediator+KabawModule.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "TakeOutTimeEditView.h"
#import "ReserveTime.h"
#import "UIHelper.h"
#import "HelpDialog.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TakeOutTimeListView

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    self.title = NSLocalizedString(@"可送外卖时段", nil);
   
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"takeouttime" title:NSLocalizedString(@"可送外卖时段", nil) foots:nil];
    self.datas = self.params[@"data"];
//     [self loadTimeDatas:self.datas];
     [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

#pragma 数据加载
-(void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [[ServiceFactory Instance].kabawService listTakeOutTimeListTarget:self CallBack:@selector(loadFinish:)];
}

-(void)loadTimeDatas:(NSMutableArray*)datas
{

    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
}

-(void)footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_takeOutTimeEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^(){
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"outsale"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    ReserveTime* editObj=(ReserveTime*)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_takeOutTimeEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^(){
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
   
}

-(void) loadFinish:(RemoteResult*) result{
    
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) delBatchFinish:(RemoteResult*) result{
    
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [self finishSort];
        return;
    }
    
    [self remoteLoadData:result.content];
    [self finishSort];
}

-(void) delFinish:(RemoteResult*)result{
  
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [self hideHud];
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"data"];
    self.datas=[JsonHelper transList:list objName:@"ReserveTime"];
    [self reload:self.datas error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_TAKEOUTTIME_REFRESH object:self.datas] ;
}

@end
