//
//   
//  RestApp
//
//  Created by iOS香肠 on 16/1/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "AlertBox.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "DateModel.h"
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
#import "OrderDetailView.h"
#import "OrderDetailView.h"
#import "BusinessService.h"
#import "SummaryOfMonthVO.h"
#import "OrderNullItemCell.h"
#import "BusinessDetailPanel.h"
#import "BusinessSummaryVO.h"
#import "NSString+Estimate.h"
#import "BusinessPayDetailBox.h"
#import "KindPayDayStatMainVO.h"
#import "BusinessDetailPayHideBox.h"
#import "ChainBusinessDetailView.h"
#import "BusinessStatisticsVo.h"
#import "BusinessStatisticsVoList.h"
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>
#import "TDFMediator+HomeModule.h"

typedef NS_ENUM(NSInteger, TDFChangeDateType) {
    TDFChangeDateTypeDay,
    TDFChangeDateTypeMonth
};

@interface ChainBusinessDetailView ()

@end

@implementation ChainBusinessDetailView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        service =[ServiceFactory Instance].businessService;
        self.dateArry =[[NSMutableArray alloc]init];
        self.busStatisArr =[[NSMutableDictionary alloc]init];
        self.totalDays  =[[NSMutableArray alloc]init];
        self.totalHeight =[[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.lblTitle.text=NSLocalizedString(@"总部营业汇总", nil);
    [self initMainView];
    [self  initializeArry];
    [self.monthPanel setHidden:YES];
    self.monthArr=[[NSArray alloc] initWithObjects:NSLocalizedString(@"一", nil),NSLocalizedString(@"二", nil),NSLocalizedString(@"三", nil),NSLocalizedString(@"四", nil),NSLocalizedString(@"五", nil),NSLocalizedString(@"六", nil),NSLocalizedString(@"七", nil),NSLocalizedString(@"八", nil),NSLocalizedString(@"九", nil),NSLocalizedString(@"十", nil),NSLocalizedString(@"十一", nil),NSLocalizedString(@"十二", nil),nil];
    self.isfirst=NO;
    self.tabBox.layer.cornerRadius=5;
    self.tabBox.layer.masksToBounds=YES;
    self.tabBox.layer.borderWidth=1;
    self.tabBox.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    
    self.tabBox.layer.cornerRadius=5;
    self.tabBox.layer.masksToBounds=YES;
    self.tabBox.layer.borderWidth=1;
    self.tabBox.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    self.lblTabLeft.text=NSLocalizedString(@"昨天", nil);
    self.lblTabRight.text=NSLocalizedString(@"本月", nil);
    
    self.detaiBusBtn.layer.cornerRadius=5;
    self.detaiBusBtn.layer.masksToBounds=YES;
    self.detaiBusBtn.layer.borderWidth=1;
    self.detaiBusBtn.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    
    [self showMonthPanel:NO];
    [self loadData:self.currYear month:self.currMonth day:self.currDay Ids:self.idsArr];
}

- (void)initializeArry
{
//    service =[ServiceFactory Instance].businessService;
    self.dateArry =[[NSMutableArray alloc]init];
    self.busStatisArr =[[NSMutableDictionary alloc]init];
    self.totalDays  =[[NSMutableArray alloc]init];
    self.totalHeight =[[NSMutableDictionary alloc]init];
}

- (void) initMainView
{
    [self.view addSubview:self.tabBox];
    
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(6, 108, SCREEN_WIDTH - 12, 1)];
    topline.backgroundColor = [UIColor whiteColor];
    topline.alpha = 0.3;
    [self.view addSubview:topline];
    
    [self.view addSubview:self.monthPanel];
    [self.view addSubview:self.todayPanel];
}

