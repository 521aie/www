//
//  PrinterService.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "RemoteResult.h"

@interface PrinterService : BaseService

- (BOOL)printData:(NSString *)host port:(int)port data:(NSData *)data delegate:(id<NSStreamDelegate>)delegate;

@end
