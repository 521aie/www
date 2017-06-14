//
//  TDFDateUtil.m
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import "TDFDateUtil.h"

@implementation TDFDateUtil

+ (NSString *)weekNameWithDayString:(NSString *)dayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:dayString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSString *weekDay = [NSString stringWithFormat:@"%i", (int)components.weekday];
    
    NSDictionary *weekDict = @{@"2": @"一", @"3": @"二", @"4": @"三", @"5": @"四", @"6": @"五", @"7": @"六", @"1": @"日"};

    return weekDict[weekDay];
}

+ (NSString *)chineseDateStringWithDayString:(NSString *)dayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:dayString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return [NSString stringWithFormat:@"%i年%02i月%02i日", (int)components.year, (int)components.month, (int)components.day];
}

+ (NSString *)chineseDateStringWithMonthString:(NSString *)monthString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyyMM";
    NSDate *date = [dateFormatter dateFromString:monthString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    return [NSString stringWithFormat:@"%i年%02i月", (int)components.year, (int)components.month];
}

+ (NSString *)fullWeekNameWithDayString:(NSString *)dayString
{
    return [NSString stringWithFormat:@"星期%@", [TDFDateUtil weekNameWithDayString:dayString]];
}

+ (NSString *)monthNameWithMonthString:(NSString *)monthString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMM";
    NSDate *date = [dateFormatter dateFromString:monthString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    NSString *monthNum = [NSString stringWithFormat:@"%i", (int)components.month];
    
    NSDictionary *monthDict = @{@"1" : @"一", @"2" : @"二", @"3" : @"三", @"4" : @"四", @"5" : @"五", @"6" : @"六", @"7" : @"七", @"8" : @"八", @"9" : @"九", @"10" : @"十", @"11" : @"十一", @"12" : @"十二"};
    
    return monthDict[monthNum];
}

+ (NSDateComponents *)dateComponentsWithDayString:(NSString *)dayString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:dayString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];

    return components;
}

+ (NSDateComponents *)dateComponentsWithMonthString:(NSString *)monthString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyyMM";
    NSDate *date = [dateFormatter dateFromString:monthString];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    return components;
}

@end