- (void)showMonthPanel:(BOOL)isShow
{
    self.isShowMonth=isShow;
    if (!isShow) {
        self.scrollView.bounces =NO;
        [UIHelper clearColor:self.container];
        [self.seleceterView setTop:self.chartBox.frame.size.height+self.chartBox.frame.origin.y];
        [self.branchView setTop:self.seleceterView.frame.size.height+self.seleceterView.frame.origin.y+40];
        [self.dayBox setTop:self.branchView.frame.size.height + self.branchView.frame.origin.y-20];
        self.scrollView .contentSize =CGSizeMake(SCREEN_WIDTH, self.dayBox .frame.origin.y +self.dayBox.frame.size.height +300);
    }
}
- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day Ids:(NSMutableArray *)arry
{
    self.lblDetaiTitle.text =[NSString stringWithFormat:@"%@",[[Platform Instance]getkey:SHOP_NAME ]];
    self.pageMonth =0;
    self.page=0;
    self.monthcurrMonth =month;
    self.monthcurrYear =year;
    self.monthcurrDay =day;
    self.currYear=year;
    self.currMonth=month;
    self.currDay=day;
    self.idsArr =arry;
    self.lblTabLeft.text=NSLocalizedString(@"昨天", nil);
    self.lblTabRight.text=NSLocalizedString(@"本月", nil);
    if (!self.isShowButton) {
        
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
    }
    [self loadDayPlane];
}

-(void)getChainBisiness:(NSDictionary *)dic
{
    [self.dateArry removeAllObjects];
    [self.busStatisArr removeAllObjects];
    [self.totalHeight removeAllObjects];
    self.payalldata2 =[[NSMutableDictionary alloc]init];
    NSArray *data = dic[@"data"];
    if([ObjectUtil isEmpty:data]){
        data = [[NSArray alloc]init];
    }
    for (NSInteger i=0; i<data.count;  i++) {
        NSDictionary *vo =data[i];
        if (self.isShowButton) {
            NSString *datastr =vo[@"businessMonth"];
            [self.dateArry addObject:datastr];
        }
        else
        {
         NSString *datastr =vo[@"businessDate"];
         [self.dateArry addObject:datastr];
        }
        NSDictionary *businessVO =vo[@"businessStatisticsVo"];
        BusinessStatisticsVo *busElment =[[BusinessStatisticsVo alloc]init];
        //kvc赋值
        [busElment setValuesForKeysWithDictionary:businessVO];
        if (self.isShowButton) {
            NSString *str =[busElment.orderMonth substringFromIndex:busElment.orderMonth.length-2];
            NSString *strkey =[NSString stringWithFormat:@"%ld",str.integerValue];
            [self.busStatisArr setObject:busElment forKey:strkey];
            [self.totalHeight setObject:[NSString stringWithFormat:@"%f",busElment.actualAmount] forKey:strkey];
        }
        else
        {
        NSString *str =[busElment.orderDate substringFromIndex:busElment.orderDate.length-2];
        NSString *strkey =[NSString stringWithFormat:@"%ld",str.integerValue];
        [self.busStatisArr setObject:busElment forKey:strkey];
        [self.totalHeight setObject:[NSString stringWithFormat:@"%f",busElment.actualAmount] forKey:strkey];
        }
        NSArray *arry =vo[@"paymentStatisticsVoList"];
        
        if ([ObjectUtil isNotEmpty:arry]) {
            if (self.isShowButton) {
                 NSString *datastr =vo[@"businessMonth"];
                NSString *str =[datastr substringFromIndex:datastr.length-2];
                NSString *str2 =[NSString stringWithFormat:@"%ld",str.integerValue];
                NSLog(@"Str2:%@",str2);
                [self.payalldata2 setObject:arry forKey:str2];
            }
            else
            {
                NSString *datastr =vo[@"businessDate"];
                NSString *str1 =[datastr substringFromIndex:datastr.length-2];
                NSString *str2 =[NSString stringWithFormat:@"%ld",str1.integerValue];
                [self.payalldata2 setObject:arry forKey:str2];
            }
        }
       
    }
    BusinessStatisticsVo *shopvo =[self.busStatisArr objectForKey:[NSString stringWithFormat:@"%d",(int)self.currDay]];
    self.shopcount =shopvo.shopCount;
    if (self.isShowButton) {
        [self.totalDays removeAllObjects];
        
        NSDate *date =[NSDate date];
        NSDate *date1 =[DateModel dateByModifiyingDate:date withModifier:@"- 11 month"];
        for (NSInteger i=0; i<12; i++) {
            NSDate *demoDate = [DateModel dateByModifiyingDate:date1 withModifier:[NSString stringWithFormat:@"+ %d month",(int)i]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM"];
            NSInteger todayStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:demoDate]].integerValue;
            NSString *str =[NSString stringWithFormat:@"%d",(int)todayStr];
            [self.totalDays addObject:str];
           
            
        }
        [self initViewpage:self.monthcurrMonth];
        self.monthScrollView.bounces =NO;
        self.monthScrollView.directionalLockEnabled =YES;
        self.monthScrollView.contentSize =CGSizeMake(320,self.detailBox.frame.origin.y+ self.detailBox.frame.size.height +188);
        [self.monthScrollView.layer setCornerRadius:5.0];
        [self.branchSelectView iniithit:NSLocalizedString(@"门店营业额对比", nil) img:@"ico_next_w.png"];
        self.branchSelectView.lblTitle.text =[NSString stringWithFormat:NSLocalizedString(@"%d月 门店营业额对比", nil),(int)self.monthcurrMonth];
    }
    else
    {
    [self.totalDays removeAllObjects];
    if (self.dayChartBox) {
        [self.dayChartBox removeFromSuperview];
    }
    self.dayChartBox = [[SNChart alloc] initWithFrame:CGRectMake(0, 0, self.chartBox.frame.size.width, 180) withDataSource:self andChatStyle:SNChartStyleBar];
    [self.dayChartBox initStartPage:self.currDay locaiton:4  TheChartBarStart:1];
    [self.dayChartBox DrawChartBarStart:15 chartBarTheXAxisSpan:25 kBarWidth:3];
    [self.dayChartBox initSize:13 widelength:20];
    NSDate *date =[self convertDate:self.currDay];
    NSInteger maxday=[self getDaysOfMonth:date];
    for (NSInteger i=1; i<=maxday; i++) {
        [self.totalDays addObject:[NSString stringWithFormat:@"%ld",i]];
    }
   [self.dayChartBox showInView:self.chartBox];
   [self.branchView setTop:self.chartBox.frame.size.height+self.chartBox.frame.origin.y+40];
    self.detailSelectLbl.text =[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日 门店营业额对比", nil),(long)self.currMonth,(long)self.currDay];
    }

}

