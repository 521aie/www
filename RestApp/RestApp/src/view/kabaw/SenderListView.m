//
//  SenderListView.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SenderListView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "XHAnimalUtil.h"
#import "SenderEditView.h"
#import "ReserveSeat.h"
#import "HelpDialog.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFMediator+KabawModule.h"
#import "DeliveryMan.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SenderListView

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
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"sender" title:NSLocalizedString(@"送货人", nil) foots:nil];
    self.title = NSLocalizedString(@"送货人", nil);
    self.datas = self.params[@"data"];
    [self loadDatas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd | TDFFooterButtonTypeHelp];
}

#pragma 数据加载
-(void)loadDatas
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [[ServiceFactory Instance].kabawService listSenderTarget:self Callback:@selector(loadFinish:)];
}

-(void)loadSenderDatas:(NSMutableArray*)datas
{
    
    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController=[[TDFMediator sharedInstance]TDFMediator_senderEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController  pushViewController:viewController animated:YES];
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
    DeliveryMan* editObj=(DeliveryMan *)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance]TDFMediator_senderEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
}

-(void) loadFinish:(RemoteResult*) result{
    
    
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

-(void) delFinish:(RemoteResult*) result{
    
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
    self.datas=[JsonHelper transList:list objName:@"DeliveryMan"];
    [self reload:self.datas error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_SENDER_REFRESH object:self.datas] ;
}

@end
