//
//  BranchBusinessDay.m
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BranchBusinessDay.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "UIHelper.h"
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
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "BusinessService.h"
#import "SummaryOfMonthVO.h"
#import "NSString+Estimate.h"
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>

typedef NS_ENUM(NSInteger, TDFChangeDateType) {
    TDFChangeDateTypeDay,
    TDFChangeDateTypeMonth
};

@implementation BranchBusinessDay

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    self.shopNameDic = [[NSMutableDictionary alloc] init];
    self.brandNameArr = [[NSMutableArray alloc] init];
    self.dayDic = [[NSMutableDictionary alloc] init];
    self.shopName = [[NSMutableArray alloc] init];
    self.amountArr = [[NSMutableArray alloc] init];
    self.brandIdArr = [[NSMutableArray alloc] init];
    self.shopDic = [[NSMutableDictionary alloc] init];
    self.entityIdsArr = [[NSMutableArray alloc] init];
    self.scrollView.contentSize=CGSizeMake(320, 820);
    [self loadData:[self.dataDic[@"year"] integerValue]
             month:[self.dataDic[@"month"] integerValue]
               day:[self.dataDic[@"day"] integerValue]
          eventype:[self.dataDic[@"eventType"] integerValue]];
}

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day eventype:(NSInteger)evenType
{
    self.isChange1 = YES;
    self.page=0;
    self.isFirst = YES;
    self.eventype = evenType;
    
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    self.realYear=[comps year];
    self.realMonth=[comps month];
    self.realDay=[comps day];
    if (self.eventype == 1) {
        if (month > self.realMonth) {
            self.currYear = self.realYear - 1;
        }else{
            self.currYear = self.realYear;
        }
        
    }else{
        self.currYear=year;
    }
    self.currMonth=month;
    self.currDay=day;
    
    if (self.isChange1) {
        if (self.eventype == 1) {
            if(self.currYear == self.realYear && self.realMonth == self.currMonth){
                self.leftBtnTitle.hidden = NO;
                self.rightTitleBtn.hidden = YES;
            }else{
                self.leftBtnTitle.hidden = NO;
                self.rightTitleBtn.hidden = NO;
            }
        }else{
            if (self.currYear ==self.realYear && self.realMonth == self.currMonth && self.realDay == self.currDay+1) {
                self.rightTitleBtn.hidden = YES;
                self.leftBtnTitle.hidden = NO;
            }else{
                self.rightTitleBtn.hidden = NO;
                self.leftBtnTitle.hidden = NO;
            }
        }
        self.isChange1 = NO;
    }

    self.eventype = evenType;
    if (self.eventype == 0) {
        self.lblTitle.text=NSLocalizedString(@"门店日营业额对比", nil);
        self.dayBox.monthlbl.hidden = NO;
        [self.leftBtnTitle setTitle:NSLocalizedString(@"<前一天", nil) forState:UIControlStateNormal];
        [self.rightTitleBtn setTitle:NSLocalizedString(@"后一天>", nil) forState:UIControlStateNormal];
        NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld-%ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
        NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日营业统计", nil), (long)self.currMonth,(long)self.currDay];
        [self.dayBox loadDataBranch:title summary:nil shopPay:nil date:dateKey storeNme:nil totalStoresNum:@""];
        
    }else{
        self.lblTitle.text=NSLocalizedString(@"门店月营业额对比", nil);
        self.dayBox.monthlbl.hidden = YES;
        [self.leftBtnTitle setTitle:NSLocalizedString(@"<上月", nil) forState:UIControlStateNormal];
        [self.rightTitleBtn setTitle:NSLocalizedString(@"下月>", nil) forState:UIControlStateNormal];
        NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld", (long)self.currYear, (long)self.currMonth];
        NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月营业统计", nil), (long)self.currMonth];
        [self.dayBox loadDataMonth:title summary:nil shopPay:nil date:dateKey storeNme:nil totalStoresNum:@""];
    }
    [self showProgressHudWithText:NSLocalizedString(@"请稍候", nil)];
    [self loadData];
}

