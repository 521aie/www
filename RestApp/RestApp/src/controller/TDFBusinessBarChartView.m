//
//  TDFBusinessBarChartView.m
//  RestApp
//
//  Created by happyo on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBusinessBarChartView.h"
#import "TDFBusinessInfoModel.h"
#import "DateUtils.h"
#import "FormatUtil.h"
#import "TDFHistogramView.h"

static CGFloat kChartViewHeight = 160;

@interface TDFBusinessBarChartView () <TDFHistogramViewDelegate>

@property (nonatomic, strong) UILabel *lblDateTitle;

@property (nonatomic, strong) UILabel *lblDateAccount;

@property (nonatomic, strong) NSArray<TDFBusinessInfoModel *> *modelList;

@property (nonatomic, strong) NSString *monthDate;

@property (nonatomic, strong) TDFHistogramView *histogramView;

@property (nonatomic, strong) NSDictionary *weekDict;

@property (nonatomic, strong) NSDictionary *monthDict;

/**
 是表示日报表，否表示月报表
 */
@property (nonatomic, assign) BOOL isDayStyle;

@end
@implementation TDFBusinessBarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kChartViewHeight)];
    
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.lblDateTitle];
        [self.lblDateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(15));
        }];
        
        [self addSubview:self.lblDateAccount];
        [self.lblDateAccount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblDateTitle.mas_bottom).with.offset(5);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(14));
        }];
        
        UIImageView *igvRedArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        igvRedArrow.image = [UIImage imageNamed:@"business_bar_chart_red_arrow"];
        [self addSubview:igvRedArrow];
        [igvRedArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(-5);
            make.top.equalTo(self.lblDateAccount.mas_bottom).with.offset(5);
            make.width.equalTo(@(14));
            make.height.equalTo(@(11));
        }];
        
        [self addSubview:self.histogramView];
        [self.histogramView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(70);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-5);
            make.height.equalTo(@70);
        }];
    
    }
    
    return self;
}

- (void)configureViewWithDayList:(NSArray<TDFBusinessInfoModel *> *)dayList monthDate:(NSString *)monthDate
{
    self.isDayStyle = YES;
    self.modelList = dayList;
//    self.monthDate = monthDate;
    [self.histogramView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(-4);
    }];
    [self layoutIfNeeded];
    
    self.histogramView.modelList = [self generateHistogramModelListWithModelList:self.modelList];
}

- (void)configureViewWithMonthList:(NSArray<TDFBusinessInfoModel *> *)monthList
{
    self.isDayStyle = NO;
    self.modelList = monthList;
    
    [self.histogramView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(3);
    }];
    [self layoutIfNeeded];
    self.histogramView.modelList = [self generateHistogramModelListWithModelList:self.modelList];
}

- (void)configureTitleWithSytle:(BOOL)isDayStyle dateString:(NSString *)dateString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (isDayStyle) {
        dateFormatter.dateFormat = @"yyyyMMdd";
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];

        self.lblDateTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%ld年%ld月%ld日 %@", nil), (long)[components year], (long)[components month], (long)[components day], [DateUtils getWeeKName:[components weekday]]];

    } else {
        dateFormatter.dateFormat = @"yyyyMM";
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        
        self.lblDateTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%ld年%ld月", nil), (long)[components year], (long)[components month]];
    }
    
}

- (void)configureAccountWithAccount:(double)account
{
    self.lblDateAccount.text = [NSString stringWithFormat:NSLocalizedString(@"收益：%@元", nil), [FormatUtil formatDoubleWithSeperator:account]];
}


- (NSArray *)generateHistogramModelListWithModelList:(NSArray<TDFBusinessInfoModel *> *)modelList
{
    NSMutableArray *histogramModelList = [NSMutableArray array];
    
    double maxAccount = [self generateMaxAccountWithInfoModelList:modelList];
    
    for (int i = 0; i < modelList.count; i++) {
        TDFBusinessInfoModel *infoModel = modelList[i];
        
        TDFHistogramModel *model = [[TDFHistogramModel alloc] init];
        
        model.title = self.isDayStyle ? [self generateWeekNameWithDayString:infoModel.date] : [self generateMonthNameWithMonthString:infoModel.date];
        model.count = infoModel.actualAmount;
        model.heightRatio = maxAccount == 0 ? 0 : infoModel.actualAmount / maxAccount;
        
        if (self.isDayStyle && [model.title isEqualToString:@"日"]) { // 如果过是周日，则显示特殊的颜色
            model.specialDotColor = [UIColor whiteColor];
        }
        
        [histogramModelList addObject:model];
    }
    
    return histogramModelList;
}

