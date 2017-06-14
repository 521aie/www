//
//  CustomerListView.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "FooterListEvent.h"
#import "LifeInfoService.h"
#import "ISampleListEvent.h"
#import "MessageBoxClient.h"
#import "TDFRootViewController.h"
@class MarketModule;
@interface LifeInfoListView : SampleListView<ISampleListEvent, MessageBoxClient, FooterListEvent>
{
    MarketModule *parent;
    
    LifeInfoService *service;
    
    Notification *currentNotification;
}

@property (nonatomic, strong) IBOutlet UIView *noDataTip;
@property (nonatomic) NSInteger page;
@property (nonatomic ,assign) NSInteger eventType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;

- (void)loadDatas;
- (void)removeLifeInfo:(Notification *)notification;
-(void)loadEvent:(NSInteger)event;

@end
