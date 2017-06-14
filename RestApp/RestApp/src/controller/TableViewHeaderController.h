//
//  TableViewHeaderController.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
@interface TableViewHeaderController : TDFRootViewController<UITableViewDataSource,UITableViewDelegate >

@property (nonatomic, strong) IBOutlet UITableView *mainGrid;
@property (nonatomic, strong) UIView *headerView;

- (void)initHeaderView;

- (void)refreshHeaderView;

@end
