//
//  TDFHomeReportMonthView.m
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import "TDFHomeReportMonthView.h"
#import "TDFHistogramView.h"
#import "TDFDateUtil.h"
#import "TDFNumberUtil.h"

@interface TDFHomeReportMonthView ()

@property (nonatomic, copy) NSDictionary *monthDict;

@end
@implementation TDFHomeReportMonthView

#pragma mark -- TDFHomeReportHistogramProtocol --

- (TDFHistogramModel *)transformReportModelToHistogramModel:(TDFHomeReportHistogramModel *)reportModel maxAccount:(double)maxAccount
{
    TDFHistogramModel *model = [[TDFHistogramModel alloc] init];
    
    model.title = [self generateMonthNameWithMonthString:reportModel.date];
    model.count = reportModel.dAccount;
    model.heightRatio = maxAccount == 0 ? 0 : reportModel.dAccount / maxAccount;
    
    return model;
}

- (CGFloat)histogramItemWidth
{
    return 30;
}

- (void)updateHistogramMasonry
{
    self.histogramView.frame = CGRectMake(10, 70, SCREEN_WIDTH - 20 - 8, 70);

    [self layoutIfNeeded];
}

- (void)configureTitleWithModel:(TDFHomeReportHistogramModel *)reportModel
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", [TDFDateUtil chineseDateStringWithMonthString:reportModel.date]];
    
    self.subTitleLabel.text = [NSString stringWithFormat:@"收益：%@%@", [TDFNumberUtil seperatorDotStringWithDouble:reportModel.dAccount], [TDFNumberUtil unitWithNum:reportModel.dAccount baseUnit:@"元"]];
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

- (NSDictionary *)monthDict
{
    if (!_monthDict) {
        _monthDict = @{@"1" : @"一", @"2" : @"二", @"3" : @"三", @"4" : @"四", @"5" : @"五", @"6" : @"六", @"7" : @"七", @"8" : @"八", @"9" : @"九", @"10" : @"十", @"11" : @"十一", @"12" : @"十二"};
    }
    
    return _monthDict;
}

@end
