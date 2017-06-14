//
//  UnitListView.h
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuModule.h"
#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "NavigationToJump.h"
#import "TDFRootViewController+AlertMessage.h"

@class MenuModule,NameItemVO;

@protocol UnitListViewDelegate <NSObject>

- (void)unitListView:(UnitListView *)view unitList:(NSArray *)unitList;

@end

@interface UnitListView : SampleListView<ISampleListEvent,UIActionSheetDelegate,NavigationToJump>
{
    MenuModule *parent;
}
@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSArray* defaultList;
@property (nonatomic) NSInteger currentEvent;

@property (nonatomic, weak) id<UnitListViewDelegate> unitDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;

- (void)loadDatas:(NSInteger)eventTemp;

- (void)reloadDatas;

@end
