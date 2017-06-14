//
//  SeatListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "ISampleListEvent.h"
#import "SignBillPayNoPayOptionTotalVO.h"
#import "TDFRootViewController.h"
@interface SignBillRecordView : TDFRootViewController<INavigateEvent, ISampleListEvent, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *signBillList;
@property (nonatomic, strong) void(^callBack)(void);
@property (nonatomic) BOOL hasData;
@property (nonatomic) int currPage;      //当前页.
@property (nonatomic) int pageNum;       //总页数.
@property (nonatomic) int act;           //行为.

@end
