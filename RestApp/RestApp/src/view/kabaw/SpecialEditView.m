//
//  SpecialEditView.m
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFMediator+SupplyChain.h"
#import "SpecialEditView.h"
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
#import "ItemTitle.h"
#import "EditMultiList.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "RatioPickerBox.h"
#import "SystemUtil.h"
#import "Special.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "MultiCheckView.h"
#import "GlobalRender.h"
#import "SpecialRender.h"
#import "FormatUtil.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"
#import "UIViewController+Picker.h"
#import "TDFRootViewController+FooterButton.h"
@implementation SpecialEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    service=[ServiceFactory Instance].kabawService;
    settingService=[ServiceFactory Instance].settingService;
    self.changed=NO;
      [self initMainView];
    [self initNavigate];
    [self initNotifaction];
  
    [self loadData:self.selObj action:self.action];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"优惠方案", nil);
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_SPECIAL_LIST object:nil];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
     [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_SPECIAL_LIST object:nil];
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}

#pragma set--get
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+64)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}

- (UIView *) container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
        _container.backgroundColor = [UIColor clearColor];
        
        [_container addSubview:self.baseTitle];
        [_container addSubview:self.txtName];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
        [_container addSubview:view];
        [_container addSubview:self.titleValid];
        [_container addSubview:self.rdoIsDate];
        [_container addSubview:self.lsStartDate];
        [_container addSubview:self.lsEndDate];
        [_container addSubview:self.rdoIsWeek];
        [_container addSubview:self.mlsWeek];
        [_container addSubview:self.rdoIsTime];
        [_container addSubview:self.lsStartTime];
        [_container addSubview:self.lsEndTime];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
        [_container addSubview:view1];
        
        [_container addSubview:self.titleSpecial];
        [_container addSubview:self.lsMode];
        [_container addSubview:self.lsRatio];
        [_container addSubview:self.rdoIsForce];
        [_container addSubview:self.lsPlan];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 219, SCREEN_WIDTH, 66)];
        [_container addSubview:view2];
        [view2 addSubview:self.btnDel];
    }
    return _container;
}

- (UIButton *) btnDel
{
    if (!_btnDel) {
        _btnDel = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH - 20, 44)];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

- (ItemTitle *) baseTitle
{
    if (!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 222, SCREEN_WIDTH, 60)];
        [_baseTitle awakeFromNib];
    }
    return _baseTitle;
}

- (EditItemText *) txtName
{
    if (!_txtName) {
        _txtName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 48)];
    }
    return _txtName;
}

- (ItemTitle *) titleValid
{
    if (!_titleValid) {
        _titleValid = [[ItemTitle alloc] initWithFrame:CGRectMake(0,48, SCREEN_WIDTH, 60)];
        [_titleValid awakeFromNib];
    }
    return _titleValid;
}

- (EditItemRadio *) rdoIsDate
{
    if (!_rdoIsDate) {
        _rdoIsDate = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 48)];
    }
    return _rdoIsDate;
}

- (EditItemList *) lsStartDate
{
    if (!_lsStartDate) {
        _lsStartDate = [[EditItemList alloc] initWithFrame:CGRectMake(0, 156, SCREEN_WIDTH, 48)];
    }
    return _lsStartDate;
}

- (EditItemList *) lsEndDate
{
    if (!_lsEndDate) {
        _lsEndDate = [[EditItemList alloc] initWithFrame:CGRectMake(0, 202, SCREEN_WIDTH, 48)];
    }
    return _lsEndDate;
}

- (EditItemRadio *) rdoIsWeek
{
    if (!_rdoIsWeek) {
        _rdoIsWeek = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 249, SCREEN_WIDTH, 48)];
    }
    return _rdoIsWeek;
}

- (EditMultiList *) mlsWeek
{
    if (!_mlsWeek) {
        _mlsWeek = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 297, SCREEN_WIDTH, 48)];
    }
    return _mlsWeek;
}

