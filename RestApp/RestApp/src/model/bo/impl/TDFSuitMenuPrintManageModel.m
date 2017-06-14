//
//  TDFSuitMenuPrintManageModel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSuitMenuPrintManageModel.h"

@implementation TDFSuitMenuPrintManageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"kindMenuList" : [TDFSuitMenuPrinterModel class],
             };
}


@end