#pragma mark notification deal

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:@"%0.2f",value];
    }
    return @"-";
}



- (void)detailSelectBtn:(id)sender {
    
    if (self.currDay<self.page) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日还没有营业数据", nil),(long)self.currMonth,self.page]];
    }
    else
    {
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_branchBusinessDayViewControllerWithYear:self.currYear month:self.currMonth day:self.page andEventType:0];
        [self.navigationController pushViewController:viewController animated:YES];
        
//        [self.navigationController pushViewController:[[TDFMediator sharedInstance] TDFMediator_TDFSubShopCompareControllerWithParam:nil ] animated:YES];
    }
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
    [self loadData:year month:month day:16 Ids:nil];
    return YES;
}

- (void)btnPreMonthEvent:(id)sender
{
    [self loadPrevMonthData];
}

- (void)btnNextMonthEvent:(id)sender
{
    [self loadNextMonthData];
}


//tab月处理.
- (void)btnTabMonthEvent:(id)sender
{
    [self.todayPanel setHidden:YES];
    [self.monthPanel setHidden:NO];
    self.isShowButton =YES;
    [self isHide:YES];
    [self.tabBg setLeft:(SCREEN_WIDTH - 16)/2+2];
    self.lblTabLeft.textColor=[UIColor whiteColor];
    self.lblTabRight.textColor=[ColorHelper getRedColor];
    NSString *str =[NSString stringWithFormat:@"%ld%02ld",(long)self.monthcurrYear,self.monthcurrMonth];
    NSLog(@"%@",str);
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFChainService alloc] init] getBusinessStatisticsByPeriodMonthWithParam:@{@"month":str,@"period":@"12"} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self getChainBisiness:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
    [self reloadTitle];
}