- (EditItemRadio *) rdoIsTime
{
    if (!_rdoIsTime) {
        _rdoIsTime = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 345, SCREEN_WIDTH, 48)];
    }
    return _rdoIsTime;
}

- (EditItemList *) lsStartTime
{
    if (!_lsStartTime) {
        _lsStartTime = [[EditItemList alloc] initWithFrame:CGRectMake(0, 393, SCREEN_WIDTH, 48)];
    }
    return _lsStartTime;
}

- (EditItemList *) lsEndTime
{
    if (!_lsEndTime) {
        _lsEndTime = [[EditItemList alloc] initWithFrame:CGRectMake(0, 439, SCREEN_WIDTH, 48)];
    }
    return _lsEndTime;
}

- (ItemTitle *) titleSpecial
{
    if (!_titleSpecial) {
        _titleSpecial = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 487, SCREEN_WIDTH, 60)];
        [_titleSpecial awakeFromNib];
    }
    return _titleSpecial;
}

- (EditItemList *) lsMode
{
    if (!_lsMode) {
        _lsMode = [[EditItemList alloc] initWithFrame:CGRectMake(0, 547, SCREEN_WIDTH, 48)];
    }
    return _lsMode;
}

- (EditItemList *) lsRatio
{
    if (!_lsRatio) {
        _lsRatio = [[EditItemList alloc] initWithFrame:CGRectMake(0, 594, SCREEN_WIDTH, 48)];
    }
    return _lsRatio;
}

- (EditItemRadio *) rdoIsForce
{
    if (!_rdoIsForce) {
        _rdoIsForce = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 642, SCREEN_WIDTH, 48)];
    }
    return _rdoIsForce;
}

- (EditItemList *) lsPlan
{
    if (!_lsPlan) {
        _lsPlan = [[EditItemList alloc] initWithFrame:CGRectMake(0, 690, SCREEN_WIDTH, 48)];
    }
    return _lsPlan;
}

