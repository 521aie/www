//
//  AreaEditView.m
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AreaEditView.h"

#import "ServiceFactory.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "Area.h"
#import "XHAnimalUtil.h"
#import "RemoteEvent.h"
#import "SeatListView.h"
#import "NSString+Estimate.h"
#import "RemoteResult.h"
#import "AreaListView.h"
#import "AlertBox.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFSeatService.h"
#import "UIViewController+HUD.h"

@implementation AreaEditView

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
    
    self.changed=NO;
    self.needHideOldNavigationBar = YES;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData:self.area action:self.action];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"区域", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"区域名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma remote
-(void) loadData:(Area *)areaTemp action:(NSInteger)action
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加区域", nil);
        [self clearDo];
    } else {
        self.title=self.area.name;
        [self fillModel];
    }
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtName initData:nil];
}

- (void)fillModel
{
    [self.txtName initData:self.area.name];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_AreaEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_AreaEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
        return;
    }
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

-(void) delFinish:(NSError*)error
{
    [self.progressHud hide:YES];
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)remoteFinsh:(NSError *)error obj:(id)obj
{
    [self.progressHud hide:YES];
    if (error) {
        
        [self showErrorMessage:[error localizedDescription]];
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"区域名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

- (Area *)transMode
{
    Area* areaUpdate=[Area new];
    areaUpdate.name=[self.txtName getStrVal];
    return areaUpdate;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    Area *areaTemp = [self transMode];
    NSString *tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@区域", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        //         [service saveArea:areaTemp Target:self Callback:@selector(remoteFinsh:)];
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] saveAreaWithName:areaTemp.name sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself remoteFinsh:nil obj:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself remoteFinsh:error obj:nil];
        }];
    } else {
        areaTemp._id=self.area._id;
        //        [service updateArea:areaTemp Target:self Callback:@selector(remoteFinsh:)];
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] updateAreaWithParam:@{
                                                             @"area_id": areaTemp._id,
                                                             @"area_name": areaTemp.name,
                                                             @"sort_code": [NSString stringWithFormat:@"%zd", areaTemp.sortCode],
                                                             @"last_ver": [NSString stringWithFormat:@"%zd", areaTemp.lastVer]
                                                             }
                                                    sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                                                        [wself remoteFinsh:nil obj:data];
                                                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                        [wself remoteFinsh:error obj:nil];
                                                    }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.area.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.area.name]];
        //        [service removeArea:self.area._id Target:self Callback:@selector(delFinish:)];
        
        __weak __typeof(self) wself = self;
        [[[TDFSeatService alloc] init] removeAreaWithIds:@[ self.area._id ] sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            
            [wself delFinish:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [wself delFinish:error];
        }];
    }
}

-(void) showHelpEvent
{
    [HelpDialog show:@"seatarea"];
}

@end