- (void)loadData
{
    [self.chartBox removeFromSuperview];
    self.page1 = 0;
    //添加柱状图
    self.chartBox = [[SNChart alloc] initWithFrame:CGRectMake(40, 0, self.histogramView.frame.size.width-80, self.chartBox.frame.size.height) withDataSource:self andChatStyle:SNChartStyleBar];
    if (self.eventype == 0) {
        //添加柱状图
        [self.chartBox initStartPage:0 locaiton:-7  TheChartBarStart:2];
        [self.chartBox DrawChartBarStart:-20 chartBarTheXAxisSpan:24 kBarWidth:5];
        [self.chartBox initSize:11 widelength:10];
        
        NSString *date = [NSString stringWithFormat:@"%02ld%02ld%02ld",self.currYear,self.currMonth,self.currDay];
        @weakify(self);
        [[[TDFChainService alloc] init] getShopStatisticsByDayWithParam:@{@"date":date} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            self.isChange = YES;
            [self.progressHud hide:YES];
            [self getShopStatisticsFinishDay:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            self.isChange = YES;
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
        [self.chartBox showInView:self.histogramView];
    }else if(self.eventype == 1){
        //添加柱状图
        [self.chartBox initStartPage:0 locaiton:-6 TheChartBarStart:2];
        [self.chartBox DrawChartBarStart:-20 chartBarTheXAxisSpan:24 kBarWidth:7];
        [self.chartBox initSize:11 widelength:10];

        
        NSString *month = [NSString stringWithFormat:@"%02ld%02ld",self.currYear,self.currMonth];
        @weakify(self);
        [[[TDFChainService alloc] init] getShopStatisticsByMonthWithParam:@{@"month":month} sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            self.isChange = YES;
            [self.progressHud hide:YES];
            [self getShopStatisticsFinishMonth:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            self.isChange = YES;
            [self.progressHud hide:YES];
            
            [AlertBox show:error.localizedDescription];
        }];
        [self.chartBox showInView:self.histogramView];
    }else{
        
    }
}

- (void)getShopStatisticsFinishDay:(NSDictionary*) dic
{
    [self.brandNameArr removeAllObjects];
    [self.shopName removeAllObjects];
    [self.shopNameDic removeAllObjects];
    [self.dayDic removeAllObjects];
    [self.brandIdArr removeAllObjects];
    [self.shopDic removeAllObjects];
    [self.amountArr removeAllObjects];
    
    NSArray *arr = dic[@"data"];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSMutableDictionary *dic in arr) {
            BrandStatisticsDayVo *brandStatisticsDayVo = [[BrandStatisticsDayVo alloc] initWithDictionary:dic];
            if ([brandStatisticsDayVo.plateId isEqualToString:@"null_brand"]) {
                brandStatisticsDayVo.plateName = NSLocalizedString(@"无品牌门店", nil);
            }
            [self.dayDic setObject:dic forKey:brandStatisticsDayVo.plateName];
            if (brandStatisticsDayVo.plateName.length>10) {
                brandStatisticsDayVo.plateName = [NSString stringWithFormat:@"%@...",[brandStatisticsDayVo.plateName substringToIndex:10]];
            }
            if ([brandStatisticsDayVo.plateId isEqualToString:@"null_brand"]) {
                brandStatisticsDayVo.plateName = NSLocalizedString(@"无品牌门店", nil);
            }
            [self.brandNameArr addObject:brandStatisticsDayVo.plateName];
            [self.brandIdArr addObject:brandStatisticsDayVo.plateId];
            [self.shopDic setObject:brandStatisticsDayVo.shopVoListArr forKey:brandStatisticsDayVo.plateId];
        }
        if (self.isChange) {
            if ([ObjectUtil isNotEmpty:self.brandIdArr]) {
                NSMutableArray *shopList =[self.shopDic objectForKey:self.brandIdArr[0]];
                for (NSMutableDictionary *dic in shopList) {
                        ShopStatisticsDayVo *shopStatisticsDayVo = [[ShopStatisticsDayVo alloc] initWithDictionary:dic];
                        NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld-%ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
                        NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日营业统计", nil), (long)self.currMonth,(long)self.currDay];
                        [self.dayBox loadDataBranch:title summary:shopStatisticsDayVo.chainBusinessStatisticsDay shopPay:shopStatisticsDayVo date:dateKey storeNme:shopStatisticsDayVo.shopName totalStoresNum:@""];
                        [self.shopName addObject:shopStatisticsDayVo.shopName];
                        [self.shopNameDic setObject:shopStatisticsDayVo forKey:shopStatisticsDayVo.shopName];
                        if (shopStatisticsDayVo.chainBusinessStatisticsDay == nil) {
                            [self.amountArr addObject:@"0"];
                        }else{
                            if ([NSString isBlank:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount]]) {
                                shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount = 0.00;
                            }else{
                                [self.amountArr addObject:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount]];
                            }
                        }
                }
                self.branchTitle.text = self.brandNameArr[0];
                self.leftBrandTitle.hidden = YES;
                self.leftBrandImg.hidden = YES;
            }
            
            if (self.brandNameArr.count == 1) {
                self.leftBrandImg.hidden = YES;
                self.leftBrandTitle.hidden = YES;
                self.rightBrandTitle.hidden = YES;
                self.rightBrandImg.hidden = YES;
            }else{
                if (self.brandNameArr.count >1) {
                    [self.rightBrandTitle setTitle:self.brandNameArr[1] forState:UIControlStateNormal];
                    self.rightBrandTitle.hidden = NO;
                    self.rightBrandImg.hidden = NO;
                }else{
                    self.rightBrandTitle.hidden = YES;
                    self.rightBrandImg.hidden = YES;
                }
            }
            self.isChange = NO;
            [self ceratZhu];
        }
    }else{
        self.leftBrandImg.hidden = YES;
        self.leftBrandTitle.hidden = YES;
        self.rightBrandTitle.hidden = YES;
        self.rightBrandImg.hidden = YES;
    }
}

