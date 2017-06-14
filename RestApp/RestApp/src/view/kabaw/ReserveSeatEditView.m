//
//  ReserveSeatEditView.m
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReserveSeatEditView.h"

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
#import "XHAnimalUtil.h"
#import "UIViewController+Picker.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ReserveSeat.h"
#import "ReserveTime.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "FormatUtil.h"
#import "HelpDialog.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ReserveSeatEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        parent=_parent;
        service=[ServiceFactory Instance].kabawService;
//        hud = [[MBProgressHUD alloc] initWithView:self.view];
        self.times =[[NSMutableArray alloc]init];
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
    self.title = NSLocalizedString(@"可预订桌位", nil);
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
    [self.lsTime initLabel:NSLocalizedString(@"预订时段", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtName initLabel:NSLocalizedString(@"名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLower initLabel:NSLocalizedString(@"最少容纳人数", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtMax initLabel:NSLocalizedString(@"最多容纳人数", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtNum initLabel:NSLocalizedString(@"可接受预订桌位数量", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.lsMoney initLabel:NSLocalizedString(@"定金(元)", nil) withHit:nil delegate:self];
    

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.lsTime.tag=RSSEAT_TIME;
    self.lsMoney.tag=RSSEAT_MONEY;
    
    [self.lsMoney setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}
-(void)loadTimeData:(NSMutableArray *)timedata
{
    self.times=timedata;
}
#pragma remote
-(void) loadData:(ReserveSeat*) tempVO action:(int)action
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
    [self.lsTime initData:nil withVal:nil];
    if (self.times!=nil && self.times.count>0) {
        ReserveTime* time=(ReserveTime*)[self.times firstObject];
        [self.lsTime initData:[time obtainItemName] withVal:time._id];
    }
//     self.lsTime.lblVal.textColor = [UIColor redColor];
    [self.txtName initData:nil];
    [self.txtLower initData:@"1"];
    [self.txtMax initData:@"4"];
    [self.txtNum initData:@"1"];
    [self.lsMoney initData:@"0" withVal:@"0"];
}

-(void) fillModel
{
   
    if (self.times!=nil && self.times.count>0) {
        [self.lsTime initData:[GlobalRender obtainObjName:self.times itemId:self.selObj.reserveTimeId] withVal:self.selObj.reserveTimeId];
    }else{
        [self.lsTime initData:nil withVal:nil];

    }
    [self.txtName initData:self.selObj.name];
    NSString* lowerStr=[NSString stringWithFormat:@"%d",self.selObj.minNum];
    [self.txtLower initData:lowerStr];
    
    NSString* maxStr=[NSString stringWithFormat:@"%d",self.selObj.maxNum];
    [self.txtMax initData:maxStr];
    
    NSString* numStr=[NSString stringWithFormat:@"%d",self.selObj.seatNumber];
    [self.txtNum initData:numStr];
    
    NSString* moneyStr=[FormatUtil formatDouble4:self.selObj.reserveAmount];
    [self.lsMoney initData:moneyStr withVal:moneyStr];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ReserveSeatEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ReserveSeatEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeRefresh:) name:REMOTE_RESERVETIME_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeRefresh:) name:REMOTE_RESERVETIME_LOAD object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_RESERVESEAT_SAVE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_RESERVESEAT_UPDATE object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_RESERVESEAT_DELONE object:nil];
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
    self.callBack();
    [self.navigationController popViewControllerAnimated:YES];
}

//可预订时段时间刷新.
-(void)timeRefresh:(NSNotification*) notification
{
    self.times= (NSMutableArray*)notification.object;
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
    self.callBack();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if (obj.tag==RSSEAT_TIME) {
//        [OptionPickerBox initData:self.times itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:self.times
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:wself.times[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

-(BOOL)pickOption:(id)item event:(NSInteger)event
{
    if (event==RSSEAT_TIME) {
        NameItemVO* vo = (NameItemVO*)item;
        [self.lsTime changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (void)clientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==RSSEAT_MONEY) {
        [self.lsMoney changeData:val withVal:val];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsTime getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择预订时段!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"名称不能为空!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtLower getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"最少容纳人数不能为空!", nil)];
        return NO;
    }
    if (![NSString isNumNotZero:[self.txtLower getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"最少容纳人数不是大于0的数字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtMax getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"最多容纳人数不能为空!", nil)];
        return NO;
    }
    if (![NSString isNumNotZero:[self.txtMax getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"最多容纳人数不是大于0的数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtNum getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"可预订预订桌位数量不能为空!", nil)];
        return NO;
    }
    if (![NSString isNumNotZero:[self.txtNum getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"可预订预订桌位数量不是大于0的数字!", nil)];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsMoney getStrVal]] && ![NSString isFloat:[self.lsMoney getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"定金(元)不是数字!", nil)];
        return NO;
    }
    return YES;
}

-(ReserveSeat*) transMode
{
    ReserveSeat* tempUpdate=[ReserveSeat new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.seatKind=0;
    tempUpdate.minNum=[self.txtLower getStrVal].intValue;
    tempUpdate.maxNum=[self.txtMax getStrVal].intValue;
    tempUpdate.seatNumber=[self.txtNum getStrVal].intValue;
    if ([NSString isBlank:[self.lsMoney getStrVal]]) {
        tempUpdate.reserveAmount=0;
    }else{
        tempUpdate.reserveAmount=[self.lsMoney getStrVal].doubleValue;
    }
    tempUpdate.reserveTimeId=[self.lsTime getStrVal];
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    ReserveSeat* objTemp = [self transMode];
    NSString* tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@可预订桌位", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
//        [service saveReserveSeat:objTemp event:REMOTE_RESERVESEAT_SAVE];
        [service saveReserveSeat:objTemp Target:self Callback:@selector(remoteFinsh:)];
    }else{
        objTemp._id=self.selObj._id;
//        [service updateReserveSeat:objTemp event:REMOTE_RESERVESEAT_UPDATE];
        [service updateReserveSeat:objTemp Target:self Callback:@selector(remoteFinsh:)];
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
        [service removeReserveSeat:self.selObj._id Target:self Callback:@selector(delFinish:)];

    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

@end

