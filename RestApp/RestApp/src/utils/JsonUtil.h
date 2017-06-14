//
//  JsonUtil.h
//  CardApp
//
//  Created by 邵建青 on 14-1-22.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtil : NSObject

+ (id)jsonTransformation:(NSString *)jsonstring;

+ (NSString *)convertToJson:(id)object;

+ (NSDate *)stringTransformDate:(NSString *)strdate;

+ (NSString *)dateTransformString:(NSDate *)date;

@end