- (double)generateMaxAccountWithInfoModelList:(NSArray<TDFBusinessInfoModel *> *)infoModelList
{
    double maxAccount = 0;
    
    for (TDFBusinessInfoModel *infoModel in infoModelList) {
        if (infoModel.actualAmount > maxAccount) {
            maxAccount = infoModel.actualAmount;
        }
    }
    
    return maxAccount;
}

- (NSString *)generateWeekNameWithDayString:(NSString *)dayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:dayString];

    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSString *weekDay = [NSString stringWithFormat:@"%i", (int)components.weekday];
    
    return self.weekDict[weekDay];
}

- (NSString *)generateMonthNameWithMonthString:(NSString *)monthString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMM";
    NSDate *date = [dateFormatter dateFromString:monthString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    NSString *monthNum = [NSString stringWithFormat:@"%i", (int)components.month];
    
    return self.monthDict[monthNum];
}

+ (CGFloat)heightForChartView
{
    return kChartViewHeight;
}

- (NSInteger)getTodayNum
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [components day];
}

#pragma mark -- TDFHistogramViewDelegate --

- (void)histogramView:(TDFHistogramView *)view didScrollToModel:(TDFHistogramModel *)model index:(NSInteger)index
{
    NSInteger dayIndex = index;
    if (dayIndex >= self.modelList.count) {
        return ;
    }
    TDFBusinessInfoModel *currentModel = self.modelList[dayIndex];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (self.isDayStyle) {
        dateFormatter.dateFormat = @"yyyyMMdd";
        NSDate *date = [dateFormatter dateFromString:currentModel.date];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
        
        if ([self.delegate respondsToSelector:@selector(chartView:dayDidChanged:dayDate:)]) {
            [self.delegate chartView:self dayDidChanged:currentModel dayDate:[NSString stringWithFormat:@"%i", (int)[components day]]];
        }
    } else {
        dateFormatter.dateFormat = @"yyyyMM";
        NSDate *date = [dateFormatter dateFromString:currentModel.date];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
        
        if ([self.delegate respondsToSelector:@selector(chartView:monthDidChanged:monthDate:)]) {
            [self.delegate chartView:self monthDidChanged:currentModel monthDate:[NSString stringWithFormat:@"%i", (int)[components month]]];
        }
    }
    
    // congif title account
    [self configureTitleWithSytle:self.isDayStyle dateString:currentModel.date];
    
    [self configureAccountWithAccount:currentModel.actualAmount];
}

- (CGFloat)histogramItemViewWidth:(TDFHistogramView *)view
{
    if (self.isDayStyle) {
        return 16;
    } else {
        return 30;
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)lblDateTitle
{
    if (!_lblDateTitle) {
        _lblDateTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDateTitle.font = [UIFont systemFontOfSize:15];
        _lblDateTitle.textColor = [UIColor whiteColor];
        _lblDateTitle.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblDateTitle;
}

- (UILabel *)lblDateAccount
{
    if (!_lblDateAccount) {
        _lblDateAccount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblDateAccount.font = [UIFont systemFontOfSize:12];
        _lblDateAccount.textColor = [UIColor whiteColor];
        _lblDateAccount.textAlignment = NSTextAlignmentCenter;
    }
    
    return _lblDateAccount;
}

- (TDFHistogramView *)histogramView
{
    if (!_histogramView) {
        _histogramView = [[TDFHistogramView alloc] initWithFrame:CGRectZero];
        _histogramView.delegate = self;
    }
    
    return _histogramView;
}

- (NSDictionary *)weekDict
{
    if (!_weekDict) {
        _weekDict = @{@"2": @"一", @"3": @"二", @"4": @"三", @"5": @"四", @"6": @"五", @"7": @"六", @"1": @"日"};
    }
    
    return _weekDict;
}

- (NSDictionary *)monthDict
{
    if (!_monthDict) {
        _monthDict = @{@"1" : @"一", @"2" : @"二", @"3" : @"三", @"4" : @"四", @"5" : @"五", @"6" : @"六", @"7" : @"七", @"8" : @"八", @"9" : @"九", @"10" : @"十", @"11" : @"十一", @"12" : @"十二"};
    }
    
    return _monthDict;
}

@end
