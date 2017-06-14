//
//  Target_BillModifyModule.m
//  RestApp
//
//  Created by 栀子花 on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_BillModifyModule.h"
#import "SystemUtil.h"
#import "BillModifyModule.h"
#import "handleModify.h"
#import "autoModify.h"

@implementation Target_BillModifyModule
///账单优化
-(UIViewController *)Action_nativeBillModifyViewController:(NSDictionary *)params{
    BillModifyModule *billModify = [[BillModifyModule alloc]initWithNibName:@"BillModifyModule"bundle:nil parent:nil];
    billModify.needHideOldNavigationBar = YES;
    return billModify;
    
}

///手工优化
- (UIViewController *)Action_nativeHandleModifyViewController:(NSDictionary *)params{
    handleModify *handleView = [[handleModify alloc]initWithNibName:@"handleModify" bundle:nil parent:nil];
    handleView.needHideOldNavigationBar = YES;
    return handleView;
}

///自动优化
-(UIViewController *)Action_nativeAutoModifyViewController:(NSDictionary *)params{
    autoModify *autoView =[[autoModify alloc] initWithNibName:@"autoModify" bundle:nil parent:nil];
    autoView.needHideOldNavigationBar = YES;
    return autoView;
}


@end
