//
//  BusinessDetailPanel.m
//  RestApp
//
//  Created by zxh on 14-8-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "ChainBusinessStatisticsDay.h"
#import "BusinessDetailPanel.h"
#import "NSString+Estimate.h"
#import "AppController.h"
#import "BusinessDayVO.h"
#import "UIView+Sizes.h"
#import "NumberUtil.h"
#import "FormatUtil.h"
#import "NetworkBox.h"
#import "HomeView.h"
#import "Platform.h"

@implementation BusinessDetailPanel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeView = homeViewTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.background.layer.cornerRadius = 4;
    self.detailBtn = [CMButton createCMButton:self x:0 y:0 w:self.view.width h:self.view.height];
    [self.view addSubview:self.detailBtn];
}

- (void)clearData:(NSString *)dayName
{
    self.lblName.text=dayName;
    self.lblSourceAmout.text=@"0";
    self.lblTotalAmout.text=@" -";
    self.lblDiscountAmout.text=@" 0";
    self.lblProfitAmout.text=@"0";
    self.lblBillNum.text=@"0";
    self.lblPeopleAmout.text=@"0";
    self.lblAvgAmout.text=@" 0";
}

- (void)loadData:(NSString *)dayName summary:(BusinessSummaryVO *)summary date:(NSString *)dateStr
{
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@日", nil),dateStr];
    self.lblDate.text=str;
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, dateStr.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path=@"icon_day.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (!summary) {
        [self clearData:dayName];
    } else {
        self.lblName.text = dayName;
        self.lblSourceAmout.text = [self formatNumber:summary.sourceFee];
        if ([NumberUtil isNotZero:summary.totalAmount]) {
            self.lblTotalAmout.text = [FormatUtil formatDoubleWithSeperator:summary.totalAmount];
        }else{
            self.lblTotalAmout.text = @"-";
        }
        self.lblDiscountAmout.text = [self formatNumber:summary.discountAmount];
        self.lblProfitAmout.text = [self formatNumber:summary.profitAmount];
        self.lblBillNum.text = [self formatInt:summary.billingNum unit:NSLocalizedString(@"张", nil)];
        self.lblPeopleAmout.text = [self formatInt:summary.totalNum unit:NSLocalizedString(@"人", nil)];
        self.lblAvgAmout.text = [self formatNumber:summary.aveConsume];
    }
}

- (void)loadChainData:(NSString*)dayName summary:(ChainBusinessStatisticsDay*)summary date:(NSString*)dateStr
{
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@日", nil),dateStr];
    self.lblDate.text=str;
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, dateStr.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path=@"icon_day.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (!summary) {
        [self clearData:dayName];
    } else {
        self.lblName.text = dayName;
        self.lblSourceAmout.text = [self formatNumber:summary.sourceAmount];
        if ([NumberUtil isNotZero:summary.actualAmount]) {
          self.lblTotalAmout.text = [FormatUtil formatDoubleWithSeperator:summary.actualAmount];
        }else{
            self.lblTotalAmout.text = @"-";
        }
        self.lblDiscountAmout.text = [self formatNumber:summary.discountAmount];
        self.lblProfitAmout.text = [self formatNumber:summary.profitLossAmount];
        self.lblBillNum.text = [self formatInt:summary.orderCount unit:NSLocalizedString(@"单", nil)];
        self.lblPeopleAmout.text = [self formatInt:summary.mealsCount unit:NSLocalizedString(@"人", nil)];
        self.lblAvgAmout.text = [self formatNumber:summary.actualAmountAvg];
    }
}



- (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatDoubleWithSeperator:value];
    }
    return @"0";
}

- (NSString *)formatInt:(int)value unit:(NSString*)unit
{
    if ([NumberUtil isNotZero:value]) {
        return [FormatUtil formatIntWithSeperator:value];
    }
    return @"0";
}

- (void)touchUpInside:(CMButton *)button
{
    if ([[Platform Instance] isNetworkOk]) {
        
        [homeView showBusinessDetailEvent];
    } else {
        [AlertBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil)];
    }
}

@end
