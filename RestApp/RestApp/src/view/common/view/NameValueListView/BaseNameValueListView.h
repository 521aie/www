//
//  BaseNameValueListView.h
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController.h"

@class NavigateTitle2,SettingModule,FooterListView,MBProgressHUD;
@interface BaseNameValueListView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,INavigateEvent,FooterListEvent>
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) NSMutableArray *datas;    //原始数据集
@property (nonatomic, strong) NSMutableArray *backDatas; //备份数据集
@property (nonatomic, strong)NSString* event;
@property (nonatomic) int action;

- (void)initDelegate:(id<ISampleListEvent>) _delegateTemp event:(NSString*) _eventTemp title:(NSString*) titleName foots:(NSArray*) arr;

- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error;

- (void)beginEditGrid;

- (void)finishSort;

- (void)hideHud;

@end