-(void) initMainView
{
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.txtName initLabel:NSLocalizedString(@"优惠方案名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.titleValid.lblName.text=NSLocalizedString(@"有效期设置", nil);
    [self.rdoIsDate initLabel:NSLocalizedString(@"仅在指定预订日期内有效", nil) withHit:nil delegate:self];
    [self.lsStartDate initLabel:NSLocalizedString(@"▪︎ 开始日期", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"▪︎ 结束日期", nil) withHit:nil delegate:self];
    
    [self.rdoIsTime initLabel:NSLocalizedString(@"在指定时间有效", nil) withHit:nil delegate:self];
    [self.lsStartTime initLabel:NSLocalizedString(@"▪︎ 开始时间", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsEndTime initLabel:NSLocalizedString(@"▪︎ 结束时间", nil) withHit:nil isrequest:YES delegate:self];
    
    [self.rdoIsWeek initLabel:NSLocalizedString(@"仅在每周特定日期有效", nil) withHit:nil delegate:self];
    [self.mlsWeek initLabel:NSLocalizedString(@"▪︎ 日期", nil) delegate:self];

    self.titleSpecial.lblName.text=NSLocalizedString(@"预订优惠", nil);
    [self.lsMode initLabel:NSLocalizedString(@"优惠方式", nil) withHit:nil delegate:self];
    [self.lsRatio initLabel:NSLocalizedString(@"▪︎ 折扣率(%)", nil) withHit:nil delegate:self];
    [self.rdoIsForce initLabel:NSLocalizedString(@"▪︎ 对不允许打折的商品也打折", nil) withHit:nil delegate:nil];
    [self.lsPlan initLabel:NSLocalizedString(@"▪︎ 打折方案", nil) withHit:nil delegate:self];
    
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.rdoIsDate.tag=SPECIAL_IS_DATE;
    self.lsStartDate.tag=SPECIAL_STARTDATE;
    self.lsEndDate.tag=SPECIAL_ENDDATE;
    self.rdoIsTime.tag=SPECIAL_IS_TIME;
    self.lsStartTime.tag=SPECIAL_STARTTIME;
    self.lsEndTime.tag=SPECIAL_ENDTIME;
    self.rdoIsWeek.tag=SPECIAL_IS_WEEK;
    self.mlsWeek.tag=SPECIAL_WEEKS;
    self.lsMode.tag=SPECIAL_MODE;
    self.lsRatio.tag=SPECIAL_RATIO;
    self.lsPlan.tag=SPECIAL_PLAN;
    
}

#pragma remote
-(void) loadData:(Special*) tempVO  action:(int)action
{
    self.action=action;
    self.selObj=tempVO;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listDiscountPlanSucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        NSArray *list = [data objectForKey:@"data"];
        self.plans=[JsonHelper transList:list objName:@"DiscountPlan"];
        if (self.action==ACTION_CONSTANTS_ADD) {
            self.title=NSLocalizedString(@"添加优惠方案", nil);
            [self clearDo];
        }else{
            self.title=self.selObj.name;
            [self fillModel];
        }
        [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
        [self.titleBox editTitle:NO act:self.action];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
        
    }];

}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    [self.mlsWeek initData:nil];
    [self isShowDate:NO];
    [self isShowTime:NO];
    [self isShowWeek:NO];
    
    [self.rdoIsDate initShortData:0];
    [self.rdoIsTime initShortData:0];
    [self.rdoIsWeek initShortData:0];
    
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    [self.lsStartDate initData:dateStr withVal:dateStr];
    [self.lsEndDate initData:dateStr withVal:dateStr];
    [self.lsStartTime initData:nil withVal:nil];
    [self.lsEndTime initData:nil withVal:nil];
    
    self.lsStartTime.lblVal.textColor = [UIColor redColor];
    self.lsEndTime.lblVal.textColor = [UIColor redColor];
    
    [self.lsMode initData:NSLocalizedString(@"按会员价", nil) withVal:[NSString stringWithFormat:@"%d",SPECIAL_MODE_MEMBER_RATIO]];
    if (self.plans!=nil && self.plans.count>0) {
        DiscountPlan* plan=(DiscountPlan*)[self.plans firstObject];
        [self.lsPlan initData:plan.name withVal:plan._id];
    }else{
        [self.lsPlan initData:nil withVal:nil];
    }
    [self.lsRatio initData:@"100" withVal:@"100"];
    [self.rdoIsForce initShortData:0];
    [self modelVisibal];
}

