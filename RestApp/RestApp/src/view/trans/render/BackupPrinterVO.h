//
//  BackupPrinterVO.h
//  RestApp
//
//  Created by iOS香肠 on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackupPrinterVO : NSObject

/**
 * 主键id
 */
@property (nonatomic ,strong) NSString *backupPrinterId;
/**
 * 原始打印机ip
 */
@property (nonatomic ,strong) NSString *originIp;
/**
 * 备用打印机id
 */
@property (nonatomic ,strong) NSString *backupIp;
/**
 * 版本号
 */
@property (nonatomic ,strong) NSString *lastVer;

@end