- (void)getShopStatisticsFinishMonth:(NSDictionary *) dic
{
    [self.brandNameArr removeAllObjects];
    [self.shopName removeAllObjects];
    [self.shopNameDic removeAllObjects];
    [self.dayDic removeAllObjects];
    [self.brandIdArr removeAllObjects];
    [self.shopDic removeAllObjects];
    [self.amountArr removeAllObjects];
    
    NSArray *arr = dic[@"data"];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSMutableDictionary *dic in arr) {
            BrandStatisticsDayVo *brandStatisticsDayVo = [[BrandStatisticsDayVo alloc] initWithDictionary:dic];
            if ([brandStatisticsDayVo.plateId isEqualToString:@"null_brand"]) {
                brandStatisticsDayVo.plateName = NSLocalizedString(@"无品牌门店", nil);
            }
            [self.dayDic setObject:dic forKey:brandStatisticsDayVo.plateName];
            if (brandStatisticsDayVo.plateName.length>10) {
                brandStatisticsDayVo.plateName = [NSString stringWithFormat:@"%@...",[brandStatisticsDayVo.plateName substringToIndex:10]];
            }
            if ([brandStatisticsDayVo.plateId isEqualToString:@"null_brand"]) {
                brandStatisticsDayVo.plateName = NSLocalizedString(@"无品牌门店", nil);
            }
            [self.brandNameArr addObject:brandStatisticsDayVo.plateName];
            [self.brandIdArr addObject:brandStatisticsDayVo.plateId];
            [self.shopDic setObject:brandStatisticsDayVo.shopVoListArr forKey:brandStatisticsDayVo.plateId];
        }
        if (self.isChange) {
            if ([ObjectUtil isNotEmpty:self.brandIdArr]) {
                NSMutableArray *shopList =[self.shopDic objectForKey:self.brandIdArr[0]];
                for (NSMutableDictionary *dic in shopList) {
                        ShopStatisticsMonthVo *shopStatisticsDayVo = [[ShopStatisticsMonthVo alloc] initWithDictionary:dic];
                        NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld", (long)self.currYear, (long)self.currMonth];
                        NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月营业统计", nil), (long)self.currMonth];
                        [self.dayBox loadDataMonth:title summary:shopStatisticsDayVo.chainBusinessStatisticsMonth shopPay:shopStatisticsDayVo date:dateKey storeNme:shopStatisticsDayVo.shopName totalStoresNum:@""];
                        [self.shopName addObject:shopStatisticsDayVo.shopName];
                        [self.shopNameDic setObject:shopStatisticsDayVo forKey:shopStatisticsDayVo.shopName];
                        if (shopStatisticsDayVo.chainBusinessStatisticsMonth == nil) {
                            [self.amountArr addObject:@"0"];
                        }else{
                            if ([NSString isBlank:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount]]) {
                                shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount = 0.00;
                            }else{
                                [self.amountArr addObject:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount]];
                            }
                        }
                }
                self.branchTitle.text = self.brandNameArr[0];
                self.leftBrandTitle.hidden = YES;
                self.leftBrandImg.hidden = YES;
            }
            
            if (self.brandNameArr.count == 1) {
                self.leftBrandImg.hidden = YES;
                self.leftBrandTitle.hidden = YES;
                self.rightBrandTitle.hidden = YES;
                self.rightBrandImg.hidden = YES;
            }else{
                if (self.brandNameArr.count >1) {
                    [self.rightBrandTitle setTitle:self.brandNameArr[1] forState:UIControlStateNormal];
                    self.rightBrandTitle.hidden = NO;
                    self.rightBrandImg.hidden = NO;
                }else{
                    self.rightBrandTitle.hidden = YES;
                    self.rightBrandImg.hidden = YES;
                }
            }
            self.isChange = NO;
            [self ceratZhu];
        }
    }else{
        self.leftBrandImg.hidden = YES;
        self.leftBrandTitle.hidden = YES;
        self.rightBrandTitle.hidden = YES;
        self.rightBrandImg.hidden = YES;
    }
}

- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:@"%0.2f",value];
    }
    return @"-";
}

//柱状图协议
- (NSArray *)chatConfigYValue:(SNChart *)chart {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:self.amountArr]) {
        float max = [[self.amountArr valueForKeyPath:@"@max.floatValue"] floatValue];
        if (max == 0) {
            [array addObject:@"0"];
        }else{
            for (NSString *str in self.amountArr) {
                if (str.floatValue/max < 0.004) {
                [array addObject:[NSString stringWithFormat:@"%f",str.floatValue/4]];
                }else{
                [array addObject:[NSString stringWithFormat:@"%f",str.floatValue/max]];
                }
            }
        }
    }
    return array;
}

- (NSArray *)chatConfigXValue:(SNChart *)chart {
    
    NSMutableArray *arry1 =[[NSMutableArray alloc]init];
    NSString *str1;
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    for (NSString *str in self.shopName) {
        if (str.length > 10) {
            str1 = [NSString stringWithFormat:@"%@...",[str substringToIndex:10]];
        }else{
            str1 = str;
        }
        [arr2 addObject:str1];
    }
    
    [arry1 addObjectsFromArray:arr2];
    return arry1;
}
- (void)scrollViewDidChangeNumber:(NSInteger)page
{
    self.page1 ++;
    if (self.isFirst) {
        if (self.page1 == 2) {
            self.isFirst = NO;
        }
        return;
    }
  
    if ([ObjectUtil isNotEmpty:self.shopName]) {
        NSString *shopName = self.shopName[page-1];
        
        if (self.eventype == 1) {
            ShopStatisticsMonthVo *shopStatisticsMonthVo = [self.shopNameDic objectForKey:shopName];
            NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld", (long)self.currYear, (long)self.currMonth];
            NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月营业统计", nil), (long)self.currMonth];
            [self.dayBox loadDataMonth:title summary:shopStatisticsMonthVo.chainBusinessStatisticsMonth shopPay:shopStatisticsMonthVo date:dateKey storeNme:shopStatisticsMonthVo.shopName totalStoresNum:@""];
            
        }else{
            NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld-%ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
            ShopStatisticsDayVo *shopStatisticsDayVo = [self.shopNameDic objectForKey:shopName];
            NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日营业统计", nil), (long)self.currMonth,(long)self.currDay];
            [self.dayBox loadDataBranch:title summary:shopStatisticsDayVo.chainBusinessStatisticsDay shopPay:shopStatisticsDayVo date:dateKey storeNme:shopStatisticsDayVo.shopName totalStoresNum:@""];
        }
    }
}

