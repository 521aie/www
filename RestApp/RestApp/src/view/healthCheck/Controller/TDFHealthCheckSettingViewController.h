//
//  TDFHeathCheckSettingViewController.h
//  RestApp
//
//  Created by xueyu on 2016/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <TDFLoginPod/TDFLoginPod.h>
#import "TDFRootViewController.h"
#import "TDFHealthCheckHomePageModel.h"

@interface TDFHealthCheckSettingViewController : TDFRootViewController
@property (nonatomic, copy) void(^callback)();
@property (nonatomic, assign) BOOL isFirstTime;
@property (nonatomic, strong)TDFHealthCheckHomePageModel* homePage;
@end
