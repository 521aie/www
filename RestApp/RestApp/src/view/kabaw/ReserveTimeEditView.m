//
//  ReserveTimeEditView.m
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReserveTimeEditView.h"
#import "KabawService.h"
#import "MBProgressHUD.h"
#import "KabawModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "KabawModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "UIViewController+Picker.h"

@implementation ReserveTimeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        parent=_parent;
        service=[ServiceFactory Instance].kabawService;
//        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    [self initNavigate];
    [self initMainView];
    [self loadData:self.selObj kind:self.kind action:self.action];
    [self initNotifaction];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"可预订时段", nil);
//    [self.titleBox editTitle:NO act:self.action];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}
- (void)initMainView
{
    [self.lsBtime initLabel:NSLocalizedString(@"开始时间", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsEtime initLabel:NSLocalizedString(@"结束时间", nil) withHit:nil isrequest:YES delegate:self];
    
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
    
    self.lsBtime.tag=1;
    self.lsEtime.tag=2;
}

#pragma remote
-(void) loadData:(ReserveTime*) tempVO kind:(int)kind action:(int)action
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        [self clearDo];
    }else{
        [self fillModel];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    [self.lsBtime initData:nil withVal:nil];
    [self.lsEtime initData:nil withVal:nil];
    self.lsBtime.lblVal.textColor = [UIColor redColor];
    self.lsEtime.lblVal.textColor = [UIColor redColor];
}

-(void) fillModel
{
    [self.lsBtime initData:[self.selObj getBtimeStr] withVal:[NSString stringWithFormat:@"%d",self.selObj.beginTime]];
    [self.lsEtime initData:[self.selObj getEtimeStr] withVal:[NSString stringWithFormat:@"%d",self.selObj.endTime]];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ReserveTimeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ReserveTimeEditView_Change object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_RESERVETIME_DELONE object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) delFinish:(RemoteResult*)result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.callBack) {
        self.callBack(self.kind);
    }
}

-(void)remoteFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.callBack) {
        self.callBack(self.kind);
    }
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    NSDate* date=[NSDate date];
    if (obj.tag==1) {
//        if ([NSString isNotBlank:self.lsBtime.currentVal]) {
//            date=[DateUtils parseTodayTime:self.lsBtime.currentVal.intValue];
//        }
//        [TimePickerBox show:NSLocalizedString(@"开始时间", nil) date:date client:self event:obj.tag];
        [self showDatePickerWithTitle:NSLocalizedString(@"开始时间", nil) mode:UIDatePickerModeTime editItem:obj];
    }else{
//        if ([NSString isNotBlank:self.lsEtime.currentVal]) {
//            date=[DateUtils parseTodayTime:self.lsEtime.currentVal.intValue];
//        }
//        [TimePickerBox show:NSLocalizedString(@"结束时间", nil) date:date client:self event:obj.tag];
        [self showDatePickerWithTitle:NSLocalizedString(@"结束时间", nil) mode:UIDatePickerModeTime editItem:obj];
    }
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==1) {
        [self.lsBtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld", (long)[DateUtils getMinuteOfDate:date]]] ;
    } else {
        [self.lsEtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld", (long)[DateUtils getMinuteOfDate:date]]] ;
    }
    return YES;
}

-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsBtime getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择开始时间!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsEtime getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择结束时间!", nil)];
        return NO;
    }
    
    if ([self.lsEtime.currentVal isEqualToString:self.lsBtime.currentVal]) {
        [AlertBox show:NSLocalizedString(@"开始时间和结束时间不能相同!", nil)];
        return NO;
    }
    return YES;
}

-(ReserveTime*) transMode
{
    ReserveTime* tempUpdate=[ReserveTime new];
    tempUpdate.kind=self.kind;
    if ([NSString isNotBlank:[self.lsBtime getStrVal]]) {
        tempUpdate.beginTime=[self.lsBtime getStrVal].intValue;
    }
    if ([NSString isNotBlank:[self.lsEtime getStrVal]]) {
        tempUpdate.endTime=[self.lsEtime getStrVal].intValue;
    }
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    ReserveTime* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@可预订时段", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {

         [service saveReserveTime:objTemp Target:self Callback:@selector(remoteFinsh:)];
    }else{
        objTemp._id=self.selObj._id;

          [service updateReserveTime:objTemp Target:self Callback:@selector(remoteFinsh:)];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.selObj obtainItemName]]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),[self.selObj obtainItemName]]];
        [service removeReserveTime:self.selObj._id Target:self Callback:@selector(delFinish:)];
    }
}

@end
