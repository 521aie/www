//
//  SuitMenuDetailTable.h
//  RestApp
//
//  Created by zxh on 14-8-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZMHeadTable.h"
#import "ISampleListEvent.h"

@interface SuitMenuDetailTable : UIView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ISampleListEvent,UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) id<ISampleListEvent> delegate;

@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSString* addName;
@property (nonatomic, strong) NSMutableArray *headList;    //商品.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

@property (nonatomic, strong) NSArray *metricList;

@property (nonatomic, strong) NSString* event;
@property NSInteger detailCount;
@property NSInteger itemMode;
@property (nonatomic, assign) BOOL isChain;
- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event addName:(NSString*)addName itemMode:(NSInteger)mode;

- (void)loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount;

- (void)reloadData;

- (IBAction)btnAddClick:(id)sender;

@end
