//
//  Target_SuitMenuModule.m
//  RestApp
//
//  Created by 黄河 on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "SuitMenuChangeEditView.h"
#import "Target_SuitMenuModule.h"
#import "TDFMenuSelectViewController.h"
#import "TDFValutionEditViewController.h"
#import "SystemUtil.h"
@implementation Target_SuitMenuModule

///套餐选择可换商品 .
-(UIViewController *)Action_nativeSuitMenuChangeEditViewController:(NSDictionary *)params
{
     SuitMenuChangeEditView *suitMenuChangeEditView=[[SuitMenuChangeEditView alloc] initWithNibName:@"SuitMenuChangeEditView" bundle:nil parent:nil];
    suitMenuChangeEditView.sourceDic  = [NSDictionary dictionaryWithDictionary:params];
    suitMenuChangeEditView.needHideOldNavigationBar  = YES;
    
    return suitMenuChangeEditView;
}

-(UIViewController *)Action_nativeValuationEditViewController:(NSDictionary *)params
{
    TDFValutionEditViewController *valutionEditViewController = [TDFValutionEditViewController new];
    valutionEditViewController.callback = params[@"callback"];
    valutionEditViewController.action = [params[@"action"] integerValue];
    valutionEditViewController.isReload = [params[@"isReload"] boolValue];
    valutionEditViewController.suitMenuId = params[@"id"];
    valutionEditViewController.menuVo = params[@"data"];
    return valutionEditViewController;
}

-(UIViewController *)Action_nativeMenuSelectViewController:(NSDictionary *)params
{
    TDFMenuSelectViewController *menuSelectViewController = [TDFMenuSelectViewController new];
    menuSelectViewController.callback = params[@"callback"];
    menuSelectViewController.data = params[@"data"];
    return menuSelectViewController;
}
@end