- (void) loadDayPlane
{
    [self.todayPanel setHidden:NO];
    [self.monthPanel setHidden:YES];
    self.isShowButton =NO;
    [self.tabBg setLeft:0];
    self.lblTabLeft.textColor=[ColorHelper getRedColor];
    self.lblTabRight.textColor=[UIColor whiteColor];
    NSString *str =[NSString stringWithFormat:@"%ld%02ld",(long)self.currYear,self.currMonth];
  
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFChainService alloc] init] getBusinessStatisticsByMonthlyEverydayWithParam:@{@"month":str} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self getChainBisiness:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

    [self reloadTitle];
   
}

-(void)reloadTitle
{
    self.lblTabLeft.text=NSLocalizedString(@"昨天", nil);
    self.lblTabRight.text=NSLocalizedString(@"本月", nil);
}
//tab日处理.
- (void)btnTabTodayEvent:(id)sender
{
     [self loadDayPlane];
}
- (void)initViewpage:(NSInteger)page
{
    NSInteger j=0;
    for (NSInteger i=0; i<self.totalDays.count; i++) {
        NSInteger getpage =[NSString stringWithFormat:@"%@",self.totalDays[i]].integerValue;
        if (page == getpage) {
            j=i;
        }
        
    }
    j=j+1;
    
    if (self.monthChartBox) {
        [self.monthChartBox removeFromSuperview];
    }
    self.monthChartBox = [[SNChart alloc] initWithFrame:CGRectMake(0, 0, self.monthPanel.frame.size.width, 180) withDataSource:self andChatStyle:SNChartStyleBar];
    [self.monthChartBox initStartPage:j locaiton:2  TheChartBarStart:3];
    [self.monthChartBox DrawChartBarStart:10 chartBarTheXAxisSpan:24 kBarWidth:6];
    [self.monthChartBox initSize:13 widelength:20];
    [self.monthChartBox showInView:self.monthScrollView];
    self.branchSelectView.delegate =self;
    [self.branchSelectView setTop:self.monthChartBox.frame.size.height+self.monthChartBox.frame.origin.y];
    [self.detailBox setTop:self.branchSelectView.frame.size.height +self.branchSelectView.frame.origin.y +10];
    
}
//柱状图协议
- (NSArray *)chatConfigYValue:(SNChart *)chart {
    
    NSMutableArray *arry =[[NSMutableArray alloc]init];
    NSMutableArray *arry1 =[[NSMutableArray alloc]init];
    if (self.isShowButton) {
        for (NSInteger i=0; i<self.totalDays.count; i++) {
            NSString *str =[NSString stringWithFormat:@"%@",self.totalDays[i]];
            if (self.totalHeight[str]) {
                
                [arry addObject:self.totalHeight[str]];
            }
            else
            {
                [arry addObject:@"0"];
            }
        }
        float max = [[arry valueForKeyPath:@"@max.floatValue"] floatValue];
        for (NSString *str in arry) {
            [arry1 addObject:[NSString stringWithFormat:@"%f",str.floatValue/max]];
        }
        NSLog(@"%@ %@",self.totalHeight,self.totalDays);
    }
    else
    {
    for (NSInteger i=1; i<=self.totalDays.count; i++) {
        NSString *str =[NSString stringWithFormat:@"%ld",(long)i];
        if (self.totalHeight[str]) {
            [arry addObject:self.totalHeight[str]];
        }
        else
        {
            [arry addObject:@"0"];
        }
    }
     float max = [[arry valueForKeyPath:@"@max.floatValue"] floatValue];
     for (NSString *str in arry) {
         [arry1 addObject:[NSString stringWithFormat:@"%f",str.floatValue/max]];
         
    }
    }
    
    return  arry1;
}

