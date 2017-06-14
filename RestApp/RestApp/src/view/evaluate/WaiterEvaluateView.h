//
//  WaiterEvaluateView.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "ActionConstants.h"
#import "TDFRootViewController.h"

@interface WaiterEvaluateView : TDFRootViewController<INavigateEvent,UITableViewDelegate,UITableViewDataSource>
{
    
    BOOL isRefreshed;
}

@property (nonatomic, strong) IBOutlet UITableView *mainGrid;
@property (nonatomic, strong) IBOutlet UIView *noDataTip;
@property (nonatomic, strong) IBOutlet UILabel *contentTip;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;

- (void)initDataView;

@end
