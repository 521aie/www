//
//  BusinessDetailView.m
//  RestApp
//
//  Created by zxh on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "JsonHelper.h"
#import "FormatUtil.h"
#import "NumberUtil.h"
#import "ObjectUtil.h"
#import "ColorHelper.h"
#import "ViewFactory.h"
#import "RemoteEvent.h"
#import "UIView+Sizes.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "DataSingleton.h"
#import "OrderItemCell.h"
#import "MBProgressHUD.h"
#import "BusinessDayVO.h"
#import "DayOrderBillVO.h"
#import "ServiceFactory.h"
#import "OptionPickerBox.h"
#import "BusinessService.h"
#import "SummaryOfMonthVO.h"
#import "OrderNullItemCell.h"
#import "BusinessDetailPanel.h"
#import "BusinessSummaryVO.h"
#import "NSString+Estimate.h"
#import "BusinessDetailView.h"
#import "BusinessPayDetailBox.h"
#import "KindPayDayStatMainVO.h"
#import "BusinessDetailPayHideBox.h"
#import "TDFMediator+HomeModule.h"
@implementation BusinessDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].businessService;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblTitle.text=NSLocalizedString(@"营业汇总", nil);
    [self.chartBox initDelegate:self];
    [self initNotifaction];
    [self.monthPanel setHidden:YES];
    self.monthArr=[[NSArray alloc] initWithObjects:NSLocalizedString(@"一", nil),NSLocalizedString(@"二", nil),NSLocalizedString(@"三", nil),NSLocalizedString(@"四", nil),NSLocalizedString(@"五", nil),NSLocalizedString(@"六", nil),NSLocalizedString(@"七", nil),NSLocalizedString(@"八", nil),NSLocalizedString(@"九", nil),NSLocalizedString(@"十", nil),NSLocalizedString(@"十一", nil),NSLocalizedString(@"十二", nil),nil];
    
    self.tabBox.layer.cornerRadius=5;
    self.tabBox.layer.masksToBounds=YES;
    self.tabBox.layer.borderWidth=1;
    self.tabBox.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    
    self.tabBox.layer.cornerRadius=5;
    self.tabBox.layer.masksToBounds=YES;
    self.tabBox.layer.borderWidth=1;
    self.tabBox.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    
    self.orderContainer.layer.cornerRadius=5;
    self.orderContainer.layer.masksToBounds=YES;
    self.lblTabLeft.text=NSLocalizedString(@"今天", nil);
    self.lblTabRight.text=NSLocalizedString(@"本月", nil);
    
    [self showMonthPanel:NO];
    [self loadData:self.currYear month:self.currMonth day:self.currDay];
}

- (void)showMonthPanel:(BOOL)isShow
{
    self.isShowMonth=isShow;
    self.imgMonthShow.image=(isShow?[UIImage imageNamed:@"ico_next_up_w.png"]:[UIImage imageNamed:@"ico_next_down_w.png"]);
    
    if (!isShow) {
        [self.orderContainer setHeight:40];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper clearColor:self.container];
        self.lblDayRight.text=NSLocalizedString(@"展开", nil);
    } else {
        self.lblDayRight.text=NSLocalizedString(@"收起", nil);
        //加载订单数据.
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%2ld-%2ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
        [self showProgressHudWithText:NSLocalizedString(@"请稍候", nil)];
        [service loadOrders:dateStr target:self callback:@selector(loadOrderFinish:)];
    }
}

//查询数据.
- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    self.realYear=[comps year];
    self.realMonth=[comps month];
    self.realDay=[comps day];
    
    [self.imgNext setHidden:(self.currMonth==self.realMonth)];
    [self.btnNext setHidden:(self.currMonth==self.realMonth)];
    
    [self.imgNextPay setHidden:(self.currMonth==self.realMonth)];
    [self.btnNextPay setHidden:(self.currMonth==self.realMonth)];
    [self.lblNextPay setHidden:(self.currMonth==self.realMonth)];
    if (self.realMonth>2) {
        [self.imgPre setHidden:((self.currMonth+2)==self.realMonth)];
        [self.btnPre setHidden:((self.currMonth+2)==self.realMonth)];
        
        [self.imgPrePay setHidden:((self.currMonth+2)==self.realMonth)];
        [self.btnPrePay setHidden:((self.currMonth+2)==self.realMonth)];
        [self.lblPrePay setHidden:((self.currMonth+2)==self.realMonth)];
    } else if (self.realMonth==1) {
        [self.imgPre setHidden:(self.currMonth==11)];
        [self.btnPre setHidden:(self.currMonth==11)];
        
        [self.imgPrePay setHidden:(self.currMonth==11)];
        [self.btnPrePay setHidden:(self.currMonth==11)];
        [self.lblPrePay setHidden:(self.currMonth==11)];
    } else if (self.realMonth==2) {
        [self.imgPre setHidden:(self.currMonth==12)];
        [self.btnPre setHidden:(self.currMonth==12)];
        
        [self.imgPrePay setHidden:(self.currMonth==12)];
        [self.btnPrePay setHidden:(self.currMonth==12)];
        [self.lblPrePay setHidden:(self.currMonth==12)];
    }
    self.lblMonthTitle.text=[NSString stringWithFormat:NSLocalizedString(@"%ld年%ld月", nil), (long)year, (long)month];
    [self showProgressHudWithText:NSLocalizedString(@"请稍候", nil)];
     [service loadMonthDays:year month:month target:self callback:@selector(businessFinish:)];
}

