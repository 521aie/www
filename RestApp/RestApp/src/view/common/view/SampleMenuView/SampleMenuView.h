//
//  SampleMenuView.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ISampleMenuHandle.h"
#import "FooterListView.h"

@class NavigateTitle;
@interface SampleMenuView : UIViewController<UITableViewDataSource,UITableViewDelegate,INavigateEvent,FooterListEvent>

@property (nonatomic, strong) id<ISampleMenuHandle> delegate;

@property (nonatomic, strong) IBOutlet NavigateTitle *titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet FooterListView *footerListView;

@property (nonatomic, strong) NSMutableArray *datas;    //原始数据集
@property (nonatomic, strong) NSString* event;


- (void)initDelegate:(id<ISampleMenuHandle>) _delegateTemp event:(NSString*) _eventTemp title:(NSString*) titleName;

- (void)reload:(NSMutableArray*) _dataTemps;

-(void) initHead;
@end
