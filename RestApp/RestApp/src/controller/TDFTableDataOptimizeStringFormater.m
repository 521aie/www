//
//  TDFTableDataOptimizeStringFormater.m
//  RestApp
//
//  Created by LSArlen on 2017/6/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableDataOptimizeStringFormater.h"

@implementation TDFTableDataOptimizeStringFormater

+ (NSString *)stringByBillOptimizeType:(int)type {
    return type == 0 ? @"根据营业额" : @"根据账单数量";
}
+ (int)typeOfBillOptimizeString:(NSString *)typeString {
    return [typeString isEqualToString:@"根据营业额"] ? 0 : 1;
}
+ (NSString *)stringByMethodType:(int)type {
    return type == 0 ? @"手动优化" : @"自动优化";
}
+ (int)typeByMethodString:(NSString *)method {
    return ![method isEqualToString:@"手动优化"];
}

@end
