//
//  TransService.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "Pantry.h"
#import "BackupPrinter.h"

@interface TransService : BaseService


/**
 *  添加打印设置(区域打印)
 */
-(void)saveAreaPrinterSetting:(AreaPantry *)areaPantry target: (id)target callback:(SEL)callback;

/**
 *  更新打印机设置(区域打印)
 */

-(void)updateAreaPrinterSetting:(AreaPantry *)areaPantry target: (id)target callback:(SEL)callback;

/**
 *  删除打印机设置(区域打印)
 */
-(void)deleteAreaPrinter:(NSString *)printerId target: (id)target callback:(SEL)callback;

@end
