//
//  FeePlanEditViewViewController.m
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FeePlanEditView.h"
#import "SettingService.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditMultiList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "XHAnimalUtil.h"
#import "EditItemRadio.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "Area.h"
#import "RemoteResult.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "FeePlan.h"
#import "AreaFeePlan.h"
#import "TDFOptionPickerController.h"
#import "MultiCheckView.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "NavigateTitle2.h"
#import "NSString+Estimate.h"
#import "FormatUtil.h"
#import "FeePlanRender.h"
#import "DateUtils.h"
#import "RatioPickerBox.h"
#import "TDFSettingService.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFSeatService.h"
#import "UIViewController+Picker.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFRootViewController+FooterButton.h"

@implementation FeePlanEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    service=[ServiceFactory Instance].settingService;
    self.changed=NO;
    self.needHideOldNavigationBar = YES;
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData:self.feePlan action:self.action];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _container.backgroundColor = [UIColor clearColor];
         [_container addSubview:self.baseTitle];
          [_container addSubview:self.txtName];
        [_container addSubview:self.mlsArea];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
        [_container addSubview:view];
        [_container addSubview:self.titleFee];
        [_container addSubview:self.rdoIsServiceFee];
        [_container addSubview:self.lsServiceFeeMode];
        [_container addSubview:self.lsServiceFee];
        [_container addSubview:self.txtMinute];
        [_container addSubview:self.rdoIsMinFee];
        [_container addSubview:self.lsMinFeeMode];
        [_container addSubview:self.lsMinFee];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
        [_container addSubview:view1];
        [_container addSubview:self.titleValid];
        [_container addSubview:self.rdoIsDate];
        [_container addSubview:self.lsStartDate];
        [_container addSubview:self.lsEndDate];
        [_container addSubview:self.rdoIsTime];
        [_container addSubview:self.lsStartTime];
        [_container addSubview:self.lsEndTime];
        [_container addSubview:self.rdoIsWeek];
        [_container addSubview:self.mlsWeek];
        
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

- (EditMultiList *) mlsArea
{
    if (!_mlsArea) {
        _mlsArea = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 48)];
    }
    return _mlsArea;
}

- (ItemTitle *) titleFee
{
    if (!_titleFee) {
        _titleFee = [[ItemTitle alloc] initWithFrame:CGRectMake(0,96, SCREEN_WIDTH, 60)];
        [_titleFee awakeFromNib];
    }
    return _titleFee;
}

- (EditItemRadio *) rdoIsServiceFee
{
    if (!_rdoIsServiceFee) {
        _rdoIsServiceFee = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 48)];
    }
    return _rdoIsServiceFee;
}

- (EditItemList *) lsServiceFeeMode
{
    if (!_lsServiceFeeMode) {
        _lsServiceFeeMode = [[EditItemList alloc] initWithFrame:CGRectMake(0, 192, SCREEN_WIDTH, 48)];
    }
    return _lsServiceFeeMode;
}

- (EditItemList *) lsServiceFee
{
    if (!_lsServiceFee) {
        _lsServiceFee = [[EditItemList alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 48)];
    }
    return _lsServiceFee;
}

- (EditItemText *) txtMinute
{
    if (!_txtMinute) {
        _txtMinute = [[EditItemText alloc] initWithFrame:CGRectMake(0, 252, SCREEN_WIDTH , 48)];
    }
    return _txtMinute;
}

- (EditItemRadio *) rdoIsMinFee
{
    if (!_rdoIsMinFee) {
        _rdoIsMinFee = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 288, SCREEN_WIDTH, 48)];
    }
    return _rdoIsMinFee;
}

- (EditItemList *) lsMinFeeMode
{
    if (!_lsMinFeeMode) {
        _lsMinFeeMode = [[EditItemList alloc] initWithFrame:CGRectMake(0, 336, SCREEN_WIDTH, 48)];
    }
    return _lsMinFeeMode;
}

- (EditItemList *) lsMinFee
{
    if (!_lsMinFee) {
        _lsMinFee = [[EditItemList alloc] initWithFrame:CGRectMake(0, 384, SCREEN_WIDTH, 0)];
    }
    return _lsMinFee;
}

- (ItemTitle *) titleValid
{
    if (!_titleValid) {
        _titleValid = [[ItemTitle alloc] initWithFrame:CGRectMake(0,432, SCREEN_WIDTH, 60)];
        [_titleValid awakeFromNib];
    }
    return _titleValid;
}

