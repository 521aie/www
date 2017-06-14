//
//  MakeListView.h
//  RestApp
//
//  Created by zxh on 14-5-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ISampleListEvent.h"
#import "SampleListView.h"
#import "INameValueItem.h"
#import "TDFMenuService.h"
#import "NavigationToJump.h"

@class MenuModule;
@interface MakeListView :  SampleListView<ISampleListEvent,UIActionSheetDelegate,NavigationToJump>{
    MenuModule *parent;
}

@property (nonatomic,retain) id<INameValueItem> currObj;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;

-(void)loadDatas:(NSMutableArray*) makes;
@property (nonatomic,copy) void (^menuMakelistCallBack)(BOOL orRefresh);
@property (nonatomic, assign) NSInteger backIndex;
-(void)reLoadData;
- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuMakelistCallBack;
@end
