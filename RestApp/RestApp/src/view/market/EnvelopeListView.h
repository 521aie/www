//
//  CustomerListView.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "EnvelopeService.h"
#import "ISampleListEvent.h"

@class MarketModule;
@interface EnvelopeListView : SampleListView<ISampleListEvent>
{
    MarketModule *parent;
    
    EnvelopeService *service;
    
    BOOL isRefreshed;
}

@property (nonatomic, strong) IBOutlet UIView *noDataTip;
@property (nonatomic, strong) NSMutableDictionary *dataMap;
@property (nonatomic, assign) NSInteger eventType;
@property (nonatomic, strong) Coupon *coupon;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;

- (void)loadDatas;

-(void)loadEvent:(NSInteger)event;

@end