- (EditItemRadio *) rdoIsDate
{
    if (!_rdoIsDate) {
        _rdoIsDate = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 480, SCREEN_WIDTH, 48)];
    }
    return _rdoIsDate;
}

- (EditItemList *) lsStartDate
{
    if (!_lsStartDate) {
        _lsStartDate = [[EditItemList alloc] initWithFrame:CGRectMake(0, 528, SCREEN_WIDTH, 48)];
    }
    return _lsStartDate;
}

- (EditItemList *) lsEndDate
{
    if (!_lsEndDate) {
        _lsEndDate = [[EditItemList alloc] initWithFrame:CGRectMake(0, 576, SCREEN_WIDTH, 48)];
    }
    return _lsEndDate;
}

- (EditItemRadio *) rdoIsTime
{
    if (!_rdoIsTime) {
        _rdoIsTime = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 624, SCREEN_WIDTH, 48)];
    }
    return _rdoIsTime;
}

- (EditItemList *) lsStartTime
{
    if (!_lsStartTime) {
        _lsStartTime = [[EditItemList alloc] initWithFrame:CGRectMake(0, 672, SCREEN_WIDTH, 48)];
    }
    return _lsStartTime;
}

- (EditItemList *) lsEndTime
{
    if (!_lsEndTime) {
        _lsEndTime = [[EditItemList alloc] initWithFrame:CGRectMake(0, 720, SCREEN_WIDTH, 48)];
    }
    return _lsEndTime;
}

- (EditItemRadio *) rdoIsWeek
{
    if (!_rdoIsWeek) {
        _rdoIsWeek = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 767, SCREEN_WIDTH, 48)];
    }
    return _rdoIsWeek;
}

