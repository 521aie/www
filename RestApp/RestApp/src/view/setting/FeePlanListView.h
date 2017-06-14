//
//  FeePlanListView.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "TDFMediator+SettingModule.h"

@class SettingService;
@interface FeePlanListView : SampleListView<ISampleListEvent>{
    SettingService *service;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