- (NSArray *)chatConfigXValue:(SNChart *)chart {
    
    
    NSArray *arry =[[NSArray alloc]initWithArray:self.totalDays];
    return arry;

    
}
- (void)scrollViewDidChangeNumber:(NSInteger)page
{
    if (self.isShowButton) {
        if (page <=0) {
            return;
        }
        NSInteger indexpage =[NSString stringWithFormat:@"%@",self.totalDays[page-1]].integerValue;
        BusinessStatisticsVo *vo =[self.busStatisArr objectForKey:[NSString stringWithFormat:@"%ld",(long)indexpage]];
        NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月总部营业统计  (%ld家门店)", nil), (long)indexpage,(long)vo.shopCount];
        NSString* dateKey=[NSString stringWithFormat:@"%ld", (long)indexpage];
        NSMutableArray *testArry =[self.payalldata2 objectForKey:[NSString stringWithFormat:@"%ld",(long)indexpage]];
        [self.detailBox loadData:title summary:[self.busStatisArr objectForKey:[NSString stringWithFormat:@"%ld",(long)indexpage]] pays:testArry date:dateKey storeNme:@"" totalStoresNum:@""isday:NO];
        [self.branchSelectView iniithit:NSLocalizedString(@"门店营业额对比", nil) img:@"ico_next_w.png"];
        self.branchSelectView.lblTitle.text =[NSString stringWithFormat:NSLocalizedString(@"%ld月 门店营业额对比", nil),(long)indexpage];
        self.pageMonth = indexpage;
        if (self.realMonth==indexpage) {
             self.lblTabRight.text=NSLocalizedString(@"本月", nil);
        }
        else
        {
            self.lblTabRight.text =[NSString stringWithFormat:NSLocalizedString(@"%ld月", nil),(long)indexpage];
        }
        self.monthScrollView.contentSize = CGSizeMake(320,self.detailBox.frame.origin.y + self.detailBox.frame.size.height +188);
    }
    else
    {
    BusinessStatisticsVo *vo  =[self.busStatisArr objectForKey:[NSString stringWithFormat:@"%ld",(long)page]];
    NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日总部营业统计  (%ld家门店)", nil), (long)self.currMonth,(long)page,(long)vo.shopCount];
    NSString* dateKey=[NSString stringWithFormat:@"%ld%02ld%02ld", (long)self.currYear, (long)self.currMonth, (long)page];
    NSMutableArray *testarry =[self.payalldata2 objectForKey:[NSString stringWithFormat:@"%ld",(long)page]];
        
    [self.dayBox loadData:title summary:[self.busStatisArr objectForKey:[NSString stringWithFormat:@"%ld",(long)page]] pays:testarry date:dateKey storeNme:@"" totalStoresNum:@"" isday:YES];
    self.detailSelectLbl.text =[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日 门店营业额对比", nil),(long)self.currMonth,(long)page];
        self.detailSelectLbl.textAlignment = NSTextAlignmentCenter;
    self.page = page;
        if (self.currYear==self.realYear && self.currMonth ==self.realMonth &&self.currDay ==self.page ) {
            self.lblTabLeft.text =NSLocalizedString(@"昨天", nil);
        }
        else
        {
             self.lblTabLeft.text=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日", nil), (long)self.currMonth, (long)self.page];
        }
    }
}
- (void)btnSelectView:(customView *)obj
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_branchBusinessDayViewControllerWithYear:self.pageMonth month:self.pageMonth day:0 andEventType:1];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)isHide:(BOOL)hide
{
    self.btnNextPay.hidden=hide;
    self.lblNextPay.hidden =hide;
    self.imgNextPay.hidden=hide;
    self.btnPrePay.hidden=hide;
    self.lblPrePay.hidden=hide;
    self.imgPrePay.hidden=hide;
}
- (void)btnPrevMonthPayEvent:(id)sender
{
    [self loadPrevMonthData];
}

- (void)btnNextMonthPayEvent:(id)sender
{
    [self loadNextMonthData];
}

- (void)loadPrevMonthData
{
//    NSInteger month=self.currMonth-1;
//    self.currMonth=month==0?12:month;
//    self.currYear=month==0?self.currYear-1:self.currYear;
    [self changeDateWithInterval:-1 type:TDFChangeDateTypeMonth];
    [self loadData:self.currYear month:self.currMonth day:1 Ids:self.idsArr];
}

- (void)loadNextMonthData
{
//    NSInteger month=self.currMonth+1;
//    self.currMonth=month==13?1:month;
//    self.currYear=month==13?self.currYear+1:self.currYear;
    [self changeDateWithInterval:1 type:TDFChangeDateTypeMonth];
    [self loadData:self.currYear month:self.currMonth day:1 Ids:self.idsArr];
}

