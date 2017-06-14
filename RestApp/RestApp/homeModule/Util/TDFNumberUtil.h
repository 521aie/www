//
//  TDFNumberUtil.h
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import <Foundation/Foundation.h>

@interface TDFNumberUtil : NSObject

//+ (NSString *)numberToSeperatorDotString:(NSNumber *)number;


/**
 根据 数值 和 基本单位 返回 缩略单位

 @param num 数值 double 可以转 int 调用，不会影响单位
 @param baseUnit 基本单位 ， 类似 元， 人 。。。
 @return 缩略单位 10000 人 则 返回 万人
 */
+ (NSString *)unitWithNum:(int)num baseUnit:(NSString *)baseUnit;


/**
 格式化 int ， 10000 会变成 1

 @param i 要格式化的数字
 @return 1
 */
+ (NSString *)seperatorDotStringWithInt:(int)i;

/**
 格式化 double ， 10000.00 会变成 1
 
 @param i 要格式化的数字
 @return 1.00
 */
+ (NSString *)seperatorDotStringWithDouble:(double)d;

+ (double)dotStringToDouble:(NSString *)numberString;

@end
