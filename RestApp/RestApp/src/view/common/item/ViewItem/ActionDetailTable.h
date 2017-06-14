//
//  ActionDetailTable.h
//  RestApp
//
//  Created by zxh on 14-10-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@interface ActionDetailTable : UIView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ISampleListEvent,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *frontLine;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UIView *footView;  //页脚
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, strong) id<ISampleListEvent> delegate;

@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSString* addName;
@property (nonatomic, strong) NSMutableArray *headList;    //权限.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

@property (nonatomic, strong) NSString* event;
@property (nonatomic) NSInteger detailCount;
@property (nonatomic) NSInteger itemMode;

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event addName:(NSString*)addName itemMode:(NSInteger)mode;

- (void)loadData:(NSMutableArray*)headList details:(NSMutableDictionary *)detailMap detailCount:(NSInteger)detailCount;

- (IBAction)btnAddClick:(id)sender;

@end
