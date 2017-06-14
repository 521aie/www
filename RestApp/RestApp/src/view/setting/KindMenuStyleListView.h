//
//  KindMenuStyleListView.h
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "MBProgressHUD.h"
#import "OptionPickerClient.h"

@class SettingService,KindMenuStyleVO;
@interface KindMenuStyleListView : SampleListView<ISampleListEvent,OptionPickerClient>
{
    SettingService *service;
}

@property (nonatomic,retain) NSMutableArray *options;    //原始数据集
@property (nonatomic,strong) KindMenuStyleVO* val;  //选中的值.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
