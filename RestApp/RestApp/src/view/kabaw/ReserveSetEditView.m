//
//  ResertSetEditView.m
//  RestApp
//
//  Created by zxh on 14-5-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+KabawModule.h"
#import "ReserveSetEditView.h"
#import "KabawModule.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "KabawService.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "RemoteResult.h"
#import "NSString+Estimate.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditMultiList.h"
#import "KabawModuleEvent.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "RatioPickerBox.h"
#import "SpecialListView.h"
#import "UIView+Sizes.h"
#import "FormatUtil.h"
#import "ReserveSet.h"
#import "ReserveRender.h"
#import "GlobalRender.h"
#import "HelpDialog.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ReserveSetEditView

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
    [self clearDo];
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadDatas];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = @"预订";
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
    [self.container addSubview:self.rdoIsAdult];
    [self.container addSubview:self.mlsTime];
    [self.container addSubview:self.mlsSeat];
    [self.container addSubview:self.mlsSpecial];
    [self.container addSubview:self.mlsBand];
    [self.rdoIsReserve initLabel:NSLocalizedString(@"开通火小二预订功能", nil) withHit:nil delegate:self];
    [self.txtReserveDay initLabel:NSLocalizedString(@"▪︎ 接受几天之内的预订(天)", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtAdvanceDay initLabel:NSLocalizedString(@"▪︎ 需要提前几天预订(天)", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.lsMode initLabel:NSLocalizedString(@"▪︎ 预订点菜定金收取方式", nil) withHit:nil delegate:self];
    [self.lsFee initLabel:NSLocalizedString(@"▪︎ 点单收取定金", nil) withHit:nil isrequest:YES delegate:self];
    [self.rdoIsAdult initLabel:NSLocalizedString(@"客户订单提交到店家后需要审核", nil) withHit:nil delegate:nil];
    
    [self.mlsTime initRightLabel:NSLocalizedString(@"▪︎ 可预订时段", nil)  delegate:self];
    [self.mlsSeat initRightLabel:NSLocalizedString(@"▪︎ 可预订桌位", nil)  delegate:self];
    [self.mlsSpecial initRightLabel:NSLocalizedString(@"▪︎ 优惠方案", nil)  delegate:self];
    [self.mlsBand initRightLabel:NSLocalizedString(@"▪︎ 不接受预订日期", nil)  delegate:self];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.rdoIsReserve.tag=RS_IS_RESERVE;
    self.lsMode.tag=RS_FEEMODE;
    self.lsFee.tag=RS_FEE;
    self.rdoIsAdult.tag=RS_IS_AUDIT;
    self.mlsTime.tag=RS_MLS_TIME;
    self.mlsSeat.tag=RS_MLS_SEAT;
    self.mlsSpecial.tag=RS_MLS_SPCIAL;
    self.mlsBand.tag=RS_MLS_BAND;
}

- (EditItemRadio *) rdoIsAdult
{
    if(!_rdoIsAdult)
    {
        _rdoIsAdult = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 245, SCREEN_WIDTH, 48)];
    }
    return _rdoIsAdult;
}

- (EditMultiList *) mlsTime
{
    if(!_mlsTime)
    {
        _mlsTime = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 294, SCREEN_WIDTH, 48)];
    }
    return _mlsTime;
}

- (EditMultiList *) mlsSeat
{
    if(!_mlsSeat)
    {
        _mlsSeat = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 343, SCREEN_WIDTH, 48)];
    }
    return _mlsSeat;
}

- (EditMultiList *) mlsSpecial
{
    if(!_mlsSpecial)
    {
        _mlsSpecial = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 393, SCREEN_WIDTH, 48)];
    }
    return _mlsSpecial;
}

- (EditMultiList *) mlsBand
{
    if(!_mlsBand)
    {
        _mlsBand = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 443, SCREEN_WIDTH, 48)];
    }
    return _mlsBand;
}

#pragma remote
-(void) loadDatas
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
//    [service loadReserveSet:REMOTE_RESERVESET_LOAD];
    [service loadReserveSetTarget:self Callback:@selector(loadFinsh:)];
}

