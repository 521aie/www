//
//  ZMTable.h
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "ColorHelper.h"
@interface ZMTable : UIView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ISampleListEvent,UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UIView *footView;  //页脚
@property (weak, nonatomic) IBOutlet UIImageView *addImg;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSString *kindName;
@property (nonatomic, strong) NSString *addName;
@property (nonatomic, strong) NSMutableArray *dataList;    //商品.
@property (nonatomic, strong) NSString *event;
@property (nonatomic, assign) NSUInteger detailCount;
@property (nonatomic, assign) NSInteger itemMode;
@property (nonatomic, assign) BOOL  isDelWaring;//删除cell是否提示
@property (nonatomic, assign) BOOL  isChain;
- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName itemMode:(NSInteger)mode;

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName itemMode:(NSInteger)mode isWaring:(BOOL)isWaring;

- (void)loadData:(NSMutableArray*)dataList  detailCount:(NSUInteger)detailCount;

- (IBAction)btnAddClick:(id)sender;

- (void)visibal:(BOOL)show;

@end
