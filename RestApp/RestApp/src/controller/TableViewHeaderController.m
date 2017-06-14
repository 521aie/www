//
//  TableViewHeaderController.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TableViewHeaderController.h"

@implementation TableViewHeaderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initHeaderView];
}

- (void)refreshHeaderView
{
    [self.mainGrid setTableHeaderView:self.headerView];
}

@end
