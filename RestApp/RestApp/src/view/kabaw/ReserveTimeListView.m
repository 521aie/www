//
//  ReserveTimeListView.m
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMediator+KabawModule.h"
#import "ReserveTimeListView.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "RemoteEvent.h"
#import "ReserveTime.h"
#import "KabawModule.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ReserveTimeListView
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    self.title = NSLocalizedString(@"可预订时段", nil);

    [self initDelegate:self event:@"reservetime" title:NSLocalizedString(@"可预订时段", nil) foots:nil];
    self.kind = [self.params[@"kind"] intValue];
    self.datas = self.params[@"data"];
    [self loadTimeDatas:self.datas kind:self.kind];
    [self.footView showHelp:NO];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd | TDFFooterButtonTypeHelp];
}

#pragma 数据加载
-(void)loadDatas:(int)kind
{
    self.kind=kind;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[ServiceFactory Instance].kabawService listReserveTimeTarget:self Callback:@selector(loadFinish:) kind:[NSString stringWithFormat:@"%d",kind]];
}

-(void)loadTimeDatas:(NSMutableArray*)datas kind:(int)kind
{
    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    
}

-(void) footerAddButtonAction:(UIButton *)sender
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveTimeEditViewControllerWithData:nil kind:self.kind action:ACTION_CONSTANTS_ADD CallBack:^(int kind) {
        [self loadDatas:kind];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeReserveTimes:ids kind:self.kind event:REMOTE_RESERVETIME_DEL];
    [[ServiceFactory Instance].kabawService removeReserveTimes:ids kind:self.kind Target:self Callback:@selector(delFinish:)];
}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
//    [service removeReserveTimes:ids kind:self.kind event:REMOTE_RESERVETIME_DELALL];
      [[ServiceFactory Instance].kabawService removeReserveTimes:ids kind:self.kind Target:self Callback:@selector(delBatchFinish:)];
}

-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    ReserveTime* editObj=(ReserveTime*)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveTimeEditViewControllerWithData:editObj kind:self.kind action:ACTION_CONSTANTS_EDIT CallBack:^(int kind) {
        [self loadDatas:kind];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
   
}

-(void) loadFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
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

-(void) delBatchFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
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

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];
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
    NSArray *list = [map objectForKey:@"reserveTimes2"];
    self.datas=[JsonHelper transList:list objName:@"ReserveTime"];
    [self reload:self.datas error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_RESERVETIME_REFRESH object:self.datas] ;
}

@end
