//
//  BaseBackupPrinter.h
//  RestApp
//  备用打印机.
//
//  Created by zxh on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseBackupPrinter : EntityObject

/**
 * <code>原来打印机对应的IP</code>.
 */
@property (nonatomic,strong) NSString* originIp;
/**
 * <code>备用打印机对应的IP</code>.
 */
@property (nonatomic,strong) NSString* backupIp;

@property (nonatomic,strong) NSString* backupPrinterId;

@end
