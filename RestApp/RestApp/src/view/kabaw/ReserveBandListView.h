//
//  ReserveBandListView.h
//  RestApp
//
//  Created by zxh on 14-5-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueListView.h"

#import "NameValueListView.h"
#import "ISampleListEvent.h"
#import "KabawModule.h"
#import "KabawService.h"

@interface ReserveBandListView : NameValueListView<ISampleListEvent>
{
    KabawModule *parent;
}
@property (nonatomic, strong)NSDictionary *params;
-(void)loadDatas;

-(void)loadBandDatas:(NSMutableArray*)datas;

@end
