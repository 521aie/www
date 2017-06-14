//
//  BusinessDetailView.h
//  RestApp
//
//  Created by zxh on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHChartBox.h"
#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"
@class BusinessService, BusinessPayDetailBox;
@class SummaryOfMonthVO, BusinessDetailPayHideBox, MBProgressHUD;
@interface BusinessDetailView : TDFRootViewController<XHChartDelegate,OptionPickerClient,ISampleListEvent,UITableViewDataSource,UITableViewDelegate>
{
    BusinessService *service;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;        //标题.
@property (nonatomic, strong) IBOutlet BusinessDetailPayHideBox *dayBox;   //日营业数据详细面板.
@property (nonatomic, strong) IBOutlet BusinessPayDetailBox *detailBox;  //月的详细信息.
@property (nonatomic, strong) IBOutlet UIView *tabBox;       //Tab容器.
@property (nonatomic, strong) IBOutlet UILabel *lblTabLeft;   //左侧Tab
@property (nonatomic, strong) IBOutlet UILabel *lblTabRight;  //右侧Tab
@property (nonatomic, strong) IBOutlet XHChartBox *chartBox; //月营业数据(柱状图)详细面板.
@property (nonatomic, strong) IBOutlet UIView *orderContainer;       //当日营业流水容器.
@property (nonatomic, strong) IBOutlet UIView *orderContainerBg;       //当日营业流水容器(背景).
@property (nonatomic, strong) IBOutlet UIImageView *imgMonthShow;    //月面板显示.
@property (nonatomic, strong) IBOutlet UILabel *lblMonthTitle;       //月标题.
@property (nonatomic, strong) IBOutlet UILabel *lblDayRight;        //月标题(详细数据).
@property (nonatomic, strong) IBOutlet UITableView *orderTable;  //月营业数据详细面板.
@property (nonatomic, strong) IBOutlet UIImageView *imgPre;        //上一个月图标.
@property (nonatomic, strong) IBOutlet UIButton *btnPre;  //上一个月按钮.
@property (nonatomic, strong) IBOutlet UIImageView *imgNext;        //下一个月图标.
@property (nonatomic, strong) IBOutlet UIButton *btnNext;  //下一个月按钮.
@property (nonatomic, strong) IBOutlet UIImageView *imgPrePay;        //上一个月图标.
@property (nonatomic, strong) IBOutlet UIButton *btnPrePay;  //上一个月按钮.
@property (nonatomic, strong) IBOutlet UILabel *lblPrePay;  //上一个月按钮.
@property (nonatomic, strong) IBOutlet UIImageView *imgNextPay;        //下一个月图标.
@property (nonatomic, strong) IBOutlet UIButton *btnNextPay;  //下一个月按钮.
@property (nonatomic, strong) IBOutlet UILabel *lblNextPay;  //下一个月按钮.
@property (nonatomic, strong) IBOutlet UIView *todayPanel;       //今天面板.
@property (nonatomic, strong) IBOutlet UIView *monthPanel;       //月面板.
@property (nonatomic, strong) IBOutlet UIScrollView *monthScrollView;
@property (nonatomic, strong) IBOutlet UIView *tabBg;       //选中Tab面板的背景.

@property (nonatomic, strong) NSMutableArray* dayDatas;   //详细日数据.
@property (nonatomic, strong) NSMutableDictionary* dayDic;  //日数据字典表.
@property (nonatomic, strong) SummaryOfMonthVO* monthData;   //月汇总营业数据.

@property (nonatomic, strong) NSArray* monthArr;
@property (nonatomic, strong) NSMutableArray *datas;   //数据集合.
@property (nonatomic, strong) NSMutableArray* pays;   //支付类型.
@property (nonatomic, strong) NSMutableArray* payDays;  //每日的支付流水.
@property (nonatomic, strong) NSMutableDictionary* dayPayDic;  //日支付数据字典表.

@property (nonatomic, assign) NSInteger currYear;    //当前年.
@property (nonatomic, assign) NSInteger currMonth;   //当年月份.
@property (nonatomic, assign) NSInteger currDay;     //当前日期.

@property (nonatomic, assign) NSInteger realYear;   //实际的年份.
@property (nonatomic, assign) NSInteger realMonth;   //实际的月份.
@property (nonatomic, assign) NSInteger realDay;     //实际的日期

@property (nonatomic, assign) BOOL isShowMonth;   //是否显示月面板.

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
//返回事件.
- (IBAction)btnBackEvent:(id)sender;

- (IBAction)btnPreMonthEvent:(id)sender;

- (IBAction)btnNextMonthEvent:(id)sender;

- (IBAction)btnMonthShowEvent:(id)sender;

- (IBAction)btnPrevMonthPayEvent:(id)sender;

- (IBAction)btnNextMonthPayEvent:(id)sender;

- (IBAction)btnPrintBillEvent:(id)sender;

//tab月处理.
- (IBAction)btnTabMonthEvent:(id)sender;

//tab今天处理.
- (IBAction)btnTabTodayEvent:(id)sender;

@end
