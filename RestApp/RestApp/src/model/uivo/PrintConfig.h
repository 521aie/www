//
//  PrintConfig.h
//  RestApp
//
//  Created by 邵建青 on 15/11/12.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRINT_CONFIG @"PRINT_CONFIG"

@interface PrintConfig : NSObject

@property (nonatomic, strong) NSString *ipAddr;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *widthName;
@property (nonatomic, strong) NSString *charNum;
@property (nonatomic, strong) NSString *charNumName;

+ (PrintConfig *)getPrintConfig;

+ (void)putPrintConfig:(PrintConfig *)printConfig;

@end
