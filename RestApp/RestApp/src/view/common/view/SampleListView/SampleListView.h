//
//  SampleListView.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "FooterListView.h"
#import "TDFRootViewController.h"

@class NavigateTitle2,FooterListView,MBProgressHUD;
@interface SampleListView : TDFRootViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, INavigateEvent, FooterListEvent>
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet FooterListView *footView;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) id<ISampleListEvent> delegate;

@property (nonatomic, strong) NSMutableArray *datas;    //原始数据集
@property (nonatomic, strong) NSString* titleName;
@property (nonatomic, strong) NSString* event;
@property (nonatomic) NSInteger action;
@property (nonatomic, strong) NSDictionary * dic ;//传值dic

- (void)initHead;

- (void)initDelegate:(id<ISampleListEvent>)delegateTemp event:(NSString *)eventTemp title:(NSString *)titleName foots:(NSArray *)arr;

@end