- (EditMultiList *) mlsWeek
{
    if (!_mlsWeek) {
        _mlsWeek = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 815, SCREEN_WIDTH, 48)];
    }
    return _mlsWeek;
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"附加费", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.txtName initLabel:NSLocalizedString(@"附加费名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.mlsArea initLabel:NSLocalizedString(@"收费区域", nil) delegate:self];
    
    self.titleFee.lblName.text=NSLocalizedString(@"费用设置", nil);
    [self.rdoIsServiceFee initLabel:NSLocalizedString(@"收取服务费", nil) withHit:nil delegate:self];
    [self.lsServiceFeeMode initLabel:NSLocalizedString(@"▪︎ 计费标准", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsServiceFee initLabel:NSLocalizedString(@"▪︎ 费用(元/桌)", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtMinute initLabel:NSLocalizedString(@"▪︎ 时长(分钟)", nil) withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    
    [self.rdoIsMinFee initLabel:NSLocalizedString(@"设定最低消费", nil) withHit:nil delegate:self];
    [self.lsMinFeeMode initLabel:NSLocalizedString(@"▪︎ 计费标准", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsMinFee initLabel:NSLocalizedString(@"▪︎ 费用(元)", nil) withHit:nil isrequest:YES delegate:self];
    
    self.titleValid.lblName.text=NSLocalizedString(@"有效期设置", nil);
    [self.rdoIsDate initLabel:NSLocalizedString(@"在指定日期内有效", nil) withHit:nil delegate:self];
    [self.lsStartDate initLabel:NSLocalizedString(@"▪︎ 开始日期", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"▪︎ 结束日期", nil) withHit:nil delegate:self];
    
    [self.rdoIsTime initLabel:NSLocalizedString(@"在指定时间有效", nil) withHit:nil delegate:self];
    [self.lsStartTime initLabel:NSLocalizedString(@"▪︎ 开始时间", nil) withHit:nil delegate:self];
    [self.lsEndTime initLabel:NSLocalizedString(@"▪︎ 结束时间", nil) withHit:nil delegate:self];
    
    [self.rdoIsWeek initLabel:NSLocalizedString(@"在每周特定日期有效", nil) withHit:nil delegate:self];
    [self.mlsWeek initLabel:NSLocalizedString(@"▪︎ 日期", nil) delegate:self];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.mlsArea.tag=FEEPLAN_AREA;
    self.rdoIsServiceFee.tag=FEEPLAN_IS_SERVICEMODE;
    self.lsServiceFeeMode.tag=FEEPLAN_SERVICEMODE_CALBASE;
    self.lsServiceFee.tag=FEEPLAN_SERVICEFEE;
    self.lsMinFee.tag=FEEPLAN_MINFEE;
    self.rdoIsMinFee.tag=FEEPLAN_IS_MINFEE;
    self.lsMinFeeMode.tag=FEEPLAN_MINFEE_MODE;
    self.rdoIsDate.tag=FEEPLAN_IS_DATE;
    self.lsStartDate.tag=FEEPLAN_STARTDATE;
    self.lsEndDate.tag=FEEPLAN_ENDDATE;
    self.rdoIsTime.tag=FEEPLAN_IS_TIME;
    self.lsStartTime.tag=FEEPLAN_STARTTIME;
    self.lsEndTime.tag=FEEPLAN_ENDTIME;
    self.rdoIsWeek.tag=FEEPLAN_IS_WEEK;
    self.mlsWeek.tag=FEEPLAN_WEEKS;
    
    [self.lsMinFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
-(void) loadData:(FeePlan*) tempVO action:(int)action
{
    self.areas=nil;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加附加费", nil);
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else {
        self.title=tempVO.name;
        [self loadAreaFee];
    }
    [self.titleBox editTitle:NO act:self.action];
}

-(void) loadAreaFee
{

    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listAreaFeePlanId:self.feePlan._id sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        NSArray *list = [data objectForKey:@"data"];
        self.areaFeePlans=[JsonHelper transList:list objName:@"AreaFeePlan"];
        [self fillModel];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    [self.mlsArea initData:nil];
    
    NameItemVO* vo=[[FeePlanRender listServiceFeeMode] firstObject];
    [self.lsServiceFeeMode initData:vo.itemName withVal:vo.itemId];
    [self.lsServiceFee initData:nil withVal:nil];
    int calBase=[self.lsServiceFeeMode getStrVal].intValue;
    NSString* unit=[NSString stringWithFormat:NSLocalizedString(@"▪︎ 费用(%@)", nil),[FeePlanRender obtainServiceFeeUnit:calBase]];
    self.lsServiceFee.lblName.text=unit;
    
    NameItemVO* minVo=[[FeePlanRender listMinFeeMode] firstObject];
    [self.lsMinFeeMode initData:minVo.itemName withVal:minVo.itemId];
    [self.lsMinFee initData:nil withVal:nil];
    
    [self.lsStartDate initData:nil withVal:nil];
    [self.lsEndDate initData:nil withVal:nil];
    [self.lsStartTime initData:nil withVal:nil];
    [self.lsEndTime initData:nil withVal:nil];
    [self.mlsWeek initData:nil];
    
    [self.rdoIsServiceFee initData:@"0"];
    [self isShowServicefee:NO];
    
    [self.rdoIsMinFee initData:@"0"];
    [self isShowMinFee:NO];
    [self initDateComp];
}

-(void) fillModel
{
    [self.txtName initData:self.feePlan.name];
    //服务费的相关业务处理
    BOOL serviceFeeVisibal=(self.feePlan.calBase!=0);
    [self.rdoIsServiceFee initData:serviceFeeVisibal?@"1":@"0"];
    if (serviceFeeVisibal) {
        if (self.feePlan.calBase==0) {
            [self.lsServiceFeeMode initData:NSLocalizedString(@"待设", nil) withVal:@"0"];
        } else {
            NSString* serviceFeeModeStr=[NSString stringWithFormat:@"%d",self.feePlan.calBase];
            [self.lsServiceFeeMode initData:[GlobalRender obtainItem:[FeePlanRender listServiceFeeMode] itemId:serviceFeeModeStr]withVal:serviceFeeModeStr];
            NSString* feeStr=[FormatUtil formatDouble3:self.feePlan.fee];
            [self.lsServiceFee initData:feeStr withVal:feeStr];
        }
        [self.txtMinute initData:[NSString stringWithFormat:@"%d",self.feePlan.standard]];
    }
    
    [self isShowServicefee:serviceFeeVisibal];
    //最低消费的相关业务处理.
    BOOL minFeeVisibal=(self.feePlan.minConsumeKind!=0);
    [self.rdoIsMinFee initData:minFeeVisibal?@"1":@"0"];
    if (minFeeVisibal) {
        NSString* minFeeModeStr=[NSString stringWithFormat:@"%d",self.feePlan.minConsumeKind];
        [self.lsMinFeeMode initData:[GlobalRender obtainItem:[FeePlanRender listMinFeeMode] itemId:minFeeModeStr] withVal:minFeeModeStr];
        NSString* minFeeStr=[FormatUtil formatDouble3:self.feePlan.minConsume];
        [self.lsMinFee initData:minFeeStr withVal:minFeeStr];
    }
    [self isShowMinFee:minFeeVisibal];
    
    [self initDateComp];
    
    //附加费详细内容.
    [self.mlsArea initData:self.areaFeePlans];
    if (self.areaFeePlans==nil || [self.areaFeePlans count]==0) {
        return;
    }
    AreaFeePlan* areaFeePlan=(AreaFeePlan*)[self.areaFeePlans firstObject];
    [self fillDetail:areaFeePlan];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillDetail:(AreaFeePlan*)areaFeePlan
{
    BOOL showDate=(areaFeePlan.isDate==1);
    BOOL showTime=(areaFeePlan.isTime==1);
    BOOL showWeek=([NSString isNotBlank:areaFeePlan.weekDay]);
    [self isShowDate:showDate];
    [self isShowTime:showTime];
    [self isShowWeek:showWeek];
    
    [self.rdoIsDate initData:showDate?@"1":@"0"];
    [self.rdoIsTime initData:showTime?@"1":@"0"];
    [self.rdoIsWeek initData:showWeek?@"1":@"0"];
    
    if (showDate) {
        if (areaFeePlan.startDate!=nil) {
            NSDate* startDate=[DateUtils DateWithString:areaFeePlan.startDateStr type:TDFFormatTimeTypeAllTimeString];
            NSString* startDate2=[DateUtils formatTimeWithDate:startDate type:TDFFormatTimeTypeYearMonthDay];
            [self.lsStartDate initData:startDate2 withVal:areaFeePlan.startDateStr];
        } else {
            [self.lsStartDate initData:nil withVal:nil];
        }
        
        if (areaFeePlan.endDate!=nil) {
            NSDate* endDate=[DateUtils DateWithString:areaFeePlan.endDateStr type:TDFFormatTimeTypeAllTimeString];
            NSString* endDate2=[DateUtils formatTimeWithDate:endDate type:TDFFormatTimeTypeYearMonthDay];
            [self.lsEndDate initData:endDate2 withVal:areaFeePlan.endDateStr];
        } else {
            [self.lsEndDate initData:nil withVal:nil];
        }
    }
    
    if (showTime) {
        NSString* startTime=[DateUtils formatTimeWithSecond:areaFeePlan.startTime];
        [self.lsStartTime initData:startTime withVal:[NSString stringWithFormat:@"%d",areaFeePlan.startTime]];
        
        NSString* endTime=[DateUtils formatTimeWithSecond:areaFeePlan.endTime];
        [self.lsEndTime initData:endTime withVal:[NSString stringWithFormat:@"%d",areaFeePlan.endTime]];
    }
    
    if (showWeek) {
        NSString* weekStr=areaFeePlan.weekDay;
        if ([NSString isBlank:weekStr]) {
            [self.mlsWeek initData:nil];
        } else {
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
}
#pragma ui 元素变化 处理.

-(void) isShowServicefee:(BOOL)visibal
{
    if (!visibal) {
        [self.lsServiceFee visibal:NO];
        [self.lsServiceFeeMode visibal:NO];
        [self.txtMinute visibal:NO];
        return;
    }
    
    [self.lsServiceFeeMode visibal:YES];
    [self.lsServiceFee visibal:YES];
    [self.txtMinute visibal:NO];
    
    if ([NSString isNotBlank:[self.lsServiceFeeMode getStrVal]]) {
        int calBase=[self.lsServiceFeeMode getStrVal].intValue;
        
        NSString* unit=[NSString stringWithFormat:NSLocalizedString(@"▪︎ 费用(%@)", nil),[FeePlanRender obtainServiceFeeUnit:calBase]];
        self.lsServiceFee.lblName.text=unit;
        [self.lsServiceFeeMode initHit:nil];
        if (calBase==CAL_BASE_TIME) {
            [self.txtMinute visibal:YES];
            [self.lsServiceFeeMode initHit:NSLocalizedString(@"例如：费用输入100，分钟数输入60。意思是每小时收取100元服务费，不足1小时的按1小时算.", nil)];
        }
        if (calBase==CAL_BASE_PER_MENU) {
            [self.lsServiceFee visibal:NO];
            [self.lsServiceFeeMode initHit:NSLocalizedString(@"您可以在商品模块中，为每个商品设置不同的服务费.", nil)];
        }
        return;
    }
}

-(void) isShowMinFee:(BOOL)visibal
{
    [self.lsMinFeeMode visibal:visibal];
    [self.lsMinFee visibal:visibal];
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

-(void) initDateComp
{
    [self.rdoIsDate initData:@"0"];
    [self isShowDate:NO];
    
    [self.rdoIsTime initData:@"0"];
    [self isShowTime:NO];
    
    [self.rdoIsWeek initData:@"0"];
    [self isShowWeek:NO];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_FeePlanEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_FeePlanEditView_Change object:nil];
    
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
    }else{
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

-(void)loadAreaFinshError:(NSError *)error obj:(id)obj
{
    [self.progressHud hide:YES];
    
    if (error) {
        [AlertBox show:[error localizedDescription]];
        return;
    }
    
    self.areas = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Area class] json:obj[@"data"]]];
    if (self.areas==nil) {
        self.areas=[NSMutableArray array];
    }
    
    for (Area *areaFeePlan in self.areas) {
        if ([areaFeePlan._id isEqualToString:@"1"]) {
            areaFeePlan._id = @"-1";
        }
    }
    
    [self showAllAreas];
}

- (void)remoteLoadAreas:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"areas"];
    self.areas=[JsonHelper transList:list objName:@"Area"];
    if (self.areas==nil) {
        self.areas=[NSMutableArray array];
    }
    
    for (Area *areaFeePlan in self.areas) {
        if ([areaFeePlan._id isEqualToString:@"1"]) {
            areaFeePlan._id = @"-1";
        }
    }
    
    [self showAllAreas];
}

-(void) remoteLoadData:(NSString *) responseStr
{
    NSDictionary* map=[JsonHelper transMap:responseStr];
    NSArray *list = [map objectForKey:@"areaFeePlans"];
    self.areaFeePlans=[JsonHelper transList:list objName:@"AreaFeePlan"];
    [self fillModel];
}


#pragma test event
#pragma edititemlist click event.
//List控件变换.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj.tag==FEEPLAN_SERVICEMODE_CALBASE) {
        //        [OptionPickerBox initData:[FeePlanRender listServiceFeeMode] itemId:[obj getStrVal]];
        //        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[FeePlanRender listServiceFeeMode]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[FeePlanRender listServiceFeeMode][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else if (obj.tag==FEEPLAN_MINFEE_MODE) {
        //        [OptionPickerBox initData:[FeePlanRender listMinFeeMode] itemId:[obj getStrVal]];
        //        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[FeePlanRender listMinFeeMode]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[FeePlanRender listMinFeeMode][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==FEEPLAN_STARTDATE || obj.tag==FEEPLAN_ENDDATE) {
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj];
    } else if (obj.tag==FEEPLAN_STARTTIME || obj.tag==FEEPLAN_ENDTIME) {
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeTime editItem:obj];
    } else if (obj.tag==FEEPLAN_SERVICEFEE) {
        if ([NSString isBlank:[self.lsServiceFeeMode getStrVal]]) {
            
            return;
        }
        int calBase=[self.lsServiceFeeMode getStrVal].intValue;
        if (calBase==CAL_BASE_AMOUNT) {
            int ratio=100;
            if ([NSString isNotBlank:[obj getStrVal]]) {
                ratio=[obj getStrVal].intValue;
            }
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
        } else {
            [self.lsServiceFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsServiceFee.lblVal becomeFirstResponder];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsServiceFee.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
#pragma clang diagnostic pop
        }
    }
}

//多选List控件变换.
-(void) onMultiItemListClick:(EditMultiList *)obj
{
    if (obj.tag==FEEPLAN_AREA) {
        if (self.areas==nil) {
            [self showProgressHudWithText:NSLocalizedString(@"正在加载区域", nil)];
            
            __weak __typeof(self) wself = self;
            [[[TDFSeatService alloc] init] areasWithSaleOutFlag:@"true" sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                
                [wself loadAreaFinshError:nil obj:data];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                [wself loadAreaFinshError:error obj:nil];
            }];
        } else {
            [self showAllAreas];
        }
    } else if (obj.tag==FEEPLAN_WEEKS) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:obj.tag delegate:self title:NSLocalizedString(@"选择特定日期", nil) dataTemps:[GlobalRender listWeeks] selectList:[obj getCurrList] needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) showAllAreas
{
    NSMutableArray* arr=[self.mlsArea getCurrList];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:self.mlsArea.tag delegate:self title:NSLocalizedString(@"选择区域", nil) dataTemps:self.areas selectList:arr needHideOldNavigationBar:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
    if (obj.tag==FEEPLAN_IS_SERVICEMODE) {
        [self isShowServicefee:result];
    } else if (obj.tag==FEEPLAN_IS_MINFEE) {
        [self isShowMinFee:result];
    } else if (obj.tag==FEEPLAN_IS_DATE) {
        [self isShowDate:result];
    } else if (obj.tag==FEEPLAN_IS_TIME) {
        [self isShowTime:result];
    } else if (obj.tag==FEEPLAN_IS_WEEK) {
        [self isShowWeek:result];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)temp event:(NSInteger)event
{
    if (event==FEEPLAN_SERVICEMODE_CALBASE) {
        id<INameItem> item=(id<INameItem>)temp;
        [self.lsServiceFeeMode changeData:[item obtainItemName] withVal:[item obtainItemId]];
        BOOL serviceFeeVisibal=([NSString isNotBlank:[self.rdoIsServiceFee getStrVal]] && [[self.rdoIsServiceFee getStrVal] isEqualToString:@"1"]);
        [self isShowServicefee:serviceFeeVisibal];
        [self.lsServiceFee changeData:nil withVal:nil];
    } else if (event==FEEPLAN_MINFEE_MODE) {
        id<INameItem> item=(id<INameItem>)temp;
        [self.lsMinFeeMode changeData:[item obtainItemName] withVal:[item obtainItemId]];
        BOOL minFeeVisibal=([NSString isNotBlank:[self.rdoIsMinFee getStrVal]] && [[self.rdoIsMinFee getStrVal] isEqualToString:@"1"]);
        [self isShowMinFee:minFeeVisibal];
    } else {
        NSString* result=(NSString*)temp;
        [self.lsServiceFee changeData:result withVal:result];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma 多选页结果处理.
- (void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
    if (event==FEEPLAN_AREA) {
        [self.mlsArea changeData:items];
        
    } else if (event==FEEPLAN_WEEKS) {
        [self.mlsWeek changeData:items];
    }
    if ([UIHelper currChange:self.container] || self.action == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:@"取消"];
        [self configRightNavigationBar:Head_ICON_PUBLISH rightButtonName:@"保存"];
    } else{
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:@"返回"];
        UIButton *rightButton = self.navigationItem.rightBarButtonItem.customView;
        [rightButton setHidden:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)closeMultiView:(NSInteger)event
{
    
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==FEEPLAN_STARTTIME) {
        [self.lsStartTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    } else {
        [self.lsEndTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld",(long)[DateUtils getMinuteOfDate:date]]] ;
    }
    return YES;
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==FEEPLAN_MINFEE) {
        [self.lsMinFee changeData:val withVal:val];
    } else {
        [self.lsServiceFee changeData:val withVal:val];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    if (event==FEEPLAN_STARTDATE) {
        [self.lsStartDate changeData:dateStr withVal:datsFullStr] ;
    } else {
        [self.lsEndDate changeData:dateStr withVal:datsFullStr] ;
    }
    return YES;
}

#pragma save-data

-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"附加费名称不能为空!", nil)];
        return NO;
    }
    NSMutableArray* items=[self.mlsArea getCurrList];
    if (items==nil || [items count]==0) {
        [AlertBox show:NSLocalizedString(@"附加费区域不能为空!", nil)];
        return NO;
    }
    
    if ([self.rdoIsServiceFee getVal]) {
        if ([NSString isBlank:[self.lsServiceFeeMode getStrVal]] || [self.lsServiceFeeMode getStrVal].intValue==0) {
            [AlertBox show:NSLocalizedString(@"请选择服务费的计费标准", nil)];
            return NO;
        }
        int calBase=[self.lsServiceFeeMode getStrVal].intValue;
        if (calBase!=CAL_BASE_PER_MENU) {
            if ([NSString isBlank:[self.lsServiceFee getStrVal]]) {
                [AlertBox show:NSLocalizedString(@"服务费的费用不能为空!", nil)];
                return NO;
            }
            
            if (![NSString isFloat:[self.lsServiceFee getStrVal]]) {
                [AlertBox show:NSLocalizedString(@"服务费的费用不是数字!", nil)];
                return NO;
            }
        }
        if (calBase==CAL_BASE_TIME) {
            if ([NSString isBlank:[self.txtMinute getStrVal]]) {
                [AlertBox show:NSLocalizedString(@"服务费的分钟数不能为空!", nil)];
                return NO;
            }
        }
    }
    
    if ([self.rdoIsMinFee getVal]) {
        if ([NSString isBlank:[self.lsMinFeeMode getStrVal]] || [self.lsMinFeeMode getStrVal].intValue==0) {
            [AlertBox show:NSLocalizedString(@"最低消费的计费标准不能为空!", nil)];
            return NO;
        }
        if ([NSString isBlank:[self.lsMinFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"最低消费的费用不能为空!", nil)];
            return NO;
        }
        if (![NSString isFloat:[self.lsMinFee getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"最低消费的费用不是数字!", nil)];
            return NO;
        }
    }
    return YES;
}

