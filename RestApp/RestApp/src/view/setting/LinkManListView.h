//
//  LinkManListView.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "SettingService.h"

@class SettingModule;

@interface LinkManListView : SampleListView<ISampleListEvent>{
    SettingModule *parent;
    SettingService *service;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SettingModule *)parentTemp;
-(void)loadDatas;

@end
