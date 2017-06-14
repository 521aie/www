//
//  SelectRoleView.h
//  RestApp
//
//  Created by zxh on 14-9-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCheckHandle.h"

@interface SelectAreaPanel : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UIButton *btnSelect;  //表格
@property (nonatomic, strong) id<SingleCheckHandle> delegate;
@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic, assign) NSInteger event;

- (void)initDelegate:(id<SingleCheckHandle>)delegate event:(NSInteger)event;

- (void)loadData:(NSMutableArray *)roleList;

- (IBAction)btnRoleManagerClick:(id)sender;

@end
