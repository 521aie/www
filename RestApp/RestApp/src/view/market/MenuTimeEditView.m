//
//  MenuTimeEditView.m
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuTimeEditView.h"
#import "SettingModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "MenuTimeModuleEvent.h"
#import "EditItemList.h"
#import "EditMultiList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditItemRadio.h"
#import "MenuTimeListView.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"

#import "AlertBox.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "MenuTime.h"
#import "SingleCheckView.h"
#import "MultiCheckView.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "NavigateTitle2.h"
#import "NSString+Estimate.h"
#import "FormatUtil.h"
#import "DateUtils.h"
#import "YYModel.h"
#import "TimePickerBox.h"
#import "DatePickerBox.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "NumberUtil.h"
#import "TDFOptionPickerController.h"
#import "MenuTimeRender.h"
#import "FormatUtil.h"
#import "EditItemView.h"
#import "EditItemInfo.h"
#import "TDFDatePickerController.h"
#import "UIViewController+Picker.h"
#import "TDFMediator+SupplyChain.h"
#import "TDFMemberService.h"
#import "TDFRootViewController+FooterButton.h"


@implementation MenuTimeEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    self.changed=NO;
    
    [self layoutViews];
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData:self.menuTime action:self.action];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (void)layoutViews {
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    [self.view addSubview:bg];

    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container];
    [self.container addSubview:self.baseTitle];
    [self.container addSubview:self.txtName];
    [self.container addSubview:self.lsPerferential];
    [self.container addSubview:self.lblPerferentialName];
    [self.container addSubview:self.lsDiscount];
    [self.container addSubview:self.rdoIsRatio];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 247, SCREEN_WIDTH, 20)];
    [self.container addSubview:view];
    [self.container addSubview:self.titleValid];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 109, SCREEN_WIDTH, 80)];
    [self.container addSubview:view1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 79)];
    label.text = NSLocalizedString(@"注：\n有效时间如果不设置表示长期有效。\n在同一段时期内只能有一种促销生效，如果一段时期内设置了多种促销方案，那么收银和点菜设备上开单之后会从中随机选一种。", nil);
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 79, SCREEN_WIDTH, 1)];
    label1.backgroundColor = [UIColor lightGrayColor];
    [view1 addSubview:label];
    [view1 addSubview:label1];
    [self.container addSubview:self.rdoIsDate];
    [self.container addSubview:self.lsStartDate];
    [self.container addSubview:self.lsEndDate];
    [self.container addSubview:self.rdoIsTime];
    [self.container addSubview:self.lsStartTime];
    [self.container addSubview:self.lsEndTime];
    [self.container addSubview:self.rdoIsWeek];
    [self.container addSubview:self.mlsWeek];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(10, 9, SCREEN_WIDTH-20, 44)];
    [self.container addSubview:view2];
    [view2 addSubview:self.btnDel];
    
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}

- (UIScrollView *)scrollView {

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _scrollView;
}

- (UIView *)container {

    if (!_container) {
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 513)];
    }
    return _container;
}

- (ItemTitle *)baseTitle {

    if (!_baseTitle) {
        _baseTitle = [[ItemTitle alloc]initWithFrame:CGRectMake(0, 227, SCREEN_WIDTH, 60)];
        [_baseTitle awakeFromNib];
    }
    return _baseTitle;
}