/**
 改变日期
 
 @param monthInterval 间隔的月数，上个月 传-1，下个月传1
 @return 201611 类似的格式
 */
- (void)changeDateWithInterval:(NSInteger)interval type:(TDFChangeDateType)type
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    
    if (type == TDFChangeDateTypeDay) {
        comps.day = interval;
    }
    
    if (type == TDFChangeDateTypeMonth) {
        comps.month = interval;
    }
    
    NSDate *date = [DateUtils DateWithString:[NSString stringWithFormat:@"%02ld-%02ld-%02ld",self.currYear,self.currMonth,self.currDay ? self.currDay : 1] type:TDFFormatTimeTypeYearMonthDayString];
    
    
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay fromDate:newDate];
    
    self.currYear = [components year];
    self.currMonth = [components month];
    self.currDay = [components day];
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark table deal

#pragma mark UITableView
//////////////////////////////////////////////////////////////////////////////////////////////////
//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    DayOrderBillVO *item=(DayOrderBillVO *)obj;
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_orderDetailViewControllerWithOrderID:item.orderId andTotalPayID:item.totalPayId eventType:0];
    [self.navigationController pushViewController:viewController animated:YES];
//    [homeModel showOrderDetail];
//    [XHAnimalUtil animal:homeModel type:kCATransitionPush direct:kCATransitionFromRight];

//    [homeModel.orderDetailView loadData:item.orderId totalPayId:item.totalPayId EvenType:0];
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


- (NSDate*)convertDate:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:self.currMonth];
    [comps setDay:day];
    [comps setYear:self.currYear];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar dateFromComponents:comps];
}

- (NSInteger)getDaysOfMonth:(NSDate*)date_
{
    NSCalendar* calender=[NSCalendar currentCalendar];
    NSRange range=[calender rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date_];
    return range.length;
}

- (UIView *) tabBox
{
    if (!_tabBox) {
        _tabBox = [[UIView alloc] initWithFrame:CGRectMake(8, 71, SCREEN_WIDTH - 16, 34)];
        _tabBox.backgroundColor = [UIColor clearColor];
        [_tabBox addSubview:self.tabBg];
        [_tabBox addSubview:self.lblTabLeft];
        [_tabBox addSubview:self.lblTabRight];
        [_tabBox addSubview:self.daybutton];
        [_tabBox addSubview:self.monthbutton];
    }
    return _tabBox;
}

- ( UIView *) tabBg
{
    if (!_tabBg) {
        _tabBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 16)/2, 34)];
        _tabBg.backgroundColor = [UIColor whiteColor];
        _tabBg.alpha = 0.3;
    }
    return _tabBg;
}

- (UILabel *) lblTabLeft
{
    if (!_lblTabLeft) {
        _lblTabLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, (SCREEN_WIDTH - 16)/2, 21)];
        _lblTabLeft.textColor = [UIColor redColor];
        _lblTabLeft.text = NSLocalizedString(@"昨天", nil);
        _lblTabLeft.textAlignment = NSTextAlignmentCenter;
        _lblTabLeft.font = [UIFont boldSystemFontOfSize:15];
    }
    return _lblTabLeft;
}

- (UILabel *) lblTabRight
{
    if (!_lblTabRight) {
        _lblTabRight = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 16)/2+2, 6,(SCREEN_WIDTH - 16)/2 , 21)];
        _lblTabRight.textColor = [UIColor whiteColor];
        _lblTabRight.text = NSLocalizedString(@"本月", nil);
        _lblTabRight.textAlignment = NSTextAlignmentCenter;
        _lblTabRight.font = [UIFont boldSystemFontOfSize:15];
    }
    return _lblTabRight;
}

