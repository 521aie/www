//
//  PrintConfig.m
//  RestApp
//
//  Created by 邵建青 on 15/11/12.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PrintConfig.h"
#import "PropertyList.h"
#import "NSString+Estimate.h"

@implementation PrintConfig

+ (PrintConfig *)getPrintConfig
{
    NSDictionary *dictionary = [PropertyList readValue:PRINT_CONFIG];
    PrintConfig *printConfig = [[PrintConfig alloc]initWithDictionary:dictionary];
    return printConfig;
}

+ (void)putPrintConfig:(PrintConfig *)printConfig
{
    if (printConfig != nil) {
        NSDictionary *dictionary = [printConfig dictionaryData];
        [PropertyList updateValue:dictionary forKey:PRINT_CONFIG];
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self!=nil && dictionary!=nil) {
        self.ipAddr = [dictionary objectForKey:@"ipAddr"];
        self.width = [dictionary objectForKey:@"width"];
        self.widthName = [dictionary objectForKey:@"widthName"];
        self.charNum = [dictionary objectForKey:@"charNum"];
        self.charNumName = [dictionary objectForKey:@"charNumName"];
    }
    return self;
}

- (NSDictionary *)dictionaryData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if ([NSString isNotBlank:self.ipAddr]) {
        [dictionary setObject:self.ipAddr forKey:@"ipAddr"];
    }
    if ([NSString isNotBlank:self.width]) {
        [dictionary setObject:self.width forKey:@"width"];
    }
    if ([NSString isNotBlank:self.widthName]) {
        [dictionary setObject:self.widthName forKey:@"widthName"];
    }
    if ([NSString isNotBlank:self.charNum]) {
        [dictionary setObject:self.charNum forKey:@"charNum"];
    }
    if ([NSString isNotBlank:self.charNumName]) {
        [dictionary setObject:self.charNumName forKey:@"charNumName"];
    }
    return dictionary;
}

@end
