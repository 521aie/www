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

@class MenuModule,NameItemVO;
@class SuitUnitListView;

@protocol SuitUnitListViewDelegate <NSObject>

- (void)suitUnitListView:(SuitUnitListView *)view unitList:(NSArray *)unitList;

@end

@interface SuitUnitListView : SampleListView<ISampleListEvent,UIActionSheetDelegate>
{
    MenuModule *parent;
}
@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSArray* defaultList;
@property (nonatomic) NSInteger currentEvent;

@property (nonatomic, weak) id<SuitUnitListViewDelegate> sunitDelegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;

-(void)loadDatas:(NSInteger)eventTemp;

-(void)reloadDatas;

@end
