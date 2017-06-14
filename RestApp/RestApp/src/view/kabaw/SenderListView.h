//
//  SenderListView.h
//  RestApp
//
//  Created by zxh on 14-5-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueListView.h"
#import "ISampleListEvent.h"
#import "KabawModule.h"
#import "KabawService.h"

@interface SenderListView : NameValueListView<ISampleListEvent>
@property (nonatomic,strong)NSDictionary *params;

-(void)loadDatas;
-(void)loadSenderDatas:(NSMutableArray*)datas;
@end
