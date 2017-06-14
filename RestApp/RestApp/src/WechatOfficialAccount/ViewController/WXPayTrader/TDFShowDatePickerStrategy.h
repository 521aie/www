//
//  TDFShowDatePickerStategy.h
//  RestApp
//
//  Created by Octree on 13/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPickerActionStrategy.h"

/**
 *  使用这个 Strategy， Item 的 requestValue 的类型为 NSDate
 */

@interface TDFShowDatePickerStrategy : TDFPickerActionStrategy

@property (copy, nonatomic) NSString *pickerName;
/**
 *  日期格式， 转换成 textValue
 */
@property (copy, nonatomic) NSString *format;
/**
 *  日期选择下限
 */
@property (strong, nonatomic) NSDate *mininumDate;
/**
 *  日期选择上限
 */
@property (strong, nonatomic) NSDate *maxinumDate;
/**
 *   当前日期
 */
@property (strong, nonatomic) NSDate *currentDate;
/**
 *   DatePicker 类型
 */
@property (nonatomic) UIDatePickerMode mode;

@end
