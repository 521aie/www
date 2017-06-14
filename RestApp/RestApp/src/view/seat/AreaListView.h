//
//  AreaListView.h
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//


#import "SampleListView.h"
#import "ISampleListEvent.h"
typedef void(^AreaListViewCallBack) ();
@interface AreaListView : SampleListView<ISampleListEvent>

@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic,copy)AreaListViewCallBack callBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