- (IBAction)btnBackEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//前一天/月处理.
- (IBAction)btnLastDayEvent:(id)sender
{
    if(self.eventype == 0)
    {
//        self.currDay = self.currDay  -1;
        [self changeDateWithInterval:-1 type:TDFChangeDateTypeDay];
        if (self.currYear ==self.realYear && self.realMonth == self.currMonth && self.realDay == self.currDay) {
            self.rightTitleBtn.hidden = YES;
            self.leftBtnTitle.hidden = NO;
        }else{
            self.rightTitleBtn.hidden = NO;
            self.leftBtnTitle.hidden = NO;
        }
        
//        if (self.currDay == 0) {
//            self.currMonth = self.currMonth-1;
//            NSDate *date = [DateUtils DateWithString:[NSString stringWithFormat:@"%02ld-%02ld-%d",self.currYear,self.currMonth,1] type:TDFFormatTimeTypeYearMonthDayString];
//            NSInteger day = [self getDaysOfMonth:date];
//            self.currDay = day;
//        }
        [self loadData:self.currYear month:self.currMonth day:self.currDay eventype:0];
    }else if (self.eventype == 1)
    {
//        NSInteger month=self.currMonth-1;
//        self.currMonth=month==0?12:month;
//        self.currYear=month==0?self.currYear-1:self.currYear;
        [self changeDateWithInterval:-1 type:TDFChangeDateTypeMonth];
        if (self.currYear ==self.realYear-1 && self.realMonth == self.currMonth) {
            self.leftBtnTitle.hidden = YES;
            self.rightTitleBtn.hidden = NO;
        }else if(self.currYear == self.realYear && self.realMonth == self.currMonth){
            self.leftBtnTitle.hidden = NO;
            self.rightTitleBtn.hidden = YES;
        }else{
            self.leftBtnTitle.hidden = NO;
            self.rightTitleBtn.hidden = NO;
        }
        [self loadData:self.currYear month:self.currMonth day:self.currDay eventype:1];;
    }
}

