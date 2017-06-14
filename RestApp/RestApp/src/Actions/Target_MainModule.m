//
//  Target_MainModule.m
//  RestApp
//
//  Created by chaiweiwei on 2016/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_MainModule.h"
#import "MainUnit.h"

@implementation Target_MainModule

- (UIViewController *)Action_nativeMainUnitViewController:(NSDictionary *)params {
    BOOL isHomeView = [params[@"isHomeView"] boolValue];
    
    MainUnit *mainUnitViewController = [[MainUnit alloc] init];
    mainUnitViewController.showType = isHomeView ? TDFMainShowTypeHomeView : TDFMainShowTypeEntryView;
    mainUnitViewController.reSetRootVCFromeMainUnitCallBack = params[@"editAction"];
    return mainUnitViewController;
}

@end
