//
//  AppDelegate.h
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
///Users/apple/restapp/RestApp/RestApp/AppDelegate.m

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MapLocationView.h"

@class AppController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) AppController *appController;

@property (nonatomic, strong) MapLocationView *maplocation;

@end
