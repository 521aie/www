//
//  TakeOutTimeEditViewTableViewController.m
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TakeOutTimeEditView.h"
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
#import "EditItemRadio.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "TDFMediator+KabawModule.h"
#import "UIViewController+Picker.h"
#import "TDFRootViewController+FooterButton.h"

@implementation TakeOutTimeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          service=[ServiceFactory Instance].kabawService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.changed=NO;
    [self initNavigate];
    [self initMainView];
    [self loadData:self.selObj action:self.action];
    [self initNotifaction];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"可送外卖时段", nil);
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
- (UILabel *)lblHelp
{
    if (!_lblHelp) {
        _lblHelp = [[UILabel alloc] initWithFrame:CGRectMake(15, 258, SCREEN_WIDTH-30, 40)];
        _lblHelp.font = [UIFont systemFontOfSize:11];
        _lblHelp.numberOfLines = 0;
        _lblHelp.text=NSLocalizedString(@"提示:如果外送能力有限,可在此处设置一个外卖订单数量的上限，本时段内接受到得订单数量超过这个数字时外卖将暂时关闭，下个时段开始时会重新开启", nil);
    }
    return _lblHelp;
}

- (UIButton *)btnDel
{
    if (!_btnDel) {
        _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDel.frame = CGRectMake(10, 207, SCREEN_WIDTH -20, 44);
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    }
    return _btnDel;
}

- (void)initMainView
{
    [self.lsBtime initLabel:NSLocalizedString(@"开始时间", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsEtime initLabel:NSLocalizedString(@"结束时间", nil) withHit:nil isrequest:YES delegate:self];
    
    [self.rdoLimit initLabel:NSLocalizedString(@"限制本时段外卖订单数量", nil) withHit:nil delegate:self];
    [self.txtNum initLabel:NSLocalizedString(@"▪︎ 外卖订单上限", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
 
    [self.scrollView addSubview:self.lblHelp];
    [self.scrollView addSubview:self.btnDel];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
    
    self.lsBtime.tag=1;
    self.lsEtime.tag=2;
}

#pragma remote
-(void) loadData:(TDFTakeOutTime *) tempVO action:(int)action
{
    self.action=action;
    self.selObj=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        [self clearDo];
    }else{
        [self fillModel];
    }
    [self changeFrame];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
//临时使用，适配做好后不需要
- (void)changeFrame
{
    BOOL isLimit = [self.rdoLimit getVal];
    if (isLimit) {
        if (!self.btnDel.hidden) {
             self.btnDel.frame = CGRectMake(10, 200, SCREEN_WIDTH-20, 44);
            self.lblHelp.frame = CGRectMake(15, 254, SCREEN_WIDTH-30, 40);
        }else
        {
            self.lblHelp.frame = CGRectMake(15, 200, SCREEN_WIDTH-30, 40);
        }
        
    }else{
        if (!self.btnDel.hidden) {
            self.btnDel.frame = CGRectMake(10, 150, SCREEN_WIDTH-20, 44);
            self.lblHelp.frame = CGRectMake(15, 204, SCREEN_WIDTH-30, 40);
        }else
        {
            self.lblHelp.frame = CGRectMake(15, 150, SCREEN_WIDTH-30, 40);
        }
    }
}

#pragma 数据层处理
-(void) clearDo{
    [self.lsBtime initData:nil withVal:nil];
    [self.lsEtime initData:nil withVal:nil];
    self.lsBtime.lblVal.textColor = [UIColor redColor];
    self.lsEtime.lblVal.textColor = [UIColor redColor];
    [self.rdoLimit initShortData:0];
    [self.txtNum visibal:NO];
    [self.txtNum initData:@"0"];
}

-(void) fillModel
{
    [self.lsBtime initData:[self.selObj getBtimeStr] withVal:[NSString stringWithFormat:@"%ld",self.selObj.beginTime]];
    [self.lsEtime initData:[self.selObj getEtimeStr] withVal:[NSString stringWithFormat:@"%ld",self.selObj.endTime]];
    [self.rdoLimit initShortData:(self.selObj.num>0)];
    [self.txtNum visibal:[self.rdoLimit getVal]];
     NSString* num=[NSString stringWithFormat:@"%d",self.selObj.num];
    if (self.selObj.num < 0) {
         [self.txtNum initData:@"0"];
    }else{
         [self.txtNum initData:num];
    }
   
}


#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_TakeOutTimeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_TakeOutTimeEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_TAKEOUTTIME_SAVE object:nil];
 
}


#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        if ([UIHelper currChange:self.container]) {
            [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
            [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
        }else{
            [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
            [self configRightNavigationBar:nil rightButtonName:@""];
        }
    }

}

-(void) delFinish:(RemoteResult*) result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.callBack();
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)remoteFinsh:(RemoteResult*) result{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.callBack();
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
    }else
    {
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
        [self.lsBtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]];
    } else {
        [self.lsEtime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]];
    }
    
    return YES;
}

-(void) onItemRadioClick:(EditItemRadio*)obj
{
    [self.txtNum visibal:[self.rdoLimit getVal]];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self changeFrame];
}

#pragma save-data

-(BOOL)isValid{
    
    
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
    
    if ([self.rdoLimit getVal]) {
        if ([NSString isBlank:[self.txtNum getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"外卖订单上限不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isPositiveNum:[self.txtNum getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"外卖订单上限不是数字!", nil)];
            return NO;
        }
    }

    return YES;
}

-(TDFTakeOutTime*) transMode{
    TDFTakeOutTime* tempUpdate=[TDFTakeOutTime new];
    if ([NSString isNotBlank:[self.lsBtime getStrVal]]) {
        tempUpdate.beginTime=[self.lsBtime getStrVal].intValue;
    }
    if ([NSString isNotBlank:[self.lsEtime getStrVal]]) {
        tempUpdate.endTime=[self.lsEtime getStrVal].intValue;
    }
    tempUpdate.num=0;
    if ([self.rdoLimit getVal]) {
        if ([NSString isNotBlank:[self.txtNum getStrVal]]) {
            tempUpdate.num=[self.txtNum getStrVal].intValue;
        }
    }
    return tempUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    TDFTakeOutTime *objTemp = [self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@可送外卖时段", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
        objTemp.id=self.selObj.id;
        [service saveTakeOutTime:objTemp Target:self Callback:@selector(remoteFinsh:)];
}
-(void)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.selObj obtainItemName]]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),[self.selObj obtainItemName]] andView:self.view andHUD:hud];
        [service removeTakeOutTime:self.selObj.id Target:self Callback:@selector(delFinish:)];
    }
}
-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"outsale"];
}

@end