-(void) fillModel
{
  
    [self.txtName initData:self.selObj.name];
    BOOL showDate=(self.selObj.isDate==1);
    BOOL showTime=(self.selObj.isTime==1);
    BOOL showWeek=([NSString isNotBlank:self.selObj.weekDay]);
    [self isShowDate:showDate];
    [self isShowTime:showTime];
    [self isShowWeek:showWeek];
    
    [self.rdoIsDate initData:showDate?@"1":@"0"];
    [self.rdoIsTime initData:showTime?@"1":@"0"];
    [self.rdoIsWeek initData:showWeek?@"1":@"0"];
    
    if (showDate) {
        if (self.selObj.startDate!=nil) {
            NSDate* startDate=[DateUtils DateWithString:self.selObj.startDate type:TDFFormatTimeTypeAllTimeString];
            NSString* startDate2=[DateUtils formatTimeWithDate:startDate type:TDFFormatTimeTypeYearMonthDay];
            [self.lsStartDate initData:startDate2 withVal:self.selObj.startDate];
        }else{
            [self.lsStartDate initData:nil withVal:nil];
        }
        
        if (self.selObj.endDate!=nil) {
            NSDate* endDate=[DateUtils DateWithString:self.selObj.endDate type:TDFFormatTimeTypeAllTimeString];
            NSString* endDate2=[DateUtils formatTimeWithDate:endDate type:TDFFormatTimeTypeYearMonthDay];
            [self.lsEndDate initData:endDate2 withVal:self.selObj.endDate];
        }else{
            [self.lsEndDate initData:nil withVal:nil];
        }
    }
    
    if (showTime) {
        NSString* startTime=[DateUtils formatTimeWithSecond:self.selObj.startTime];
        [self.lsStartTime initData:startTime withVal:[NSString stringWithFormat:@"%d",self.selObj.startTime]];
        
        NSString* endTime=[DateUtils formatTimeWithSecond:self.selObj.endTime];
        [self.lsEndTime initData:endTime withVal:[NSString stringWithFormat:@"%d",self.selObj.endTime]];
    }
    
    if (showWeek) {
        NSString* weekStr=self.selObj.weekDay;
        if ([NSString isBlank:weekStr]) {
            [self.mlsWeek initData:nil];
        }else{
            NSArray* arr=[weekStr componentsSeparatedByString:@","];
            NSMutableArray* list=[NSMutableArray array];
            NameItemVO* itemVO=nil;
            for (NSString* week in arr) {
                itemVO=[GlobalRender getItem:[GlobalRender listWeeks] withId:week];
                [list addObject:itemVO];
            }
            [self.mlsWeek initData:list];
        }
    }
    
    NSMutableArray* modeList=[SpecialRender listMode];
    NSString* mode=[NSString stringWithFormat:@"%d",self.selObj.specialKind ];
    [self.lsMode initData:[GlobalRender obtainItem:modeList itemId:mode] withVal:mode];
    
    [self.lsPlan initData:nil withVal:nil];
    if ([NSString isBlank:self.selObj.discountPlanId]) {
        if (self.plans!=nil && self.plans.count>0) {
            DiscountPlan* plan=(DiscountPlan*)[self.plans firstObject];
            [self.lsPlan initData:plan.name withVal:plan._id];
        }
    }else{
        [self.lsPlan initData:[GlobalRender obtainObjName:self.plans itemId:self.selObj.discountPlanId] withVal:self.selObj.discountPlanId];
    }
    NSString* ratioStr=[FormatUtil formatDouble4:self.selObj.ratio];
    [self.lsRatio initData:ratioStr withVal:ratioStr];
    [self modelVisibal];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SpecialEditView_Change];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SpecialEditView_Change object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFinsh:) name:REMOTE_SPECIALPLAN_LIST object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_SPECIAL_SAVE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_SPECIAL_UPDATE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFinish:) name:REMOTE_SPECIAL_DELONE object:nil];
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

-(void) loadFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
   
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSArray *list = [map objectForKey:@"discountPlans"];
    self.plans=[JsonHelper transList:list objName:@"DiscountPlan"];
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加优惠方案", nil);
        [self clearDo];
    }else{
        self.titleBox.lblTitle.text=self.selObj.name;
        [self fillModel];
    }
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
    [self.titleBox editTitle:NO act:self.action];
}

-(void)remoteFinsh:(RemoteResult*) result{
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
    [self loadData:nil action:ACTION_CONSTANTS_EDIT];
}

