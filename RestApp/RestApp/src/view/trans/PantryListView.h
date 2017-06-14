//
//  PantryListView.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameValueListView.h"
#import "ISampleListEvent.h"
#import "SampleListView.h"

@interface PantryListView : SampleListView<ISampleListEvent>

@property (nonatomic, copy) NSString *plateEntityId;

@end
