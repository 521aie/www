//
//  TimeArrangeListView.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "ISampleListEvent.h"
@class SettingService;
@interface TimeArrangeListView : SampleListView<ISampleListEvent>{
    SettingService *service;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)loadDatas;
@end
