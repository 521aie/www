//
//  SpecListView.h
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ISampleListEvent.h"
#import "SampleListView.h"
#import "NavigationToJump.h"
#import <libextobjc/EXTScope.h>
#import "TDFMenuService.h"

@class MenuModule, MenuService;
@interface SpecListView :  SampleListView<ISampleListEvent,NavigationToJump>
{
    MenuModule *parent;
    
    MenuService *service;
    
}

@property (nonatomic,copy) void (^menuSpecslistCallBack)(BOOL orRefresh);
@property (nonatomic, assign) NSInteger backIndex;
@property (nonatomic , assign) id <NavigationToJump> popDelegate; //区别父类的delegate
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;

- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuSpecslistCallBack;

- (void)loadDatas:(NSMutableArray *) specDetailList;

- (void)reLoadData;

@end
