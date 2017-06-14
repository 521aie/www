//
//  MultiDetailView.h
//  RestApp
//
//  Created by zxh on 14-7-31.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "MultiMasterManagerView.h"

@interface MultiDetailView : SampleListView<ISampleListEvent>

//@property (nonatomic,strong) MultiMasterManagerView* multiMasterManagerView;

-(void)loadDatas:(NSMutableArray*)datasTemp titleName:(NSString*)titleName mainView:(MultiMasterManagerView*)mainView;

- (void)showMoveIn;

- (void)hideMoveOut;

@end
