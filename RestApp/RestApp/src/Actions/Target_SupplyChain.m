//
//  Target_SupplyChain.m
//  TDFSupplyChain
//
//  Created by 於卓慧 on 5/21/16.
//  Copyright © 2016 2dfire. All rights reserved.
//

#import "Target_SupplyChain.h"
#import "MultiCheckView.h"
#import "SystemUtil.h"
@implementation Target_SupplyChain


- (UIViewController *)Action_nativeMultiCheckViewController:(NSDictionary *)params
{
    MultiCheckView *multiCheckViewController = [[MultiCheckView alloc] init];
    multiCheckViewController.needHideOldNavigationBar = params[@"needHideOldNavigationBar"];
    [multiCheckViewController initDelegate:[params[@"event"] intValue] delegate:params[@"delegate"] title:params[@"titleName"]];
    [multiCheckViewController reload:params[@"dataTemps"] selectList:params[@"selectList"]];
    return multiCheckViewController;
}  

@end
