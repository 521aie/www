//
//  TDFTableDataOptimizeStringFormater.h
//  RestApp
//
//  Created by LSArlen on 2017/6/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFTableDataOptimizeStringFormater : NSObject

+ (NSString *)stringByBillOptimizeType:(int)type;
+ (int)typeOfBillOptimizeString:(NSString *)typeString;

+ (NSString *)stringByMethodType:(int)type;
+ (int)typeByMethodString:(NSString *)method;

@end
