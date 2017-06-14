//
//  MultiDetailManagerView.h
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiCheckManageView.h"
#import "ISampleListEvent.h"

@class MultiDetailView;
@interface MultiMasterManagerView : MultiCheckManageView<ISampleListEvent>

@property (nonatomic, strong) NSMutableDictionary *detailMap;
//@property (nonatomic, strong) MultiDetailView* multiDetailView;
@property (nonatomic, strong) NSString* detailName;


- (void)loadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap selectList:(NSMutableArray*) selectList detailName:(NSString*)detailName;

- (void)reLoadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap;

@end
