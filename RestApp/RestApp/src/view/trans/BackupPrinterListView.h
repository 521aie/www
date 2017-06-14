//
//  BackupPrinterListView
//  RestApp
//
//  Created by SHAOJIANQING-MAC on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "NameValueListView.h"
#import "ISampleListEvent.h"
#import "SampleListView.h"

@class TransService;
@interface BackupPrinterListView : SampleListView<ISampleListEvent>{
    TransService *service;
}
-(void)loadDatas;


@end
