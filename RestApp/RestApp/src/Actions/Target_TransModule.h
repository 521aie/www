//
//  Target_TransModule.h
//  RestApp
//
//  Created by 黄河 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_TransModule : NSObject

///传菜列表
- (UIViewController *)Action_nativeTDFTransModuleViewController:(NSDictionary *)params;

///加载编辑传菜方案
- (UIViewController *)Action_nativePantryEditViewController:(NSDictionary *)params;

///添加商品
- (UIViewController *)Action_nativeSelectMultiMenuListViewController:(NSDictionary *)params;

///加载传菜方案列表页
- (UIViewController *)Action_nativePantryListViewController:(NSDictionary *)params;

///不出单商品
- (UIViewController *)Action_nativeNoPrintMenuListViewController:(NSDictionary *)params;

///加载备用打印机编辑页
- (UIViewController *)Action_nativeBackupPrinterEditViewController:(NSDictionary *)params;

///加载备用打印机列表页
- (UIViewController *)Action_nativeBackupPrinterListViewController:(NSDictionary *)params;

///点菜单分区域打印编辑页
- (UIViewController *)Action_nativeMenuAreaPrinterEditViewController:(NSDictionary *)params;

///加载点菜单分区域打印列表页
- (UIViewController *)Action_nativeMenuAreaPrinterListViewController:(NSDictionary *)params;

///套餐中商品分类打印设置
- (UIViewController *)Action_nativeSuitMenuPrinterViewController:(NSDictionary *)params;
@end