#pragma 数据层处理
-(void) clearDo
{
    [self.rdoIsReserve initShortData:0];
    [self subVisibal];
    [self.lsFee initData:@"0" withVal:@"0"];
    [self.lsFee visibal:NO];
    
    self.lsFee.lblName.text=NSLocalizedString(@"▪︎ 点单收取定金", nil);
    
    [self.rdoIsAdult initShortData:0];
    [self.txtReserveDay initData:@"30"];
    [self.txtAdvanceDay initData:@"1"];
    [self.lsMode initData:NSLocalizedString(@"不收费", nil) withVal:@"3"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    [self.rdoIsReserve initShortData:self.reserveSet.isReserve];
    
    [self.rdoIsAdult initShortData:self.reserveSet.isAudit];
     NSString* reserveFee=[FormatUtil formatDouble4:self.reserveSet.reserveFee];
    [self.lsFee initData:reserveFee withVal:reserveFee];
    int reserveDay=self.reserveSet.reserveDay==0?30:self.reserveSet.reserveDay;
    NSString* rsDayStr=[NSString stringWithFormat:@"%d",reserveDay];
    [self.txtReserveDay initData:rsDayStr];
    
    int advanceDay=self.reserveSet.advanceDay;
    NSString* rsADDayStr=[NSString stringWithFormat:@"%d",advanceDay];
    [self.txtAdvanceDay initData:rsADDayStr];

    NSMutableArray* modeList=[ReserveRender listMode];
    NSString* mode=[NSString stringWithFormat:@"%d",self.reserveSet.reserveFeeMode ];
    [self.lsMode initData:[GlobalRender obtainItem:modeList itemId:mode] withVal:mode];
    self.lsMode.lblVal.font = [UIFont systemFontOfSize:14];
    NSString* unit=[NSString stringWithFormat:NSLocalizedString(@"▪︎ 点单收取定金%@", nil),[ReserveRender obtainReserveFeeUnit:self.reserveSet.reserveFeeMode]];
    self.lsFee.lblName.text=unit;
    [self subVisibal];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ReserveSetEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ReserveSetEditView_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeRefresh:) name:REMOTE_RESERVETIME_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bandRefresh:) name:REMOTE_RESERVEBAND_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seatRefresh:) name:REMOTE_RESERVESEAT_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialRefresh:) name:REMOTE_SPECIAL_REFRESH object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinsh:) name:REMOTE_RESERVESET_LOAD object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_RESERVESET_UPDATE object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