#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    [SystemUtil hideKeyboard];
    if(obj.tag==SPECIAL_MODE){
//        [OptionPickerBox initData:[SpecialRender listMode] itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[SpecialRender listMode]
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[SpecialRender listMode][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }else if(obj.tag==SPECIAL_STARTDATE || obj.tag==SPECIAL_ENDDATE){
    
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj];
    }else if(obj.tag==SPECIAL_STARTTIME || obj.tag==SPECIAL_ENDTIME){
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeTime editItem:obj];
    }else if(obj.tag==SPECIAL_RATIO){
        int ratio=100;
        if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
           ratio=[obj getStrVal].intValue;
        }
        [RatioPickerBox initData:ratio];
        [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if(obj.tag==SPECIAL_PLAN){
//        [OptionPickerBox initData:self.plans itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:self.plans
                                                                        currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:wself.plans[index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[obj getVal];
    if(obj.tag==SPECIAL_IS_DATE){
        [self isShowDate:result];
    }else if(obj.tag==SPECIAL_IS_TIME){
        [self isShowTime:result];
    }else if(obj.tag==SPECIAL_IS_WEEK){
        [self isShowWeek:result];
    }
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
}

//多选List控件变换.
-(void) onMultiItemListClick:(EditMultiList*)obj
{
     if (obj.tag==SPECIAL_WEEKS) {
         UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:obj.tag delegate:self title:NSLocalizedString(@"选择特定日期", nil) dataTemps:[GlobalRender listWeeks] selectList:[obj getCurrList]needHideOldNavigationBar:YES];
         [self.navigationController pushViewController:viewController animated:YES];
    }
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    if (event==SPECIAL_STARTDATE) {
        [self.lsStartDate changeData:dateStr withVal:dateStr] ;
    } else {
        [self.lsEndDate changeData:dateStr withVal:dateStr] ;
    }
    return YES;
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==SPECIAL_STARTTIME) {
        [self.lsStartTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    } else {
        [self.lsEndTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    }
    return YES;
}

#pragma 多选页结果处理.
-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
    if(event==SPECIAL_WEEKS){
        [self.mlsWeek changeData:items];
    }
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
}

-(void)closeMultiView:(NSInteger)event
{
}

-(BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==SPECIAL_MODE) {
         NameItemVO* vo=(NameItemVO*)selectObj;
        [self.lsMode changeData:vo.itemName withVal:vo.itemId];
        [self modelVisibal];
    } else if (event==SPECIAL_PLAN) {
         NameItemVO* vo=(NameItemVO*)selectObj;
        [self.lsPlan changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    } else {
        NSString* result=(NSString*)selectObj;
        [self.lsRatio changeData:result withVal:result];
    }
    [SpecialEditView refreshPos:self.container scrollview:self.scrollView];
    return YES;
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"优惠方案名称不能为空!", nil)];
        return NO;
    }
    BOOL isDate=[self.rdoIsDate getVal];
    BOOL isTime=[self.rdoIsTime getVal];
    
    if (isDate) {
        if ([NSString isBlank:[self.lsStartDate getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"请选择开始日期!", nil)];
            return NO;
        }
        if ([NSString isBlank:[self.lsEndDate getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"请选择结束日期!", nil)];
            return NO;
        }
    }
    
    if (isTime) {
        if ([NSString isBlank:[self.lsStartTime getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"请选择开始时间!", nil)];
            return NO;
        }
        if ([NSString isBlank:[self.lsEndTime getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"请选择结束时间!", nil)];
            return NO;
        }
    }
    
    int mode=[self.lsMode getStrVal].intValue;
    if (mode==SPECIAL_MODE_FIX_RATIO) {
        if ([NSString isBlank:[self.lsRatio getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"请选择折扣率(%)!", nil)];
            return NO;
        }
        if (![NSString isPositiveNum:[self.lsRatio getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"折扣率(%)不是数字!", nil)];
            return NO;
        }
    } else if (mode==SPECIAL_MODE_DICOUNT_RATIO){
        if ([NSString isBlank:[self.lsPlan getStrVal] ]) {
            [AlertBox show:NSLocalizedString(@"打折方案不能为空!", nil)];
            return NO;
        }
    }
    return YES;
}