- (UIButton *) daybutton
{
    if (!_daybutton) {
        _daybutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 16)/2, 34)];
        [_daybutton addTarget:self action:@selector(btnTabTodayEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _daybutton;
}

- (UIButton *) monthbutton
{
    if (!_monthbutton) {
        _monthbutton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 16)/2+2, 0,(SCREEN_WIDTH - 16)/2, 34)];
        [_monthbutton addTarget:self action:@selector(btnTabMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthbutton;
}

- (UIView *) monthPanel
{
    if (!_monthPanel) {
        _monthPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 111, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _monthPanel.backgroundColor = [UIColor clearColor];
        
        [_monthPanel addSubview:self.imgPrePay];
        [_monthPanel addSubview:self.imgNextPay];
        [_monthPanel addSubview:self.lblPrePay];
        [_monthPanel addSubview:self.lblNextPay];
        [_monthPanel addSubview:self.btnPrePay];
        [_monthPanel addSubview:self.btnNextPay];
        [_monthPanel addSubview:self.monthScrollView];
    }
    return _monthPanel;
}

- (UIImageView *) imgPrePay
{
    if (!_imgPrePay) {
        _imgPrePay = [[UIImageView alloc] initWithFrame:CGRectMake(5, 11, 22, 22)    ];
        _imgPrePay.image = [UIImage imageNamed:@"ico_prev_w.png"];
    }
    return _imgPrePay;
}

- (UIImageView *) imgNextPay
{
    if (!_imgNextPay) {
        _imgNextPay = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 27, 11, 22, 22)    ];
        _imgNextPay.image = [UIImage imageNamed:@"ico_next_w.png"];
    }
    return _imgNextPay;
}

- (UILabel *) lblPrePay
{
    if (!_lblPrePay) {
        _lblPrePay = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 49, 20)];
        _lblPrePay.textColor = [UIColor whiteColor];
        _lblPrePay.text = NSLocalizedString(@"上一月", nil);
        _lblPrePay.font = [UIFont systemFontOfSize:14];
        _lblPrePay.textAlignment = NSTextAlignmentLeft;
    }
    return _lblPrePay;
}

- (UILabel *) lblNextPay
{
    if (!_lblNextPay) {
        _lblNextPay = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 73, 12, 49, 20)];
        _lblNextPay.textColor = [UIColor whiteColor];
        _lblNextPay.text = NSLocalizedString(@"下一月", nil);
        _lblNextPay.font = [UIFont systemFontOfSize:14];
        _lblNextPay.textAlignment = NSTextAlignmentRight;
    }
    return _lblPrePay;
}

- (UIButton *) btnPrePay
{
    if (!_btnPrePay) {
        _btnPrePay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [_btnPrePay addTarget:self action:@selector(btnPrevMonthPayEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPrePay;
}

- (UIButton *) btnNextPay
{
    if (!_btnNextPay) {
        _btnNextPay = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 44)];
        [_btnNextPay addTarget:self action:@selector(btnNextMonthPayEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNextPay;
}

- (UIScrollView *)monthScrollView
{
    if (!_monthScrollView) {
        _monthScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 6, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _monthScrollView.backgroundColor = [UIColor clearColor];
        _monthScrollView.bounces = YES;
        _monthScrollView.scrollEnabled = YES;
        _monthScrollView.showsHorizontalScrollIndicator = NO;
        _monthScrollView.showsVerticalScrollIndicator = NO;
        
        [_monthScrollView addSubview:self.detailBox];
        [_monthScrollView addSubview:self.branchSelectView];
        [_monthScrollView addSubview:self.monthChartBox];
    }
    return _monthScrollView;
}

- (ChainBusDetailBoxView *) detailBox
{
    if (!_detailBox) {
        _detailBox = [[ChainBusDetailBoxView alloc] initWithFrame:CGRectMake(0, 214, SCREEN_WIDTH - 10, 325)];
    }
    return _detailBox;
}

- (customView *) branchSelectView
{
    if (!_branchSelectView) {
        _branchSelectView = [[customView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 43)];
    }
    return _branchSelectView;
}

- (SNChart *) monthChartBox
{
    if (!_monthChartBox) {
        _monthChartBox = [[SNChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143)];
    }
    return _monthChartBox;
}

- (UIView *) todayPanel
{
    if (!_todayPanel) {
        _todayPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 111, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_todayPanel addSubview:self.scrollView];
    }
    return _todayPanel;

}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        [_container addSubview:view];
        
        [_container addSubview:self.seleceterView];
        [_container addSubview:self.chartBox];
        [_container addSubview:self.branchView];
        [_container addSubview:self.dayBox];
    }
    return _container;
}

- (UIView *) seleceterView
{
    if (!_seleceterView) {
        _seleceterView = [[UIView alloc] initWithFrame:CGRectMake(5, 91, SCREEN_WIDTH - 10, 42)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH - 10, 40)];
        [_seleceterView addSubview:view];
        
        [_seleceterView addSubview:self.imgPre];
        [_seleceterView addSubview:self.imgNext];
        [_seleceterView addSubview:self.btnNext];
        [_seleceterView addSubview:self.btnPre];
    }
    return _seleceterView;
}