#pragma mark notification deal
- (void)initNotifaction
{

}

- (void)loadOrderFinish:(RemoteResult*)result{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary* map=[JsonHelper transMap:result.content];
    
    NSArray *orders = [map objectForKey:@"orderList"];
    self.datas=[JsonHelper transList:orders objName:@"DayOrderBillVO"];
    NSInteger gridHeight=44*([ObjectUtil isEmpty:self.datas]?1:self.datas.count);
    [self.orderTable setHeight:gridHeight];
    [self.orderContainer setHeight:(80+gridHeight+20)];
    [self.orderContainerBg setHeight:(80+gridHeight+20)];
    [self.orderTable reloadData];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)businessFinish:(RemoteResult*) result
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
    
    NSArray *days = [map objectForKey:@"dayVOs"];
    self.dayDatas=[JsonHelper transList:days objName:@"SummaryOfMonthVO"];
    self.dayDic=[NSMutableDictionary dictionary];
    BusinessDayVO* dayVO=nil;
    for (SummaryOfMonthVO* vo in self.dayDatas) {
        dayVO=[vo convertVO];
        [self.dayDic setObject:dayVO forKey:vo.period];
    }
    
    NSArray* payTemps=[map objectForKey:@"pays"];
    self.pays=[JsonHelper transList:payTemps objName:@"KindPayDayVO"];
    
    NSDictionary *monthDic=[map objectForKey:@"monthVO"];
    self.monthData=[JsonHelper dicTransObj:monthDic obj:[SummaryOfMonthVO alloc]];
    
    NSArray* kindPayDayStatMainVOs=[map objectForKey:@"kindPayDayStatMainVOs"];
    self.payDays=[JsonHelper transList:kindPayDayStatMainVOs objName:@"KindPayDayStatMainVO"];
    self.dayPayDic=[NSMutableDictionary dictionary];
    if (self.payDays!=nil && self.payDays.count>0) {
        for (KindPayDayStatMainVO* vo in self.payDays) {
            [self.dayPayDic setObject:vo forKey:vo.currDate];
        }
    }
    
    NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月收益(元)", nil), (long)self.currMonth];
    [self.detailBox loadData:title summary:[self.monthData convertVO]  pays:self.pays date:nil];
    [self.chartBox loadBusinessData:self.dayDic];
    [self.chartBox initChartView:self.currYear month:self.currMonth day:self.currDay];
    
    CGSize size = self.monthScrollView.size;
    size.height = self.detailBox.frame.size.height;
    [self.monthScrollView.layer setCornerRadius:5.0];
    [self.monthScrollView setContentSize:size];
}

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:@"%0.2f",value];
    }
    return @"-";
}

//chartBox 日期变化，
- (void)scrollviewDidChangeNumber
{
    NSInteger day=self.chartBox.currDay;
    self.currDay=day;
    
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    self.realYear=[comps year];
    self.realMonth=[comps month];
    self.realDay=[comps day];
    
    NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日收益(元)", nil), (long)self.currMonth, (long)day];
    NSString* dateKey=[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
    BusinessDayVO* vo=[self.dayDic objectForKey:dateKey];
    KindPayDayStatMainVO* payMain=[self.dayPayDic objectForKey:dateKey];
    [self.dayBox loadData:title summary:vo dayPay:payMain date:[NSString stringWithFormat:@"%ld",(long)day]];
    
    if (self.currYear==self.realYear && self.currMonth==self.realMonth) {
        self.lblTabRight.text=NSLocalizedString(@"本月", nil);
    } else {
        self.lblTabRight.text=[NSString stringWithFormat:NSLocalizedString(@"%@月", nil),[self.monthArr objectAtIndex:self.currMonth-1]];
    }
    
    if (self.currYear==self.realYear && self.currMonth==self.realMonth && self.currDay==self.realDay) {
        self.lblTabLeft.text=NSLocalizedString(@"今天", nil);
    } else {
        self.lblTabLeft.text=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日", nil), (long)self.currMonth, (long)self.currDay];
    }
    [self showMonthPanel:NO];
}

//返回事件.
- (IBAction)btnBackEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    NSString *dateStr = [item obtainItemId];
    NSArray *dates = [dateStr componentsSeparatedByString:@"-"];
    int year = ((NSString *)[dates objectAtIndex:0]).intValue;
    int month = ((NSString *)[dates objectAtIndex:1]).intValue;
    [self loadData:year month:month day:16];
    return YES;
}

