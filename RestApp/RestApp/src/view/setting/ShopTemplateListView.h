//
//  ShopTemplateListView.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "SettingService.h"


@interface ShopTemplateListView : SampleListView<ISampleListEvent>{
    SettingService *service;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
