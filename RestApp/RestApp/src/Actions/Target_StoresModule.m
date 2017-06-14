//
//  Target_StoresModule.m
//  RestApp
//
//  Created by zishu on 16/8/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_StoresModule.h"
#import "StoresView.h"
#import "StoresManagerView.h"

#import "SystemUtil.h"

@implementation Target_StoresModule

- (UIViewController *)Action_nativeStoresListViewController:(NSDictionary *)params
{
   StoresView *storesListView = [[StoresView alloc]init];
    return storesListView;
}

- (UIViewController *)Action_nativeEditStoresViewController:(NSDictionary *)params{
    StoresManagerView *storesManagerViewController = [[StoresManagerView alloc] init];
    storesManagerViewController.shopId = params[@"shopId"];
    storesManagerViewController.editStoresCallBack = params[@"editAction"];
    return storesManagerViewController;
}
@end
