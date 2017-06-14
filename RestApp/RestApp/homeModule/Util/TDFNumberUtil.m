//
//  TDFNumberUtil.m
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import "TDFNumberUtil.h"

@implementation TDFNumberUtil

+ (NSString *)numberToSeperatorDotString:(NSNumber *)number isDouble:(BOOL)isDouble
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    [formatter setMaximumFractionDigits:2];
    
    // double类型默认至少2位小数
    if (isDouble) {
        [formatter setMinimumFractionDigits:2];
    }
    
    NSString *string = [formatter stringFromNumber:number];
    
    return string;
}

+ (NSString *)unitWithNum:(int)i baseUnit:(NSString *)baseUnit
{
    NSString *prefix = @"";
    
    if (i >= 1000000) {
        prefix = @"万";
    }
    
    if (i >= 100000000) {
        prefix = @"亿";
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, baseUnit];
}

+ (NSString *)seperatorDotStringWithInt:(int)i
{
    double bigI = i;
    
    if (i > 1000000) {
        bigI = i / 10000.0;
    }
    
    if (i > 100000000) {
        bigI = i / 100000000.0;
    }
    
    return [self numberToSeperatorDotString:@(bigI) isDouble:NO];
}

+ (NSString *)seperatorDotStringWithDouble:(double)d
{
    double bigD = d;
    
    if (d > 1000000) {
        bigD = d / 10000.0;
    }
    
    if (d > 100000000) {
        bigD = d / 100000000.0;
    }
    
    return [self numberToSeperatorDotString:@(bigD) isDouble:YES];
}

+ (double)dotStringToDouble:(NSString *)numberString
{
    NSString *noDotString = [numberString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return [noDotString doubleValue];
}

@end
