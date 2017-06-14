//
//  Target_KitchenModule.m
//  RestApp
//
//  Created by suckerl on 2017/6/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_KitchenModule.h"
#import "TDFSunOfKitchenViewController.h"

@implementation Target_KitchenModule

- (UIViewController *)Action_kitchen:(NSDictionary *)params {
    TDFSunOfKitchenViewController *viewController = [[TDFSunOfKitchenViewController alloc]init];
    return viewController;
}
@end