//后一天/月处理.
- (IBAction)btnAfterDayEvent:(id)sender
{
    if(self.eventype == 0)
    {
//        NSDate *date = [DateUtils DateWithString:[NSString stringWithFormat:@"%02ld-%02ld-%02ld",self.currYear,self.currMonth,self.currDay] type:TDFFormatTimeTypeYearMonthDayString];
//        NSInteger day = [self getDaysOfMonth:date];
//        self.currDay = self.currDay  +1;
        [self changeDateWithInterval:1 type:TDFChangeDateTypeDay];
        if (self.currYear ==self.realYear && self.realMonth == self.currMonth && self.realDay == self.currDay) {
            self.rightTitleBtn.hidden = YES;
            self.leftBtnTitle.hidden = NO;
        }else{
            self.rightTitleBtn.hidden = NO;
            self.leftBtnTitle.hidden = NO;
        }
        
        [self loadData:self.currYear month:self.currMonth day:self.currDay eventype:0];
//        if (self.currDay == day) {
//            self.currDay = 1;
//            self.currMonth = self.currMonth+1;
//        }
    }else if (self.eventype == 1)
    {
//        NSInteger month=self.currMonth+1;
//        self.currMonth=month==13?1:month;
//        self.currYear=month==13?self.currYear+1:self.currYear;
        [self changeDateWithInterval:1 type:TDFChangeDateTypeMonth];
        if(self.currYear == self.realYear && self.realMonth == self.currMonth){
            self.leftBtnTitle.hidden = NO;
            self.rightTitleBtn.hidden = YES;
        }else{
            self.leftBtnTitle.hidden = NO;
            self.rightTitleBtn.hidden = NO;
        }
        [self loadData:self.currYear month:self.currMonth day:self.currDay eventype:1];;
    }
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

//前一个品牌处理.
- (IBAction)btnLastBranchEvent:(id)sender
{
    self.page--;
    [self changeBrand:self.page];
    if (self.page == 0) {
        self.branchTitle.text = self.brandNameArr[0];
        self.leftBrandTitle.hidden = YES;
        self.leftBrandImg.hidden = YES;
        [self.rightBrandTitle setTitle:self.brandNameArr[self.page+1] forState:UIControlStateNormal];
        self.rightBrandTitle.hidden = NO;
        self.rightBrandImg.hidden = NO;
        return;
    }
    
    [self.leftBrandTitle setTitle:self.brandNameArr[self.page-1] forState:UIControlStateNormal];
    [self.rightBrandTitle setTitle:self.brandNameArr[self.page+1] forState:UIControlStateNormal];
    self.leftBrandTitle.hidden = NO;
    self.leftBrandImg.hidden = NO;
    self.rightBrandTitle.hidden = NO;
    self.rightBrandImg.hidden = NO;
    
}

//后一个品牌处理.
- (IBAction)btnAfterBranchEvent:(id)sender
{
    self.page++;
    [self changeBrand:self.page];
    if (self.page == self.brandIdArr.count-1) {
        self.branchTitle.text = self.brandNameArr[self.page];
        self.rightBrandImg.hidden = YES;
        self.rightBrandTitle.hidden = YES;
        [self.leftBrandTitle setTitle:self.brandNameArr[self.page-1] forState:UIControlStateNormal];
        self.leftBrandTitle.hidden = NO;
        self.leftBrandImg.hidden = NO;
        return;
    }
    self.leftBrandTitle.hidden = NO;
    self.leftBrandImg.hidden = NO;
    self.rightBrandTitle.hidden = NO;
    self.rightBrandImg.hidden = NO;
    [self.leftBrandTitle setTitle:self.brandNameArr[self.page-1] forState:UIControlStateNormal];
    [self.rightBrandTitle setTitle:self.brandNameArr[self.page+1] forState:UIControlStateNormal];
}

- (void)changeBrand:(NSInteger)page
{
    [self.amountArr removeAllObjects];
    [self.shopName removeAllObjects];
    [self.shopNameDic removeAllObjects];

    NSDictionary *dic = [self.dayDic objectForKey:self.brandNameArr[page]];
    BrandStatisticsDayVo * brandStatisticsDayVo = [[BrandStatisticsDayVo alloc] initWithDictionary:dic];
    self.branchTitle.text = [NSString stringWithFormat:@"%@",self.brandNameArr[page]];
    if (self.eventype == 1) {
        for (NSMutableDictionary *dic in brandStatisticsDayVo.shopVoListArr) {
            ShopStatisticsMonthVo *shopStatisticsDayVo = [[ShopStatisticsMonthVo alloc] initWithDictionary:dic];
            NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld", (long)self.currYear, (long)self.currMonth];
            NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月营业统计", nil), (long)self.currMonth];
            [self.dayBox loadDataMonth:title summary:shopStatisticsDayVo.chainBusinessStatisticsMonth shopPay:shopStatisticsDayVo date:dateKey storeNme:shopStatisticsDayVo.shopName totalStoresNum:@""];
            if (shopStatisticsDayVo.chainBusinessStatisticsMonth == nil) {
                [self.amountArr addObject:@"0"];
            }else{
                if ([NSString isBlank:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount]]) {
                    shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount = 0.00;
                }else{
                [self.amountArr addObject:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsMonth.actualAmount]];
                }
            }
            [self.shopName addObject:shopStatisticsDayVo.shopName];
            [self.shopNameDic setObject:shopStatisticsDayVo forKey:shopStatisticsDayVo.shopName];
            [self ceratZhu];
        }
        
    }else{
        for (NSMutableDictionary *dic in brandStatisticsDayVo.shopVoListArr) {
            ShopStatisticsDayVo *shopStatisticsDayVo = [[ShopStatisticsDayVo alloc] initWithDictionary:dic];
            NSString* dateKey=[NSString stringWithFormat:@"%ld-%ld-%ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
            NSString* title=[NSString stringWithFormat:NSLocalizedString(@"%ld月%ld日营业统计", nil), (long)self.currMonth,(long)self.currDay];
            [self.dayBox loadDataBranch:title summary:shopStatisticsDayVo.chainBusinessStatisticsDay shopPay:shopStatisticsDayVo date:dateKey storeNme:shopStatisticsDayVo.shopName totalStoresNum:@""];
            if (shopStatisticsDayVo.chainBusinessStatisticsDay == nil) {
                [self.amountArr addObject:@"0"];
            }else{
                if ([NSString isBlank:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount]]) {
                    shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount = 0.00;
                }else{
                [self.amountArr addObject:[NSString stringWithFormat:@"%f",shopStatisticsDayVo.chainBusinessStatisticsDay.actualAmount]];
                }
            }
            [self.shopName addObject:shopStatisticsDayVo.shopName];
            [self.shopNameDic setObject:shopStatisticsDayVo forKey:shopStatisticsDayVo.shopName];
            [self ceratZhu];
        }
    }
}

