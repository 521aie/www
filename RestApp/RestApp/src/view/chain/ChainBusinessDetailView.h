//
//  ChainBusinessDetailView.h
//  RestApp
//
//  Created by iOS香肠 on 16/1/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNChart.h"
#import "customView.h"
#import "XHChartBox.h"
#import "BusinessService.h"
#import "ISampleListEvent.h"
#import "BusinessPayDetailBox.h"
#import "ChainBusDetailBoxView.h"
#import "BusinessDetailPayHideBox.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"
@class SummaryOfMonthVO;
@interface ChainBusinessDetailView : TDFRootViewController<OptionPickerClient,ISampleListEvent,SelectButtonDelegate,SNChartDataSource>

{
    BusinessService *service;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *lblTitle;        //标题.
@property (weak, nonatomic) UILabel *lblDetaiTitle;
@property (nonatomic, strong) ChainBusDetailBoxView *dayBox;   //日营业数据详细面板.
@property (nonatomic, strong) ChainBusDetailBoxView *detailBox;  //月的详细信息.
@property (nonatomic, strong) UIView *tabBox;       //Tab容器.
@property (nonatomic, strong) UILabel *lblTabLeft;   //左侧Tab
@property (nonatomic, strong) UILabel *lblTabRight;  //右侧Tab
@property (nonatomic, strong) SNChart *chartBox; //月营业数据(柱状图)详细面板.
@property (nonatomic, strong) UIImageView *imgPre;        //上一个月图标.
@property (nonatomic, strong) UIButton *btnPre;  //上一个月按钮.
@property (nonatomic, strong) UIImageView *imgNext;        //下一个月图标.
@property (nonatomic, strong) UIButton *btnNext;  //下一个月按钮.
@property (nonatomic, strong) UIImageView *imgPrePay;        //上一个月图标.
@property (nonatomic, strong) UIButton *btnPrePay;  //上一个月按钮.
@property (nonatomic, strong) UILabel *lblPrePay;  //上一个月按钮.
@property (nonatomic, strong) UIImageView *imgNextPay;        //下一个月图标.
@property (nonatomic, strong) UIButton *btnNextPay;  //下一个月按钮.
@property (nonatomic, strong) UILabel *lblNextPay;  //下一个月按钮.
@property (nonatomic, strong) UIView *todayPanel;       //今天面板.
@property (nonatomic, strong) UIView *monthPanel;       //月面板.
@property (nonatomic, strong) UIScrollView *monthScrollView;
@property (nonatomic, strong) UIView *tabBg;
@property (nonatomic, strong) SNChart *monthChartBox;

@property (nonatomic, strong) UIView *seleceterView;
@property (nonatomic, strong) UIView *branchView;

@property (nonatomic, strong) NSMutableArray* dayDatas;   //详细日数据.
@property (nonatomic, strong) NSMutableDictionary* dayDic;  //日数据字典表.
@property (nonatomic, strong) SummaryOfMonthVO* monthData;   //月汇总营业数据.
@property (nonatomic, strong) NSArray* monthArr;
@property (nonatomic, strong) NSMutableArray *datas;   //数据集合.
@property (nonatomic, strong) NSMutableArray* pays;   //支付类型.
@property (nonatomic, strong) NSMutableArray* payDays;  //每日的支付流水.
@property (nonatomic, strong) NSMutableDictionary* dayPayDic;  //日支付数据字典表.
@property (nonatomic, assign) BOOL isShowMonth;   //是否显示月面板.
@property (nonatomic, assign) NSInteger currYear;    //当前年.
@property (nonatomic, assign) NSInteger currMonth;   //当年月份.
@property (nonatomic, assign) NSInteger currDay;     //当前日期.
@property (nonatomic, assign) NSInteger realYear;   //实际的年份.
@property (nonatomic, assign) NSInteger realMonth;   //实际的月份.
@property (nonatomic, assign) NSInteger realDay;
@property (nonatomic, assign) BOOL isShowButton;

@property (nonatomic, assign) NSInteger monthcurrYear;    //当前月份年.
@property (nonatomic, assign) NSInteger monthcurrMonth;   //当年月份月份.
@property (nonatomic, assign) NSInteger monthcurrDay;
@property (nonatomic, assign) NSInteger shopcount;

//实际的日期
@property (nonatomic ,strong) UIButton *detaiBusBtn;
@property (nonatomic ,strong) UIImageView *detailSelectImg;
@property (nonatomic ,strong) UILabel *detailSelectLbl;

@property (nonatomic ,strong) customView *branchSelectView;

@property (nonatomic ,strong) UIButton *daybutton;

@property (nonatomic ,strong) UIButton *monthbutton;

@property (nonatomic ,strong) NSMutableArray *dateArry;
@property (nonatomic ,strong) NSMutableDictionary *busStatisArr;
@property (nonatomic ,strong) NSMutableDictionary *payStatisArr;
@property (nonatomic ,strong) NSMutableDictionary *payalldata;
@property (nonatomic ,strong) NSMutableDictionary *payalldata2;

@property (nonatomic ,strong) NSMutableArray * idsArr;

@property (nonatomic ,strong) NSMutableDictionary *totalHeight;
@property (nonatomic ,strong) NSMutableArray *totalDays;

@property (nonatomic ,strong) SNChart *dayChartBox;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger pageMonth;

@property (nonatomic ,assign)BOOL isfirst;

- (IBAction)btnBackEvent:(id)sender;

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day Ids:(NSMutableArray *)arry;

@end