- (UIImageView *) imgPre
{
    if (!_imgPre) {
        _imgPre = [[UIImageView alloc] initWithFrame:CGRectMake(17, 11, 17, 18)];
        _imgPre.image = [UIImage imageNamed:@"zuojiantou.png"];
    }
    return _imgPre;
}

- (UIImageView *) imgNext
{
    if (!_imgNext) {
        _imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42, 11, 17, 18)];
        _imgNext.image = [UIImage imageNamed:@"youjiantou.png"];
    }
    return _imgNext;
}

- (UIButton *) btnNext
{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57, 1, 20, 38)];
        _btnNext.lineBreakMode = NSLineBreakByWordWrapping;
        _btnNext.titleLabel.numberOfLines = 0;
        [_btnNext setTitle:NSLocalizedString(@"下月", nil) forState:UIControlStateNormal];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnNext.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnNext setContentEdgeInsets:UIEdgeInsetsMake(15, 2, 0, 6)];
        [_btnNext addTarget:self action:@selector(btnNextMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}

- (UIButton *) btnPre
{
    if (!_btnPre) {
        _btnPre = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 47, 38)];
         _btnPre.lineBreakMode = NSLineBreakByWordWrapping;
        [_btnPre setTitle:NSLocalizedString(@"上       月", nil) forState:UIControlStateNormal];
        [_btnPre setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnPre.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnPre setContentEdgeInsets:UIEdgeInsetsMake(15, 2, 0, 6)];
        [_btnPre addTarget:self action:@selector(btnPreMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPre;
}

- (SNChart *) chartBox
{
    if (!_chartBox) {
        _chartBox = [[SNChart alloc] initWithFrame:CGRectMake(38, 21, SCREEN_WIDTH - 85, 142)];
    }
    return _chartBox;
}

- (UIView *) branchView
{
    if (!_branchView) {
        _branchView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, 43) ];
        [_branchView addSubview:self.detailSelectLbl];
        [_branchView addSubview:self.detailSelectImg];
        [_branchView addSubview:self.detaiBusBtn];
    }
    return _branchView;
}

- (UILabel *) detailSelectLbl
{
    if (!_detailSelectLbl) {
        _detailSelectLbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 13, SCREEN_WIDTH - 173, 18) ];
        _detailSelectLbl.text = NSLocalizedString(@"门店营业额对比", nil);
        _detailSelectLbl.font = [UIFont systemFontOfSize:12];
        _detailSelectLbl.textColor = [UIColor whiteColor];
    }
    return _detailSelectLbl;
}

- (UIImageView *) detailSelectImg
{
    if (!_detailSelectImg) {
        _detailSelectImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94, 11, 22, 22)];
        _detailSelectImg.image = [UIImage imageNamed:@"ico_next_w.png"];
    }
    return _detailSelectImg;
}

- (UIButton *) detaiBusBtn
{
    if (!_detaiBusBtn) {
        _detaiBusBtn = [[UIButton alloc] initWithFrame:CGRectMake(68, 11, SCREEN_WIDTH - 133, 23)];
        [_detaiBusBtn addTarget:self action:@selector(detailSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detaiBusBtn;
}

- (ChainBusDetailBoxView *) dayBox
{
    if (!_dayBox) {
        _dayBox = [[ChainBusDetailBoxView alloc] initWithFrame:CGRectMake(5, 237, SCREEN_WIDTH - 10, 325)];
    }
    return _dayBox;
}

@end
