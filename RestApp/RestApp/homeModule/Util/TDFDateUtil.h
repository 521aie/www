//
//  TDFDateUtil.h
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import <Foundation/Foundation.h>

@interface TDFDateUtil : NSObject

/**
 根据日期返回星期几

 @param dayString 格式 20170101
 @return 类似 一，二。。。日
 */
+ (NSString *)weekNameWithDayString:(NSString *)dayString;

/**
 根据日期返回 日期中文表示
 
 @param dayString 格式 20170101
 @return 2017年1月1日
 */
+ (NSString *)chineseDateStringWithDayString:(NSString *)dayString;

/**
 根据日期返回 日期中文表示
 
 @param dayString 格式 201701
 @return 2017年1月
 */
+ (NSString *)chineseDateStringWithMonthString:(NSString *)monthString;

/**
 根据日期返回星期几
 
 @param dayString 格式 20170101
 @return 类似 星期一，星期二。。。星期日
 */
+ (NSString *)fullWeekNameWithDayString:(NSString *)dayString;

/**
 根据日期返回月份

 @param monthString 格式 201701
 @return 类似 一，二。。。十一，十二
 */
+ (NSString *)monthNameWithMonthString:(NSString *)monthString;

/**
 根据日期返回dateComponents
 
 @param dayString 格式 20170101
 @return dateComponents
 */
+ (NSDateComponents *)dateComponentsWithDayString:(NSString *)dayString;

/**
 根据日期返回dateComponents
 
 @param dayString 格式 201701
 @return dateComponents
 */
+ (NSDateComponents *)dateComponentsWithMonthString:(NSString *)monthString;

@end
