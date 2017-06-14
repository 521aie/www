//
//  Target_TransModule.m
//  RestApp
//
//  Created by 黄河 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "TDFSuitMenuPrinterViewController.h"
#import "TDFTransModuleViewController.h"
#import "MenuAreaPrinterEditView.h"
#import "SelectMultiMenuListView.h"
#import "MenuAreaPrinterListView.h"
#import "BackupPrinterEditView.h"
#import "BackupPrinterListView.h"
#import "NoPrintMenuListView.h"
#import "Target_TransModule.h"
#import "PantryEditView.h"
#import "PantryListView.h"
#import "SystemUtil.h"
@implementation Target_TransModule
///传菜列表
- (UIViewController *)Action_nativeTDFTransModuleViewController:(NSDictionary *)params
{
    TDFTransModuleViewController *transModuleViewController = [[TDFTransModuleViewController alloc] init];
    transModuleViewController.codeArray = params[@"data"][@"actionCodeArrs"];
    transModuleViewController.childFunctionArr = params[@"data"][@"isOpenFunctionArrs"];
    return transModuleViewController;
}

///加载编辑传菜方案
- (UIViewController *)Action_nativePantryEditViewController:(NSDictionary *)params
{
    PantryEditView *pantryEditView = [[PantryEditView alloc] initWithNibName:@"PantryEditView" bundle:nil];
    pantryEditView.chainDataManageable = [params[@"chainDataManageable"] intValue];
    pantryEditView.pantry = params[@"data"];
    pantryEditView.plateEntityId = params[@"plateEntityId"];
    pantryEditView.action = [params[@"action"] intValue];
    pantryEditView.isContinue = [params[@"isContinue"] boolValue];
    pantryEditView.callBack = params[@"callBack"];
    pantryEditView.needHideOldNavigationBar = YES;
    return pantryEditView;
}

///添加商品
- (UIViewController *)Action_nativeSelectMultiMenuListViewController:(NSDictionary *)params
{
    SelectMultiMenuListView *menu = [[SelectMultiMenuListView alloc] initWithNibName:@"SelectMultiMenuListView" bundle:nil];
    [menu loadMenus:params[@"data"] delegate:params[@"delegate"]];
    return menu;
}

///加载传菜方案列表页
- (UIViewController *)Action_nativePantryListViewController:(NSDictionary *)params
{
    PantryListView *pantryListView=[[PantryListView alloc] initWithNibName:@"SampleListView" bundle:nil];
    pantryListView.plateEntityId = params[@"object"];
    return pantryListView;
}

///不出单商品
- (UIViewController *)Action_nativeNoPrintMenuListViewController:(NSDictionary *)params
{
    NoPrintMenuListView *menuList = [[NoPrintMenuListView alloc] init];
    menuList.plateEntityId = params[@"object"];
    return menuList;
}

///加载备用打印机编辑页
- (UIViewController *)Action_nativeBackupPrinterEditViewController:(NSDictionary *)params
{
    BackupPrinterEditView *editView = [[BackupPrinterEditView alloc]initWithNibName:@"BackupPrinterEditView" bundle:nil];
    editView.callBack = params[@"callBack"];
    editView.needHideOldNavigationBar = YES;
    [editView loadData:params[@"data"] action:[params[@"action"] integerValue]];
    return editView;
}

///加载备用打印机列表页
- (UIViewController *)Action_nativeBackupPrinterListViewController:(NSDictionary *)params
{
    BackupPrinterListView *listView = [[BackupPrinterListView alloc]initWithNibName:@"SampleListView" bundle:nil];
    listView.needHideOldNavigationBar = YES;
    return listView;
}

///点菜单分区域打印编辑页
- (UIViewController *)Action_nativeMenuAreaPrinterEditViewController:(NSDictionary *)params
{
    MenuAreaPrinterEditView *printerEdit = [[MenuAreaPrinterEditView alloc]initWithNibName:@"MenuAreaPrinterEditView" bundle:nil];
    [printerEdit loadData:params[@"data"] action:[params[@"action"] intValue] isContinue:params[@"isContinue"]];
    printerEdit.callBack = params[@"callBack"];
    return printerEdit;
}

///加载点菜单分区域打印列表页
- (UIViewController *)Action_nativeMenuAreaPrinterListViewController:(NSDictionary *)params
{
    MenuAreaPrinterListView *printerList = [[MenuAreaPrinterListView alloc]initWithNibName:@"MenuAreaPrinterListView" bundle:nil];
    return printerList;
}

///套餐中商品分类打印设置
- (UIViewController *)Action_nativeSuitMenuPrinterViewController:(NSDictionary *)params
{
    TDFSuitMenuPrinterViewController *printerViewController = [[TDFSuitMenuPrinterViewController alloc] init];
    return printerViewController;
}
@end
