//
//  PrinterService.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PrinterService.h"
#import "RestConstants.h"
#import "JsonHelper.h"
#import "MobileUtil.h"
#import "SignUtil.h"
#import "Platform.h"
#import "JSONKit.h"
#import "NSString+Estimate.h"
@implementation PrinterService

- (BOOL)printData:(NSString *)host port:(int)port data:(NSData *)data delegate:(id<NSStreamDelegate>)delegate
{
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, NULL, &writeStream);
    NSOutputStream *outputStream = (__bridge NSOutputStream *)(writeStream);
    
    [outputStream open];
    outputStream.delegate = delegate;
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream write:data.bytes maxLength:data.length];
    [outputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    return true;
}

@end
