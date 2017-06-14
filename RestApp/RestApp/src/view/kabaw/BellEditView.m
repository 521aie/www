//
//  BellEditView.m
//  RestApp
//
//  Created by zxh on 14-5-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVO.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "RemoteEvent.h"
#import "KabawModule.h"
#import "BellEditView.h"
#import "ConfigRender.h"
#import "RemoteResult.h"
#import "NavigateTitle.h"
#import "MBProgressHUD.h"
#import "EditItemRadio.h"
#import "NavigateTitle2.h"
#import "SettingService.h"
#import "FooterListView.h"
#import "ServiceFactory.h"
#import "ConfigConstants.h"
#import "TDFSettingService.h"
#import "NSString+Estimate.h"
#import "KindConfigConstants.h"

@implementation BellEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        service=[ServiceFactory Instance].settingService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
}

#pragma navigateBar
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"服务铃", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [parent showView:SECOND_MENU_VIEW];
    } else {
        [self save];
    }
} 

#pragma ui.
-(void) initMainView
{
    [self.rdoAddReview initLabel:NSLocalizedString(@"火小二加菜需要收银审核", nil) withHit:nil delegate:nil];
    [self.rdoUrgencyReview initLabel:NSLocalizedString(@"火小二催菜需要收银审核", nil) withHit:nil delegate:nil];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
     [[TDFSettingService new] listConfig:SYS_CONFIG sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         [hud  hideAnimated:YES];
         NSArray *list = [data objectForKey:@"data"];
         NSMutableArray *configVOList=[JsonHelper transList:list objName:@"ConfigVO"];
         [self fillModel:configVOList];
         [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
     } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         [hud  hideAnimated:YES];
         [AlertBox show:error.localizedDescription];
     }];
}

#pragma ui-data-bind
-(void)fillModel:(NSMutableArray *)configVOList
{
    NSMutableDictionary* map=[ConfigRender transDic:configVOList];
    self.isAddReviewConfig=[ConfigRender fillConfig:IS_ADD_REVIEW withControler:self.rdoAddReview withMap:map];
    self.isUrgencyReviewConfig=[ConfigRender fillConfig:IS_URGENCY_REVIEW withControler:self.rdoUrgencyReview withMap:map];
}

#pragma save-data
-(BOOL)isValid
{
    return YES;
}

-(NSMutableArray*) transMode
{
    NSMutableArray *idList = [NSMutableArray array];
    if (self.isAddReviewConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isAddReviewConfig._id,[self.rdoAddReview getStrVal]]];
    }
    
    if (self.isUrgencyReviewConfig) {
        [idList addObject:[NSString stringWithFormat:@"%@|%@", self.isUrgencyReviewConfig._id,[self.rdoUrgencyReview getStrVal]]];
    }
    
    return idList;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    NSMutableArray* ids=[self transMode];
    if ([ids count]==0) {
        [UIHelper ToastNotification:NSLocalizedString(@"没有配置项可以设置", nil) andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }

   [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD:hud];
    [[TDFSettingService new] saveConfig:ids sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [hud  hide: YES];
        [UIHelper ToastNotification:NSLocalizedString(@"设置成功!", nil) andView:self.view andLoading:NO andIsBottom:NO];
        [UIHelper clearChange:self.container];
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}

#pragma test event
#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_BellEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_BellEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

-(void)loadFinsh:(RemoteResult*) result
{
    [hud hide:YES];
       if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSArray *list = [map objectForKey:@"configs"];
    NSMutableArray *configVOList=[JsonHelper transList:list objName:@"ConfigVO"];
    [self fillModel:configVOList];
    
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [hud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [UIHelper ToastNotification:NSLocalizedString(@"设置成功!", nil) andView:self.view andLoading:NO andIsBottom:NO];
    [UIHelper clearChange:self.container];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
}

-(void) showHelpEvent
{
    [HelpDialog show:@"bell"];
}

@end
