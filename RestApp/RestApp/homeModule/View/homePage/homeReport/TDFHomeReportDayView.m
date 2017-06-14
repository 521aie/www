//
//  TDFHomeReportDayView.m
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import "TDFHomeReportDayView.h"
#import "TDFHistogramView.h"
#import "TDFDateUtil.h"
#import "TDFNumberUtil.h"

@interface TDFHomeReportDayView ()

@property (nonatomic, copy) NSDictionary *weekDict;

@end
@implementation TDFHomeReportDayView

#pragma mark -- TDFHomeReportHistogramProtocol --

- (TDFHistogramModel *)transformReportModelToHistogramModel:(TDFHomeReportHistogramModel *)reportModel maxAccount:(double)maxAccount
{
    TDFHistogramModel *model = [[TDFHistogramModel alloc] init];

    model.title = [self generateWeekNameWithDayString:reportModel.date];
    model.count = reportModel.dAccount;
    model.heightRatio = maxAccount == 0 ? 0 : reportModel.dAccount / maxAccount;

    if ([model.title isEqualToString:@"日"]) { // 如果过是周日，则显示特殊的颜色
        model.specialDotColor = [UIColor whiteColor];
    }

    return model;
}

- (void)configureTitleWithModel:(TDFHomeReportHistogramModel *)reportModel
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@"
                            , [TDFDateUtil chineseDateStringWithDayString:reportModel.date]
                            , [TDFDateUtil fullWeekNameWithDayString:reportModel.date]];
    
    self.subTitleLabel.text = [NSString stringWithFormat:@"收益：%@%@", [TDFNumberUtil seperatorDotStringWithDouble:reportModel.dAccount], [TDFNumberUtil unitWithNum:reportModel.dAccount baseUnit:@"元"]];
}

- (CGFloat)histogramItemWidth
{
    return 20;
}

- (void)updateHistogramMasonry
{
    self.histogramView.frame = CGRectMake(10, 70, SCREEN_WIDTH - 20 - 12, 70);

    [self layoutIfNeeded];
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

- (NSDictionary *)weekDict
{
    if (!_weekDict) {
        _weekDict = @{@"2": @"一", @"3": @"二", @"4": @"三", @"5": @"四", @"6": @"五", @"7": @"六", @"1": @"日"};
    }
    
    return _weekDict;
}



@end