- (void)ceratZhu
{
    [self.chartBox removeFromSuperview];
    
    self.chartBox = [[SNChart alloc] initWithFrame:CGRectMake(40, 0, self.histogramView.frame.size.width-80, self.chartBox.frame.size.height) withDataSource:self andChatStyle:SNChartStyleBar];
    NSInteger a;
    if (self.shopName.count%2 == 1) {
        a = self.shopName.count/2+1;
    }else{
        if (self.shopName.count <=  2) {
            a = 0;
        }else{
            a = self.shopName.count/2;
        }
    }
    if(self.eventype == 1)
    {
        //添加柱状图
        [self.chartBox initStartPage:a locaiton:-6 TheChartBarStart:2];
        [self.chartBox DrawChartBarStart:-20 chartBarTheXAxisSpan:24 kBarWidth:7];
        [self.chartBox initSize:11 widelength:10];
        [self.chartBox showInView:self.histogramView];
    }else{
        [self.chartBox initStartPage:a locaiton:-7  TheChartBarStart:2];
        [self.chartBox DrawChartBarStart:-20 chartBarTheXAxisSpan:24 kBarWidth:5];
        [self.chartBox initSize:11 widelength:10];
        [self.chartBox showInView:self.histogramView];
    }
}

- (NSInteger)getDaysOfMonth:(NSDate*)date_
{
    NSCalendar* calender=[NSCalendar currentCalendar];
    NSRange range=[calender rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date_];
    return range.length;
}

@end
