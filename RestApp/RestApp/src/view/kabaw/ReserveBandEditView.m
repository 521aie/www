//
//  ReserveBandEditView.m
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReserveBandEditView.h"
#import "KabawService.h"
#import "MBProgressHUD.h"
#import "KabawModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "RemoteEvent.h"
#import "KabawModuleEvent.h"
#import "EditItemList.h"
#import "XHAnimalUtil.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "UIViewController+Picker.h"

#import "TDFRootViewController+FooterButton.h"

@implementation ReserveBandEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].kabawService;
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
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
//    [self.titleBox editTitle:NO act:self.action];
    self.title = NSLocalizedString(@"不接受预订日期", nil);
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

-(void) initMainView
{
    [self.lsStartDate initLabel:NSLocalizedString(@"开始日期", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"结束日期", nil) withHit:nil delegate:self];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:nil];
    [UIHelper clearColor:self.container];
    
    self.lsStartDate.tag=RSBAND_STARTDATE;
    self.lsEndDate.tag=RSBAND_ENDDATE;
}

#pragma remote
-(void) loadData:(ReserveBand*) tempVO  action:(int)action
{
    self.action=action;
    self.selObj=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        [self clearDo];
    } else {
        [self fillModel];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];

    [self.lsStartDate initData:dateStr withVal:datsFullStr];
    [self.lsEndDate initData:dateStr withVal:datsFullStr];
}

-(void) fillModel
{
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    if ([NSString isNotBlank:self.selObj.startDate]) {
        NSDate* startDate=[DateUtils DateWithString:self.selObj.startDate type:TDFFormatTimeTypeAllTimeString];
        NSString* startDate2=[DateUtils formatTimeWithDate:startDate type:TDFFormatTimeTypeYearMonthDay];
        datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",startDate2];
        [self.lsStartDate initData:startDate2 withVal:datsFullStr];
    } else {
        [self.lsStartDate initData:dateStr withVal:datsFullStr];
    }
    
    if (self.selObj.endDate!=nil) {
        NSDate* endDate=[DateUtils DateWithString:self.selObj.endDate type:TDFFormatTimeTypeAllTimeString];
        NSString* endDate2=[DateUtils formatTimeWithDate:endDate type:TDFFormatTimeTypeYearMonthDay];
        datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",endDate2];
        [self.lsEndDate initData:endDate2 withVal:datsFullStr];
    } else {
        [self.lsEndDate initData:dateStr withVal:datsFullStr];
    }
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ReserveBandEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ReserveBandEditView_Change object:nil];
 
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

-(void)remoteFinsh:(RemoteResult*)result
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
    if(obj.tag==RSBAND_STARTDATE || obj.tag==RSBAND_ENDDATE){
    
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    if (event==RSBAND_STARTDATE) {
        [self.lsStartDate changeData:dateStr withVal:datsFullStr] ;
    } else {
        [self.lsEndDate changeData:dateStr withVal:datsFullStr] ;
    }
    return YES;
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsStartDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择开始时间!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsEndDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择结束时间!", nil)];
        return NO;
    }
    
    NSString *sdateStr = [[self.lsStartDate getStrVal] substringToIndex:10];
    NSString *edateStr = [[self.lsEndDate getStrVal] substringToIndex:10];
    NSDate *sdate = [DateUtils DateWithString:sdateStr type:TDFFormatTimeTypeYearMonthDayString];
    NSDate *edate = [DateUtils DateWithString:edateStr type:TDFFormatTimeTypeYearMonthDayString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [DateUtils DateWithString:nowStr type:TDFFormatTimeTypeYearMonthDayString];
    
    NSComparisonResult result = [sdate compare:edate]; // comparing two dates
    
    if ([sdate compare:nowDate] == NSOrderedAscending) {
        [AlertBox show:@"开始日期不能小于当前日期"];
        return NO;
    }
    
    if([edate compare:nowDate] == NSOrderedAscending){
        [AlertBox show:NSLocalizedString(@"结束日期不能小于当前日期!", nil)];
        return NO;
    }
    
    if(result==NSOrderedDescending){
        [AlertBox show:NSLocalizedString(@"结束时间小于开始日期!", nil)];
        return NO;
    }
    return YES;
}

-(ReserveBand*) transMode
{
    ReserveBand* tempUpdate=[ReserveBand new];
    tempUpdate.startDate=[self.lsStartDate getStrVal];
    tempUpdate.endDate=[self.lsEndDate getStrVal];
    tempUpdate.sdate=[self.lsStartDate getStrVal];
    tempUpdate.edate=[self.lsEndDate getStrVal];
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    ReserveBand* objTemp=[self transMode];
    
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@可预订时段", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {

        [service saveReserveBand:objTemp Target:self Callback:@selector(remoteFinsh:)];
    } else {
        objTemp._id=self.selObj._id;

        [service updateReserveBand:objTemp Target:self Callback:@selector(remoteFinsh:)];

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
        [service removeReserveBand:self.selObj._id Target:self Callback:@selector(delFinish:)];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

@end