//可预订时段时间刷新.
-(void)timeRefresh:(NSNotification*) notification
{
    self.times= (NSMutableArray*)notification.object;
    [self.mlsTime initData:self.times];
    if ([[self.lsMode getStrVal] isEqualToString:@"3"]) {
        [self.lsFee visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//不接受预订日期刷新.
-(void)bandRefresh:(NSNotification*) notification
{
    self.bands= (NSMutableArray*)notification.object;
    [self.mlsBand initData:self.bands];
    if ([[self.lsMode getStrVal] isEqualToString:@"3"]) {
        [self.lsFee visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//可预订桌位刷新.
-(void)seatRefresh:(NSNotification*) notification
{
    self.seats= (NSMutableArray*)notification.object;
     [self.mlsSeat  initData:self.seats];
    if ([[self.lsMode getStrVal] isEqualToString:@"3"]) {
        [self.lsFee visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//优惠信息刷新.
-(void)specialRefresh:(NSNotification*) notification
{
    self.specails= (NSMutableArray*)notification.object;
    [self.mlsSpecial initData:self.specails];
    if ([[self.lsMode getStrVal] isEqualToString:@"3"]) {
        [self.lsFee visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)loadFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_RESERVETIME_LOAD object:[NSMutableArray array]] ;
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    
    NSDictionary *setDic = [map objectForKey:@"reserveSet"];
    self.reserveSet=[JsonHelper dicTransObj:setDic obj:[ReserveSet alloc]];
    
    NSArray *list = [map objectForKey:@"reserveBands"];
    self.bands=[JsonHelper transList:list objName:@"ReserveBand"];
    
    list = [map objectForKey:@"reserveSeats"];
    self.seats=[JsonHelper transList:list objName:@"ReserveSeat"];

    list = [map objectForKey:@"specials"];
    self.specails=[JsonHelper transList:list objName:@"Special"];

    list = [map objectForKey:@"reserveTimes2"];
    self.times=[JsonHelper transList:list objName:@"ReserveTime"];

    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_RESERVETIME_LOAD object:self.times] ;

    [self.mlsTime initData:self.times];
    [self.mlsSeat  initData:self.seats];
    [self.mlsBand initData:self.bands];
    [self.mlsSpecial initData:self.specails];
    
    if (self.reserveSet==nil) {
        [self clearDo];
    } else {
        [self fillModel];
    }
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
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
    [self loadDatas];
    [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if(obj.tag==RS_FEEMODE){
//        [OptionPickerBox initData:[ReserveRender listMode] itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[ReserveRender listMode]
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[ReserveRender listMode][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if(obj.tag==RS_FEE){
        NSString* fixModel=[NSString stringWithFormat:@"%d",FEE_MODE_FIX];
        NSString* ratioModel=[NSString stringWithFormat:@"%d",FEE_MODE_RATIO ];
        if ([fixModel isEqualToString:[self.lsMode getStrVal]]) {
            [self.lsFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsFee.lblVal becomeFirstResponder];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsFee.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
            #pragma clang diagnostic pop
        }else if([ratioModel isEqualToString:[self.lsMode getStrVal]]){
            int ratio=100;
            if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
                ratio=[obj getStrVal].intValue;
            }
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:NSLocalizedString(@"收取定金", nil) client:self event:obj.tag];
        }
    }
}

//多选List控件变换.
- (void)onMultiItemListClick:(EditMultiList *)obj
{
    if (obj.tag==RS_MLS_TIME) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveTimeListViewControllerWithData:self.times kind:KIND_RESERVE];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if(obj.tag==RS_MLS_SEAT) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveSeatListViewControllerWithSeatDatas:self.seats andTimes:self.times];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if(obj.tag==RS_MLS_SPCIAL) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_specialListViewControllerWithData:self.specails];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if(obj.tag==RS_MLS_BAND) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_reserveBandListViewControllerWithData:self.bands];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag==RS_IS_RESERVE) {
        [self subVisibal];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    if (eventType==RS_FEE) {
        NSString* result=(NSString*)selectObj;
        [self.lsFee changeData:result withVal:result];
    } else {
        NameItemVO* vo=(NameItemVO*)selectObj;
        short mode=vo.itemId.intValue;
        NSString* unit=[NSString stringWithFormat:NSLocalizedString(@"▪︎ 点单收取定金%@", nil),[ReserveRender obtainReserveFeeUnit:mode]];
        self.lsFee.lblName.text=unit;
        if (eventType==RS_FEEMODE) {
            [self.lsMode changeData:vo.itemName withVal:vo.itemId];
            [self subVisibal];
            [self.lsFee changeData:nil withVal:nil];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==RS_FEE) {
        [self.lsFee changeData:val withVal:val];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if (![self.rdoIsReserve getVal]) {
        return YES;
    }
    if ([NSString isBlank:[self.lsMode getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"请选择预订点菜定金收取方式!", nil)];
        return NO;
    }
    int mode=[self.lsMode getStrVal].intValue;
    if (mode==FEE_MODE_RATIO || mode==FEE_MODE_FIX) {
        if ([NSString isBlank:[self.lsFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"点单收取定金(元)不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isFloat:[self.lsFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"点单收取定金(元)不是数字!", nil)];
            return NO;
        }
    }
    if ([NSString isBlank:[self.txtReserveDay getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"接受预定几天之内的预订(天)不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtReserveDay getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"接受预订几天之内的预订(天)不能为空!", nil)];
        return NO;
    }
    if (![NSString isNumNotZero:[self.txtReserveDay getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"接受预订几天之内的预订(天)不是大于0的数字!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.txtAdvanceDay getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"需要提前几天预订(天)不能为空!", nil)];
        return NO;
    }
    if (![NSString isPositiveNum:[self.txtAdvanceDay getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"需要提前几天预订(天)不是大于等于0数字!", nil)];
        return NO;
    }
    return YES;
}

-(ReserveSet*) transMode
{
    ReserveSet* tempUpdate=[ReserveSet new];
    if(self.reserveSet!=nil) {
        tempUpdate=self.reserveSet;
    }
   
    tempUpdate.isReserve=[self.rdoIsReserve getVal]?1:0;
    if ([self.rdoIsReserve getVal]) {
        tempUpdate.reserveFeeMode=[self.lsMode getStrVal].intValue;
        if (tempUpdate.reserveFeeMode==FEE_MODE_NO) {
            tempUpdate.reserveFee=0;
        } else {
            tempUpdate.reserveFee=[self.lsFee getStrVal].doubleValue;
        }
        tempUpdate.reserveDay=[self.txtReserveDay getStrVal].intValue;
        tempUpdate.advanceDay=[self.txtAdvanceDay getStrVal].intValue;
        tempUpdate.isAudit=[self.rdoIsAdult getVal]?1:0;
    }
    tempUpdate.outOnlinePay=0;
    tempUpdate.outSendedPay=0;
    tempUpdate.outOrderMode=OUTORDERMODE_AUTO;
    tempUpdate.outPreMinute=30;
    tempUpdate.outFeeMode=0;
    tempUpdate.outFee=0;
    
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    ReserveSet* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@预订设置", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
//    [service updateReserveSet:objTemp event:REMOTE_RESERVESET_UPDATE];
    [service updateReserveSet:objTemp Target:self Callback:@selector(remoteFinsh:)];
    
}

///===============================================================================
///===============================================================================
///===============================================================================
-(void) subVisibal
{
    BOOL isOpen=[self.rdoIsReserve getVal];
    [self.rdoIsAdult visibal:isOpen];
    [self.lsMode visibal:isOpen];
    [self.lsFee visibal:isOpen];
    if (isOpen) {
        int mode=[self.lsMode getStrVal].intValue;
        [self.lsFee visibal:(mode!=FEE_MODE_NO)];
    }
    [self.txtReserveDay visibal:isOpen];
    [self.txtAdvanceDay visibal:isOpen];
    [self.mlsTime visibal:isOpen];
    [self.mlsBand visibal:isOpen];
    [self.mlsSeat visibal:isOpen];
    [self.mlsSpecial visibal:isOpen];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}
@end