-(FeePlan*) transMode
{
    FeePlan* tempUpdate=[FeePlan new];
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.calBase=0;
    tempUpdate.standard=60;
    tempUpdate.fee=0;
    if ([self.rdoIsServiceFee getVal]) {
        tempUpdate.calBase=[self.lsServiceFeeMode getStrVal].intValue;
        if (tempUpdate.calBase==CAL_BASE_TIME) {
            tempUpdate.standard=[self.txtMinute getStrVal].intValue;
        }
        if (tempUpdate.calBase!=CAL_BASE_PER_MENU) {
            tempUpdate.fee=[self.lsServiceFee getStrVal].doubleValue;
        }
    }
    tempUpdate.minConsume=0;
    tempUpdate.minConsumeKind=0;
    if ([self.rdoIsMinFee getVal]) {
        tempUpdate.minConsume=[self.lsMinFee getStrVal].doubleValue;
        tempUpdate.minConsumeKind=[self.lsMinFeeMode getStrVal].intValue;
    }
    return tempUpdate;
}

-(AreaFeePlan*) transAreaFeePlan
{
    AreaFeePlan* plan=[AreaFeePlan new];
    BOOL isDate=[self.rdoIsDate getVal];
    BOOL isTime=[self.rdoIsTime getVal];
    plan.isDate=isDate?1:0;
    plan.isTime=isTime?1:0;
    
    if (isDate) {
        if ([NSString isNotBlank:[self.lsStartDate getStrVal]]) {
            plan.startDate=[self.lsStartDate getStrVal];
        }
        if ([NSString isNotBlank:[self.lsEndDate getStrVal]]) {
            plan.endDate=[self.lsEndDate getStrVal];
        }
    }
    if (isTime) {
        if ([NSString isNotBlank:[self.lsStartTime getStrVal]]) {
            plan.startTime=[self.lsStartTime getStrVal].intValue;
        }
        if ([NSString isNotBlank:[self.lsEndTime getStrVal]]) {
            plan.endTime=[self.lsEndTime getStrVal].intValue;
        }
        
    }
    BOOL isWeek=[self.rdoIsWeek getVal];
    if (!isWeek) {
        plan.weekDay=@"";
        return plan;
    }
    NSMutableArray* weeks=[self.mlsWeek getCurrList];
    if (weeks && [weeks count]>0) {
        NSMutableArray* weekIds=[NSMutableArray array];
        for (id<INameItem> item in weeks) {
            [weekIds addObject:[item obtainItemId]];
        }
        plan.weekDay=[weekIds componentsJoinedByString:@","];
    }else{
        plan.weekDay=@"";
    }
    return plan;
}

-(NSMutableArray*) obtainAreaIds
{
    NSMutableArray* arrIds=[NSMutableArray array];
    NSMutableArray* items=[self.mlsArea getCurrList];
    if (items!=nil && [items count]>0) {
        for (id<INameItem> item in items) {
            [arrIds addObject:[item obtainItemId]];
        }
    }
    return arrIds;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    FeePlan* objTemp=[self transMode];
    NSMutableArray* areaIds=[self obtainAreaIds];
    AreaFeePlan* areaTemp=[self transAreaFeePlan];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@附加费", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [[TDFSettingService new] saveFeePlan:objTemp ids:areaIds area:areaTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else {
        objTemp.id  = self.feePlan._id;
        [[TDFSettingService new] updateFeePlan:objTemp ids:areaIds area:areaTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.feePlan.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {

        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.feePlan.name]];
        [[TDFSettingService new] removeFeePlan:self.feePlan._id sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"feeplan"];
}
@end
