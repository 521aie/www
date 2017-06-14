//
//  JsonUtil.m
//  CardApp
//
//  Created by 邵建青 on 14-1-22.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "JsonUtil.h"
#import <objc/runtime.h>
#import "NSString+Estimate.h"

@implementation JsonUtil

+ (id)jsonTransformation:(NSString *)jsonstring
{
    if ([NSString isNotBlank:jsonstring]) {
        NSData *dataJosn=[jsonstring dataUsingEncoding: NSUTF8StringEncoding];
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:dataJosn options:NSJSONReadingMutableLeaves error:&error];
        if (jsonObject != nil && error == nil) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                return deserializedDictionary;
            } else if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSArray *deserializedArray = (NSArray *)jsonObject;
                return  deserializedArray;
            } else {
                return  nil;
            }
        }
    }
    return  nil;
}

+ (NSString *)convertToJson:(id)object
{
    if (object != nil) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([object class], &outCount);
        NSString *json = @"{";
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *key=[[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [object valueForKey:key];
            if (value != nil) {
                if (![value isKindOfClass:[NSString class]]) {
                    json = [json stringByAppendingFormat:@"\"%@\":%@,",key,[JsonUtil convertToJson:[object valueForKey:key]]];
                } else {
                    json = [json stringByAppendingFormat:@"\"%@\":\"%@\",",key,value];
                }
            } else {
                json = [json stringByAppendingFormat:@"\"%@\":\"%@\",",key,@""];
            }
        }    json = [json substringToIndex:json.length-1];
        json = [json stringByAppendingString:@"}"];
        free(properties);
        return json;
    }
    return nil;
}

+ (NSDate *)stringTransformDate:(NSString *)strdate
{
    if ([NSString isNotBlank:strdate]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm:ss a"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSDate *sendDate = [dateFormatter dateFromString:strdate];
        return sendDate;
    }
    return nil;
}

+ (NSString *)dateTransformString:(NSDate *)date
{
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm:ss a"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

@end
