//
//  TimeArrangeEditView.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimeArrangeEditView.h"
#import "SettingService.h"
#import "MBProgressHUD.h"
#import "SettingModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "TimeArrangeListView.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "UIViewController+Picker.h"
#import "YYModel.h"
#import "TDFBusinessService.h"
#import "TDFRootViewController+FooterButton.h"
@implementation TimeArrangeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
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
    [self loadData:self.timeArrangeVO action:self.action];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.title = NSLocalizedString(@"添加营业班次", nil);
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
    [self.txtName initLabel:NSLocalizedString(@"名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsBtime initLabel:NSLocalizedString(@"开始时间", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsEtime initLabel:NSLocalizedString(@"结束时间", nil) withHit:nil isrequest:YES delegate:self];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsBtime.tag=1;
    self.lsEtime.tag=2;
}

#pragma remote
-(void) loadData:(TimeArrangeVO*) tempVO action:(int)action
{
    self.action=action;
    self.timeArrangeVO=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加营业班次", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.timeArrangeVO.name;
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    [self.lsBtime initData:nil withVal:nil];
    [self.lsEtime initData:nil withVal:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.timeArrangeVO.name];
    [self.lsBtime initData:[self.timeArrangeVO getBtimeStr] withVal:[NSString stringWithFormat:@"%d",self.timeArrangeVO.beginTime]];
    [self.lsEtime initData:[self.timeArrangeVO getEtimeStr] withVal:[NSString stringWithFormat:@"%d",self.timeArrangeVO.endTime]];
}

#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_TimeArrangeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TimeArrangeEditView_Change object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_TIMEARRANGE_UPDATE object:nil];
  
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
    if (self.callBack) {
        self.callBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
//    NSDate* date=[NSDate date];
    if (obj.tag==1) {
//        if ([NSString isNotBlank:self.lsBtime.currentVal]) {
//            date=[DateUtils parseTodayTime:self.lsBtime.currentVal.intValue];
//        }
//        [TimePickerBox show:NSLocalizedString(@"开始时间", nil) date:date client:self event:obj.tag];
        [self showDatePickerWithTitle:NSLocalizedString(@"开始时间", nil) mode:UIDatePickerModeTime editItem:obj];
    } else {
//        if ([NSString isNotBlank:self.lsEtime.currentVal]) {
//            date=[DateUtils parseTodayTime:self.lsEtime.currentVal.intValue];
//        }
        [self showDatePickerWithTitle:NSLocalizedString(@"结束时间", nil) mode:UIDatePickerModeTime editItem:obj];
    }
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==1) {
        [self.lsBtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    } else {
        [self.lsEtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    }
    return YES;
}

#pragma save-data

-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"营业班次名称不能为空!", nil)];
        return NO;
    }
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

-(TimeArrangeVO*) transMode
{
    TimeArrangeVO* tempUpdate=[TimeArrangeVO new];
    tempUpdate.name=[self.txtName getStrVal];
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
    TimeArrangeVO* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@营业班次", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        //修改
//        [service saveTimeArrange:objTemp Target:self Callback:@selector(remoteFinsh:)];
        [TDFBusinessService saveBusinessSpellWithSpellString:[objTemp yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
            [self.progressHud hide:YES];
            if ([response isSuccess]) {
                if (self.callBack) {
                    self.callBack();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [AlertBox show:response.error.localizedDescription];
            }
        }];
    } else {
        objTemp._id=self.timeArrangeVO._id;
        //修改
//        [service updateTimeArrange:objTemp Target:self Callback:@selector(remoteFinsh:)];
        [TDFBusinessService saveBusinessSpellWithSpellString:[objTemp yy_modelToJSONString] completeBlock:^(TDFResponseModel * response) {
            [self.progressHud hide:YES];
            if ([response isSuccess]) {
                if (self.callBack) {
                    self.callBack();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [AlertBox show:response.error.localizedDescription];
            }
        }];

    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.timeArrangeVO.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.timeArrangeVO.name]];
        //修改
//         [service removeTimeArrange:self.timeArrangeVO._id Target:self Callback:@selector(delFinish:)];
        [TDFBusinessService removeBusinessSpellWithSpellId:self.timeArrangeVO._id completeBlock:^(TDFResponseModel * response) {
            [self.progressHud hide:YES];
            if ([response isSuccess]) {
                if (self.callBack) {
                    self.callBack();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [AlertBox show:response.error.localizedDescription];
            }
        }];
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"timearrange"];
}


@end
