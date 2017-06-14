//
//  SignBillListView.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "PairPickerClient.h"

@class SettingService,KindPay,KindPayDetail;
@interface SignBillListView : SampleListView<ISampleListEvent,PairPickerClient>
{
    SettingService *service;
}

@property (nonatomic, strong) NSMutableArray *kindPayList;    //商品.
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *detailNameMap;
@property (nonatomic, strong) NSMutableDictionary* optionMap;

@property (nonatomic, strong) NSMutableDictionary* optionDic;
@property (nonatomic, strong) NSMutableArray *kindPayNameList;    //商品.

@property (nonatomic, strong) NSMutableArray *idList;    //商品.
@property (nonatomic, strong) KindPay* currKindPay;
@property (nonatomic, strong) KindPayDetail* currKindPayDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
