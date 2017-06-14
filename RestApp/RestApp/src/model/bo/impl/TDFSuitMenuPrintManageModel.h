//
//  TDFSuitMenuPrintManageModel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFSuitMenuPrinterModel.h"

@interface TDFSuitMenuPrintManageModel : NSObject
//可修改连锁数据
@property (nonatomic,assign) BOOL chainDataManageable;

//manageable可添加门店数据
@property (nonatomic,assign) BOOL addible;

@property (nonatomic,copy) NSMutableArray *kindMenuList;
@end
