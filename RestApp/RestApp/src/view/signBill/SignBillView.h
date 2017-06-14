//
//  SeatListView.h
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController.h"
@interface SignBillView : TDFRootViewController<INavigateEvent,ISampleListEvent,FooterListEvent,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UILabel *lbLlbillCount;
@property (nonatomic, strong) IBOutlet UILabel *lbLlbillFee;

@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;

- (void)loadSignBillList;
@end
