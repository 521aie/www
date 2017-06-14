//
//  ReserveTimeListView.h
//  RestApp
//
//  Created by zxh on 14-5-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameValueListView.h"
#import "ISampleListEvent.h"
#import "KabawModule.h"
#import "KabawService.h"

@interface ReserveTimeListView : NameValueListView<ISampleListEvent>
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic) int kind;

@end