- (IBAction)btnPreMonthEvent:(id)sender
{
    [self loadPrevMonthData];
}

- (IBAction)btnNextMonthEvent:(id)sender
{
    [self loadNextMonthData];
}

- (IBAction)btnMonthShowEvent:(id)sender
{
    [self showMonthPanel:!self.isShowMonth];
}

//tab月处理.
- (IBAction)btnTabMonthEvent:(id)sender
{
    [self.todayPanel setHidden:YES];
    [self.monthPanel setHidden:NO];
    [self.tabBg setLeft:154];
    self.lblTabLeft.textColor=[UIColor whiteColor];
    self.lblTabRight.textColor=[ColorHelper getRedColor];
}

//tab月处理.
- (IBAction)btnTabTodayEvent:(id)sender
{
    [self.todayPanel setHidden:NO];
    [self.monthPanel setHidden:YES];
    
    [self.tabBg setLeft:0];
    self.lblTabLeft.textColor=[ColorHelper getRedColor];
    self.lblTabRight.textColor=[UIColor whiteColor];
}

- (IBAction)btnPrevMonthPayEvent:(id)sender
{
    [self loadPrevMonthData];
}

- (IBAction)btnNextMonthPayEvent:(id)sender
{
    [self loadNextMonthData];
}

- (IBAction)btnPrintBillEvent:(id)sender
{
     NSString *printDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_PrintBillViewControllerWithDateStr:printDate];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadPrevMonthData
{
    NSInteger month=self.currMonth-1;
    self.currMonth=month==0?12:month;
    self.currYear=month==0?self.currYear-1:self.currYear;
    [self loadData:self.currYear month:self.currMonth day:1];
}

- (void)loadNextMonthData
{
    NSInteger month=self.currMonth+1;
    self.currMonth=month==13?1:month;
    self.currYear=month==13?self.currYear+1:self.currYear;
    [self loadData:self.currYear month:self.currMonth day:1];
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark table deal
-(void)initGrid
{
    self.orderTable.opaque=NO;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    [self.orderTable setTableFooterView:view];
    self.orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.datas.count == 0 ? 1 :self.datas.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        OrderItemCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderItemCellIndentifier];
        if (!cell) {
            cell = (OrderItemCell *)[[NSBundle mainBundle] loadNibNamed:@"OrderItemCell" owner:self options:nil].lastObject;
        }
        DayOrderBillVO* item=(DayOrderBillVO*)[self.datas objectAtIndex: indexPath.row];
        cell.img.hidden=(item.status==4);
        cell.lblTime.text=item.openShortTime;
        if (cell.img.hidden == YES) {
            cell.lblSeatName.text=[NSString isBlank:item.seatName]?[NSString stringWithFormat:@"No.%@",item.orderCode]:item.seatName;
            cell.lblFee.text=[FormatUtil formatDouble2:item.recieveAmount];
        } else {
            cell.lblSeatName.text=[NSString isBlank:item.seatName]?[NSString stringWithFormat:NSLocalizedString(@"No.%@(未结账)", nil),item.orderCode]:[NSString stringWithFormat:NSLocalizedString(@"%@(未结账)", nil),item.seatName];
            cell.lblFee.text=@"0";
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    OrderNullItemCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderNullItemCellIndentifier];
    if (!cell) {
        cell = (OrderNullItemCell *)[[NSBundle mainBundle] loadNibNamed:@"OrderNullItemCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count) {
        [self.orderTable reloadData];
    } else {
        id<INameValueItem> item=(id<INameValueItem>)[self.datas objectAtIndex: row];
        [self showEditNVItemEvent:@"order_item" withObj:item];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    DayOrderBillVO *item=(DayOrderBillVO *)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_orderDetailViewControllerWithOrderID:item.orderId andTotalPayID:item.totalPayId eventType:0];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showMoveIn:(UIView*)view
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect mainContainerFrame = view.frame;
    CGRect viewFrame = self.view.frame;
    view.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    view.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height - mainContainerFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    [UIView commitAnimations];
}

@end
