//
//  SpecialReasonListView.h
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "OptionPickerClient.h"
@class SettingService,ConfigVO;
@interface SpecialReasonListView : SampleListView<ISampleListEvent,OptionPickerClient>{
    SettingService *service;
}

@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;
@property (nonatomic,retain) NSMutableArray *idList;    //商品.

@property (nonatomic,strong) NSString* dicCode;
@property (nonatomic,strong) NSString* currTitleName;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