- (EditItemText *)txtName {

    if (!_txtName) {
        _txtName = [[EditItemText alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _txtName;
}

- (EditItemList *)lsPerferential {

    if (!_lsPerferential) {
        _lsPerferential = [[EditItemList alloc]initWithFrame:CGRectMake(0, 233, SCREEN_WIDTH, 48)];
    }
    return _lsPerferential;
}

- (EditItemView *)lblPerferentialName {

    if (!_lblPerferentialName) {
        _lblPerferentialName = [[EditItemView alloc]initWithFrame:CGRectMake(0, 233, SCREEN_WIDTH, 48)];
    }
    return _lblPerferentialName;
}

- (EditItemList *)lsDiscount {

    if (!_lsDiscount) {
        _lsDiscount = [[EditItemList alloc]initWithFrame:CGRectMake(0, 233, SCREEN_WIDTH, 48)];
    }
    return _lsDiscount;
}

- (EditItemRadio *)rdoIsRatio {

    if (!_rdoIsRatio) {
        _rdoIsRatio = [[EditItemRadio alloc]initWithFrame:CGRectMake(0, 233, SCREEN_WIDTH, 48)];
    }
    return _rdoIsRatio;
}

- (ItemTitle *)titleValid {

    if (!_titleValid) {
        _titleValid = [[ItemTitle alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 60)];
        [_titleValid awakeFromNib];
    }
    return _titleValid;
}

- (EditItemRadio *)rdoIsDate {

    if (!_rdoIsDate) {
        _rdoIsDate = [[EditItemRadio alloc]initWithFrame:CGRectMake(0, 189, SCREEN_WIDTH, 48)];
    }
    return _rdoIsDate;
}

- (EditItemList *)lsStartDate {

    if (!_lsStartDate) {
        _lsStartDate = [[EditItemList alloc]initWithFrame:CGRectMake(0, 238, SCREEN_WIDTH, 48)];
    }
    return _lsStartDate;
}

- (EditItemList *)lsEndDate {

    if (!_lsEndDate) {
        _lsEndDate = [[EditItemList alloc]initWithFrame:CGRectMake(0, 288, SCREEN_WIDTH, 48)];
    }
    return _lsEndDate;
}

- (EditItemRadio *)rdoIsTime {

    if (!_rdoIsTime) {
        _rdoIsTime = [[EditItemRadio alloc]initWithFrame:CGRectMake(0, 338, SCREEN_WIDTH, 48)];
    }
    return _rdoIsTime;
}

- (EditItemList *)lsStartTime {

    if (!_lsStartTime) {
        _lsStartTime = [[EditItemList alloc]initWithFrame:CGRectMake(0, 387, SCREEN_WIDTH, 48)];
    }
    return _lsStartTime;
}

- (EditItemList *)lsEndTime {

    if (!_lsEndTime) {
        _lsEndTime = [[EditItemList alloc]initWithFrame:CGRectMake(0, 435, SCREEN_WIDTH, 48)];
    }
    return _lsEndTime;
}

- (EditItemRadio *)rdoIsWeek {

    if (!_rdoIsWeek) {
        _rdoIsWeek = [[EditItemRadio alloc]initWithFrame:CGRectMake(0, 484, SCREEN_WIDTH, 48)];
    }
    return _rdoIsWeek;
}

- (EditMultiList *)mlsWeek {

    if (!_mlsWeek) {
        _mlsWeek = [[EditMultiList alloc]initWithFrame:CGRectMake(0, 534, SCREEN_WIDTH, 48)];
    }
    return _mlsWeek;
}

- (UIButton *)btnDel {

    if (!_btnDel) {
        _btnDel = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH - 20, 44)];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}



#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"商品促销", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
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
    [self.txtName initLabel:NSLocalizedString(@"促销名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsPerferential initLabel:NSLocalizedString(@"优惠方式", nil) withHit:NSLocalizedString(@"注：优惠方式确定后，收银和点菜设备会显示优惠后价格，并且自动按照优惠价格结算", nil) delegate:self];
    [self.lblPerferentialName initLabel:NSLocalizedString(@"优惠方式", nil) withHit:nil];
    [self.lsDiscount initLabel:NSLocalizedString(@"折扣率(%)", nil) withHit:nil delegate:self];
    [self.rdoIsRatio initLabel:NSLocalizedString(@"促销商品允许参加其他打折活动", nil) withHit:nil delegate:self];
    self.titleValid.lblName.text=NSLocalizedString(@"有效期设置", nil);
    [self.rdoIsDate initLabel:NSLocalizedString(@"在指定日期内有效", nil) withHit:nil delegate:self];
    [self.lsStartDate initLabel:NSLocalizedString(@"▪︎ 开始日期", nil) withHit:nil delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"▪︎ 结束日期", nil) withHit:nil delegate:self];
    
    [self.rdoIsTime initLabel:NSLocalizedString(@"在指定时间有效", nil) withHit:nil delegate:self];
    [self.lsStartTime initLabel:NSLocalizedString(@"▪︎ 开始时间", nil) withHit:nil delegate:self];
    [self.lsEndTime initLabel:NSLocalizedString(@"▪︎ 结束时间", nil) withHit:nil delegate:self];
    
    [self.rdoIsWeek initLabel:NSLocalizedString(@"在每周特定日期有效", nil) withHit:nil delegate:self];
    [self.mlsWeek initLabel:NSLocalizedString(@"▪︎ 日期", nil) delegate:self];
    
    [self.footView initDelegate:self btnArrs:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.rdoIsDate.tag=MENUTIME_IS_DATE;
    self.lsStartDate.tag=MENUTIME_STARTDATE;
    self.lsEndDate.tag=MENUTIME_ENDDATE;
    self.rdoIsTime.tag=MENUTIME_IS_TIME;
    self.lsStartTime.tag=MENUTIME_STARTTIME;
    self.lsEndTime.tag=MENUTIME_ENDTIME;
    self.rdoIsWeek.tag=MENUTIME_IS_WEEK;
    self.mlsWeek.tag=MENUTIME_WEEKS;
    self.lsPerferential.tag=MENUTIME_PERFERENTIAL;
    self.lsDiscount.tag=MENUTIME_DISCOUNT;
    self.rdoIsRatio.tag=MENUTIME_IS_RATIO;
    
    [self.lsDiscount setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma remote
- (void)loadData:(MenuTime *)tempVO action:(NSInteger)action
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加商品促销", nil);
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else {
        [self fillModel];
        self.title=tempVO.name;
    }
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
    
    [self initDateComp];
    [self.lsPerferential initData:NSLocalizedString(@"促销价", nil) withVal:@"1"];
    [self.lblPerferentialName visibal:NO];
    [self.lsPerferential visibal:YES];
    [self.lsDiscount initData:@"100" withVal:@"100"];
    [self.lsStartDate initData:nil withVal:nil];
    [self.lsEndDate initData:nil withVal:nil];
    [self.lsStartTime initData:nil withVal:nil];
    [self.lsEndTime initData:nil withVal:nil];
    [self.mlsWeek initData:nil];
}

-(void) fillModel
{
    [self.lsPerferential visibal:NO];
    [self.txtName initData:self.menuTime.name];
    [self.lsDiscount initData:[NSString stringWithFormat:@"%@",[FormatUtil formatDouble3:self.menuTime.ratio]] withVal:[NSString stringWithFormat:@"%@",[FormatUtil formatDouble3:self.menuTime.ratio]]];
    if (self.menuTime.mode == 2) {
        [self isShowDiscount:YES];
        [self.lblPerferentialName visibal:YES];
        [self.lblPerferentialName initLabel:NSLocalizedString(@"优惠方式", nil) withHit:nil];
        [self.lblPerferentialName initData:NSLocalizedString(@"打折", nil) withVal:@"2"];
    } else {
        [self isShowDiscount:NO];
        [self.lblPerferentialName visibal:YES];
        [self.lblPerferentialName initLabel:NSLocalizedString(@"优惠方式", nil) withHit:nil];
        [self.lblPerferentialName initData:NSLocalizedString(@"促销价", nil) withVal:@"1"];
    }
    
    [self fillDetail:self.menuTime];
    [self.rdoIsRatio initShortData:self.menuTime.isRatio];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillDetail:(MenuTime*)menuTime
{
    BOOL showDate=(menuTime.isDate==1);
    BOOL showTime=(menuTime.isTime==1);
    BOOL showWeek=([NSString isNotBlank:menuTime.weekDay]);
    [self isShowDate:showDate];
    [self isShowTime:showTime];
    [self isShowWeek:showWeek];
    
    [self.rdoIsDate initData:showDate?@"1":@"0"];
    [self.rdoIsTime initData:showTime?@"1":@"0"];
    [self.rdoIsWeek initData:showWeek?@"1":@"0"];
    
    if (showDate) {
        if (menuTime.startDate!=nil) {
            NSString* startDate2=[DateUtils formatTimeWithTimestamp:menuTime.startDate.integerValue type:TDFFormatTimeTypeYearMonthDay];
            [self.lsStartDate initData:startDate2 withVal:menuTime.startDate];
        } else {
            [self.lsStartDate initData:nil withVal:nil];
        }
        if (menuTime.endDate!=nil) {
            NSString* endDate2=[DateUtils formatTimeWithTimestamp:menuTime.endDate.integerValue type:TDFFormatTimeTypeYearMonthDay];
            [self.lsEndDate initData:endDate2 withVal:menuTime.endDate];
        } else {
            [self.lsEndDate initData:nil withVal:nil];
        }
    }
    
    if (showTime) {
        NSString* startTime=[DateUtils formatTimeWithSecond:menuTime.starttime];
        [self.lsStartTime initData:startTime withVal:[NSString stringWithFormat:@"%d",menuTime.starttime]];
        
        NSString* endTime=[DateUtils formatTimeWithSecond:menuTime.endtime];
        [self.lsEndTime initData:endTime withVal:[NSString stringWithFormat:@"%d",menuTime.endtime]];
    }
    
    if (showWeek) {
        NSString* weekStr=menuTime.weekDay;
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

- (void)isShowDiscount:(BOOL)visibal
{
    [self.lsDiscount visibal:visibal];
}

-(void) initDateComp
{
    [self.rdoIsDate initData:@"0"];
    [self isShowDate:NO];
    
    [self.rdoIsTime initData:@"0"];
    [self isShowTime:NO];
    
    [self.rdoIsWeek initData:@"0"];
    [self isShowWeek:NO];
    
    [self.rdoIsRatio initData:@"1"];
    [self isShowDiscount:NO];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MenuTimeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MenuTimeEditView_Change object:nil];

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

#pragma test event
#pragma edititemlist click event.
//List控件变换.
-(void) onItemListClick:(EditItemList*)obj{
    
    if (obj.tag==MENUTIME_STARTDATE) {
    
        [self showDatePickerWithTitle:NSLocalizedString(@"开始时间", nil) mode:UIDatePickerModeDate editItem:obj];
    } else if (obj.tag==MENUTIME_ENDDATE) {
        
        [self showDatePickerWithTitle:NSLocalizedString(@"结束时间", nil) mode:UIDatePickerModeDate editItem:obj];
    } else if (obj.tag==MENUTIME_STARTTIME || obj.tag==MENUTIME_ENDTIME) {
        NSString* title=obj.tag==MENUTIME_STARTTIME?NSLocalizedString(@"开始时间", nil):NSLocalizedString(@"结束时间", nil);
        [self showDatePickerWithTitle:title mode:UIDatePickerModeTime editItem:obj];
    } else if (obj.tag == MENUTIME_PERFERENTIAL) {
        TDFOptionPickerController *vc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                     options:[MenuTimeRender listPerferential]
                                                                               currentItemId:[obj getStrVal]];
        
        __weak __typeof(self) wself = self;
        vc.competionBlock = ^void(NSInteger index) {
            [wself pickOption:[MenuTimeRender listPerferential][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
    }
}

- (void) clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==MENUTIME_DISCOUNT){
        if ([val isEqualToString:@""]) {
            [self.lsDiscount changeData:@"" withVal:@""];
        } else {
            [self.lsDiscount changeData:[NSString stringWithFormat:@"%@",val] withVal:val];
        }
    }
}

-(BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO* vo=(NameItemVO*)item;
    if (event==MENUTIME_PERFERENTIAL) {
        [self.lsPerferential changeData:vo.itemName withVal:vo.itemId];
        if ([vo.itemId isEqualToString:@"2"]) {
            [self isShowDiscount:YES];
            self.menuTime.mode = 2;
        } else {
            [self isShowDiscount:NO];
            self.menuTime.mode = 1;
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

//多选List控件变换.
-(void) onMultiItemListClick:(EditMultiList*)obj
{
    if (obj.tag==MENUTIME_WEEKS) {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_multiCheckViewController:obj.tag delegate:self title:NSLocalizedString(@"选择特定日期", nil) dataTemps:[GlobalRender listWeeks] selectList:[obj getCurrList] needHideOldNavigationBar:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//Radio控件变换.
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
    if (obj.tag==MENUTIME_IS_DATE) {
        [self isShowDate:result];
    } else if (obj.tag==MENUTIME_IS_TIME) {
        [self isShowTime:result];
    } else if (obj.tag==MENUTIME_IS_WEEK) {
        [self isShowWeek:result];
    } else if (obj.tag==MENUTIME_IS_RATIO) {
        [self.rdoIsRatio changeData:[obj getStrVal]];
    }

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma 变动的结果.

#pragma 多选页结果处理.
-(void)multiCheck:(NSInteger)event items:(NSMutableArray*) items
{
    if (event==MENUTIME_WEEKS) {
        [self.mlsWeek changeData:items];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void)closeMultiView:(NSInteger)event
{
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    if (event==MENUTIME_STARTTIME) {
        [self.lsStartTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld", (long)[DateUtils getMinuteOfDate:date]]];
    } else {
        [self.lsEndTime changeData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeHourAndMinute] withVal:[NSString stringWithFormat:@"%ld", (long)[DateUtils getMinuteOfDate:date]]] ;
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    if (event==MENUTIME_STARTDATE) {
        [self.lsStartDate changeData:dateStr withVal:datsFullStr] ;
    } else {
        [self.lsEndDate changeData:dateStr withVal:datsFullStr] ;
    }
    return YES;
}

#pragma save-data

-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"促销商品名称不能为空!", nil)];
        return NO;
    }
    
    if ([@"2" isEqualToString:[self.lsPerferential getStrVal]]) {
        double ratio = [[self.lsDiscount getStrVal] doubleValue];
        if ([NumberUtil isZero:ratio]) {
            [AlertBox show:NSLocalizedString(@"折扣率不能为零!", nil)];
            return NO;
        }
    }
    
    return YES;
}

-(MenuTime*) transMode
{
    MenuTime* tempUpdate=[MenuTime new];
    tempUpdate.entityId = self.menuTime.entityId;
    tempUpdate.count =self.menuTime.count;
    tempUpdate.name=[self.txtName getStrVal];
    BOOL isDate=[self.rdoIsDate getVal];
    BOOL isTime=[self.rdoIsTime getVal];
    tempUpdate.isDate=isDate?1:0;
    tempUpdate.isTime=isTime?1:0;
    tempUpdate.mode = (self.action==ACTION_CONSTANTS_ADD?[[self.lsPerferential getStrVal] intValue]:self.menuTime.mode);
    if (tempUpdate.mode==1) {
        tempUpdate.ratio = 100;
    } else {
        tempUpdate.ratio = [[self.lsDiscount getStrVal] doubleValue];
    }
    tempUpdate.isRatio = [self.rdoIsRatio getVal]?1:0;
    
    if (isDate) {
        if ([NSString isNotBlank:[self.lsStartDate getStrVal]]) {
            tempUpdate.startDate=[self.lsStartDate getStrVal];
        }
        if ([NSString isNotBlank:[self.lsEndDate getStrVal]]) {
            tempUpdate.endDate=[self.lsEndDate getStrVal];
        }
    }
    if (isTime) {
        if ([NSString isNotBlank:[self.lsStartTime getStrVal]]) {
            tempUpdate.starttime=[self.lsStartTime getStrVal].intValue;
        }
        if ([NSString isNotBlank:[self.lsEndTime getStrVal]]) {
            tempUpdate.endtime=[self.lsEndTime getStrVal].intValue;
        }
    }
    BOOL isWeek=[self.rdoIsWeek getVal];
    tempUpdate.isWeek = isWeek;
    if (!isWeek) {
        tempUpdate.weekDay=@"";
        return tempUpdate;
    }
    NSMutableArray* weeks=[self.mlsWeek getCurrList];
    if (weeks && [weeks count]>0) {
        NSMutableArray* weekIds=[NSMutableArray array];
        for (id<INameItem> item in weeks) {
            [weekIds addObject:[item obtainItemId]];
        }
        tempUpdate.weekDay=[weekIds componentsJoinedByString:@","];
    } else {
        tempUpdate.weekDay=@"";
    }
    return tempUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    MenuTime* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@商品促销", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"menu_time_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFMemberService new] saveMenuTimeWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else {
        objTemp.id=self.menuTime.id;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"menu_time_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFMemberService new] updateMenuTimeWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.menuTime.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.menuTime.name]];
//        [service removeMenuTime:self.menuTime._id target:self callback:@selector(delFinish:)];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"id"] = self.menuTime._id;
        @weakify(self);
        [[TDFMemberService new] removeMenuTimeWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.callBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"menutime"];
}

@end