-(Special*) transMode
{
    Special* tempUpdate=[Special new];
    tempUpdate.name=[self.txtName getStrVal];
    BOOL isDate=[self.rdoIsDate getVal];
    BOOL isTime=[self.rdoIsTime getVal];
    tempUpdate.isDate=isDate?1:0;
    tempUpdate.isTime=isTime?1:0;
    
    if (isDate) {
        if ([NSString isNotBlank:[self.lsStartDate getStrVal]]) {
            tempUpdate.startDate=[NSString stringWithFormat:@"%@ 00:00:00",[self.lsStartDate getStrVal]];
        }
        if ([NSString isNotBlank:[self.lsEndDate getStrVal]]) {
            tempUpdate.endDate=[NSString stringWithFormat:@"%@ 23:59:59",[self.lsEndDate getStrVal]];
        }
    }
    if (isTime) {
        if ([NSString isNotBlank:[self.lsStartTime getStrVal]]) {
            tempUpdate.startTime=[self.lsStartTime getStrVal].intValue;
        }
        if ([NSString isNotBlank:[self.lsEndTime getStrVal]]) {
            tempUpdate.endTime=[self.lsEndTime getStrVal].intValue;
        }
        
    }
    BOOL isWeek=[self.rdoIsWeek getVal];
    NSMutableArray* weeks=[self.mlsWeek getCurrList];
    if (isWeek && weeks && [weeks count]>0) {
        NSMutableArray* weekIds=[NSMutableArray array];
        for (id<INameItem> item in weeks) {
            [weekIds addObject:[item obtainItemId]];
        }
        tempUpdate.weekDay=[weekIds componentsJoinedByString:@","];
    }else{
        tempUpdate.weekDay=@"";
    }
    
    tempUpdate.ratio=100;
    int mode=[self.lsMode getStrVal].intValue;
    tempUpdate.specialKind=mode;
    if (mode==SPECIAL_MODE_FIX_RATIO) {
        tempUpdate.ratio=[self.lsRatio getStrVal].doubleValue;
        tempUpdate.isForceRatio=[self.rdoIsForce getVal]?1:0;
    }else if(mode==SPECIAL_MODE_DICOUNT_RATIO){
        tempUpdate.discountPlanId=[self.lsPlan getStrVal];
    }
    
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    Special* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@优惠方案", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
//        [service saveSpecial:objTemp event:REMOTE_SPECIAL_SAVE];
         [service saveSpecial:objTemp Target:self Callback:@selector(remoteFinsh:)];
      
    }else{
        objTemp._id=self.selObj._id;
//        [service updateSpecial:objTemp event:REMOTE_SPECIAL_UPDATE];
         [service updateSpecial:objTemp Target:self Callback:@selector(remoteFinsh:)];
    }
}

-(void)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.selObj.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.selObj.name]];
//        [service removeSpecial:self.selObj._id event:REMOTE_SPECIAL_DELONE];
          [service removeSpecial:self.selObj._id Target:self Callback:@selector(delFinish:)];
    }
}

#pragma data  UI visibal
-(void) modelVisibal
{
    int mode=[self.lsMode getStrVal].intValue;
    if (mode==SPECIAL_MODE_FIX_RATIO) {
        [self.lsRatio visibal:YES];
        [self.rdoIsForce visibal:YES];
        [self.lsPlan visibal:NO];
    }else if(mode==SPECIAL_MODE_DICOUNT_RATIO){
        [self.lsRatio visibal:NO];
        [self.rdoIsForce visibal:NO];
        [self.lsPlan visibal:YES];
    }else{
        [self.lsRatio visibal:NO];
        [self.rdoIsForce visibal:NO];
        [self.lsPlan visibal:NO];
    }
}

-(void) isShowDate:(BOOL)visibal
{
    [self.lsStartDate visibal:visibal];
    [self.lsEndDate visibal:visibal];
}

-(void) isShowTime:(BOOL)visibal
{
    [self.lsStartTime visibal:visibal];
    [self.lsEndTime visibal:visibal];
}

-(void) isShowWeek:(BOOL)visibal
{
    [self.mlsWeek visibal:visibal];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"reserveset"];
}

+ (void)refreshPos:(UIView*) container scrollview:(UIScrollView*) scrollView
{
    CGFloat height=0;
    id<ItemBase> base=nil;
    NSArray *subViews = container.subviews;
    for (UIView* view in subViews) {
        [view setTop:height];
        if (view.hidden == NO) {
            if ([view conformsToProtocol:@protocol(ItemBase)]) {
                base=(id<ItemBase>)view;
                height+=[base getHeight];
            }else{
                height+=view.height;
            }
        }
    }
    [container setNeedsDisplay];
    if (scrollView) {
        int contentHeight=SCREEN_HEIGHT+64;
        height=height>contentHeight?height:contentHeight;
        [container setHeight:(height+88+64)];
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, container.height);
    }
}

@end

