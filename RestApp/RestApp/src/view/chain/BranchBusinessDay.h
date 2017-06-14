//
//  BranchBusinessDay.h
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNChart.h"
#import "BusinessPayDetailBox.h"
#import "ChainBusDetailBoxView.h"
#import "BusinessService.h"
#import "BrandStatisticsDayVo.h"
#import "ShopStatisticsMonthVo.h"
#import "ChainPaymentStatisticsMonth.h"
#import "TDFRootViewController.h"
@interface BranchBusinessDay : TDFRootViewController<SNChartDataSource>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *histogramView;
@property (nonatomic, strong) IBOutlet UIView *brandView;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;        //标题.
@property (nonatomic, strong) IBOutlet ChainBusDetailBoxView *dayBox;   //日营业数据详细面板.
@property (nonatomic, strong) IBOutlet UILabel *branchTitle;   //左侧Tab
@property (nonatomic, strong) IBOutlet  SNChart*chartBox; //月营业数据(柱状图)详细面板.
@property (strong, nonatomic) IBOutlet UIButton *leftBtnTitle;//左边前一天按钮
@property (strong, nonatomic) IBOutlet UIButton *rightTitleBtn;//右边后一天按钮
@property (strong, nonatomic) IBOutlet UIButton *leftBrandImg;
@property (strong, nonatomic) IBOutlet UIButton *rightBrandImg;
@property (strong, nonatomic) IBOutlet UIButton *leftBrandTitle;
@property (strong, nonatomic) IBOutlet UIButton *rightBrandTitle;
@property (nonatomic, strong) NSMutableDictionary* shopNameDic;  //日支付数据字典表.
@property (nonatomic, strong) NSMutableDictionary *shopDic;

@property (nonatomic, strong) NSMutableDictionary *dayDic;
@property (nonatomic, strong) NSMutableArray *brandNameArr;
@property (nonatomic, strong) NSMutableArray *shopName;
@property (nonatomic, strong) NSMutableArray *amountArr;
@property (nonatomic, strong) NSMutableArray *brandIdArr;
@property (nonatomic, strong) NSMutableArray *entityIdsArr;

@property (nonatomic, assign) BOOL isShowMonth;   //是否显示月面板.
@property (nonatomic, assign) NSInteger currYear;    //当前年.
@property (nonatomic, assign) NSInteger currMonth;   //当年月份.
@property (nonatomic, assign) NSInteger realYear;    //真实年.
@property (nonatomic, assign) NSInteger realMonth;   //真实月份.
@property (nonatomic, assign) NSInteger currDay;     //当前日期.
@property (nonatomic, assign) NSInteger realDay;     //真实日期.
@property (nonatomic, assign) NSInteger eventype;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page1;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, assign) BOOL isChange1;

@property (nonatomic, strong)NSMutableDictionary *dataDic;
- (IBAction)btnBackEvent:(id)sender;

- (IBAction)btnLastBranchEvent:(id)sender;

- (IBAction)btnAfterBranchEvent:(id)sender;

//前一天处理.
- (IBAction)btnLastDayEvent:(id)sender;

//后一天处理.
- (IBAction)btnAfterDayEvent:(id)sender;

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day eventype:(NSInteger)evenType;

@end
