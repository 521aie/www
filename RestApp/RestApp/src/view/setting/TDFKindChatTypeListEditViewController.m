//
//  TDFKindChatTypeListEditViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindChatTypeListEditViewController.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"

@interface TDFKindChatTypeListEditViewController ()

@property (nonatomic,strong) DHTTableViewManager *manager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TDFTextfieldItem *typeNameItem;
@property (nonatomic,strong) UIButton *delBtn;
@property (nonatomic,strong) UIView *tableViewFooterView;

@end

@implementation TDFKindChatTypeListEditViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.typeName;
    self.manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.typeNameItem];
    
    [self.manager addSection:section];
    
    [self configView];
}

#pragma mark - Config View

- (void)configView {
    [self.view addSubview:self.tableView];
    [self.tableViewFooterView addSubview:self.delBtn];
    self.tableView.tableFooterView = self.tableViewFooterView;
}

#pragma mark - Method

- (void)delBtnClick {
    
}

#pragma mark - Accessor

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    return _tableView;
}

- (TDFTextfieldItem *)typeNameItem {
    if (!_typeNameItem) {
        _typeNameItem = [[TDFTextfieldItem alloc] init];
        _typeNameItem.title = @"分类名称";
        _typeNameItem.textValue = self.typeName;
        _typeNameItem.editStyle = TDFEditStyleUnEditable;
    }
    return _typeNameItem;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-20, 40)];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_delBtn setBackgroundColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
        _delBtn.layer.masksToBounds = YES;
        _delBtn.layer.cornerRadius = 6;
        [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

- (UIView *)tableViewFooterView {
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH-20, 60)];
    
    }
    return _tableViewFooterView;
}

@end
