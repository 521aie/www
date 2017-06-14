//
//  SpecialListView.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+KabawModule.h"
#import "SpecialListView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "RemoteEvent.h"
#import "SpecialEditView.h"
#import "ReserveSeat.h"
#import "HelpDialog.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "TDFRootViewController+FooterButton.h"
@implementation SpecialListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotification];
    [self.footView removeFromSuperview];
    [self initDelegate:self event:@"special" title:@"" foots:nil];
    self.title = NSLocalizedString(@"优惠方案", nil);
    self.datas=self.params[@"data"];
    [self loadSpecialDatas:self.datas];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAdd | TDFFooterButtonTypeHelp];
}

#pragma 数据加载
-(void)loadDatas
{
//    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [service listSpecial:REMOTE_SPECIAL_LIST];
      [[ServiceFactory Instance].kabawService listSpecialTarget:self Callback:@selector(loadFinish:)];
}

-(void)loadSpecialDatas:(NSMutableArray*)datas
{
    [self.mainGrid reloadData];
}

#pragma 实现协议 ISampleListEvent
-(void) closeListEvent:(NSString*)event
{
    
}


-(void) footerAddButtonAction:(UIButton *)sender
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_specialEditViewControllerWithData:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delEvent:(NSString*)event ids:(NSMutableArray*) ids
{
//    [service removeSpecials:ids event:REMOTE_SPECIAL_DEL];
      [[ServiceFactory Instance].kabawService removeSpecials:ids Target:self Callback:@selector(delFinish:)];
}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
//    [service removeSpecials:ids event:REMOTE_SPECIAL_DELALL];
    [[ServiceFactory Instance].kabawService removeSpecials:ids Target:self Callback:@selector(delBatchFinish:)];

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
    Special* editObj=(Special*)obj;
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_specialEditViewControllerWithData:editObj action:ACTION_CONSTANTS_EDIT CallBack:^{
        @strongify(self);
        [self loadDatas];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma 消息处理部分.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:REMOTE_SPECIAL_LIST object:nil];
}

-(void) dataChange:(NSNotification*) notification
{
    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];
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

-(void) delFinish:(RemoteResult*)result
{
   [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [self.progressHud hide:YES];
        [AlertBox show:result.errorStr];
        return;
    }
    [self remoteLoadData:result.content];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"specials"];
    self.datas=[JsonHelper transList:list objName:@"Special"];
    [self reload:self.datas error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_SPECIAL_REFRESH object:self.datas] ;
}

@end
