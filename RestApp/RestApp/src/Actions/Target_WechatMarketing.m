//
//  Target_WechatMarketing.m
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_WechatMarketing.h"
#import "TDFWechatMarketingViewController.h"
@implementation Target_WechatMarketing  //!OCLint

- (UIViewController *)Action_nativeWechatMarketingViewController:(NSDictionary *)params { //!OCLint
    TDFWechatMarketingViewController *viewController = [[TDFWechatMarketingViewController alloc] init];
    viewController.codeArray = params[@"data"][@"actionCodeArrs"];
    viewController.childFunctionArr = params[@"data"][@"isOpenFunctionArrs"];
    return viewController;
}

@end
