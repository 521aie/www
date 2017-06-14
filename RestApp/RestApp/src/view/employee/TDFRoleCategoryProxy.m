//
//  TDFRoleCategoryProxy.m
//  RestApp
//
//  Created by Octree on 12/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRoleCategoryProxy.h"
#import "SelectRoleCell.h"
#import "TreeNode.h"
#import "UIColor+Hex.h"

@interface TDFRoleCategoryProxy ()<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *data;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *headerView;

@end

@implementation TDFRoleCategoryProxy

- (instancetype)initWithTableView:(UITableView *)tableView data:(NSArray *)data {

    if (self = [super init]) {
        
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectRoleCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
        self.data = data;
        [self generateHeaderViewForTableView:tableView];
    }
    return self;
}

- (void)reloadWithData:(NSArray *)data {

    self.data = data;
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    TreeNode *node = self.data[indexPath.row];
    cell.lblName.text = node.itemName;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    !self.selectBlock ?: self.selectBlock(indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = self.headerView.frame;
    frame.origin.y = scrollView.contentOffset.y;
    self.headerView.frame = frame;
}

- (void)generateHeaderViewForTableView:(UITableView *)tableView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 64)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63,  tableView.frame.size.width, 1)];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [headerView addSubview:line];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ico_manage"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
    [button setTitle:@"权限分类" forState:UIControlStateNormal];
    button.frame = CGRectMake(tableView.frame.size.width - 10 - 131, 20, 131, 35);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = [UIColor whiteColor];
    CALayer *layer = button.layer;
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setCornerRadius:5.0]; //设置矩圆角半径
    UIColor* color=[[UIColor blackColor] colorWithAlphaComponent:0.1];
    [layer setBorderColor:[color CGColor]];
    [headerView addSubview:button];
    [tableView addSubview:headerView];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    self.headerView = headerView;
}

@end
