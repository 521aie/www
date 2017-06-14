//
//  TDFKindCharTypeListAddViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindCharTypeListAddViewController.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"

@interface TDFKindCharTypeListAddViewController ()
@property (nonatomic,strong) DHTTableViewManager *manager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TDFTextfieldItem *typeNameItem;
@end

@implementation TDFKindCharTypeListAddViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加";
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:@"取消"];
    [self configRightNavigationBar:@"ico_ok.png" rightButtonName:@"保存"];
    [self configView];
}

#pragma mark - Config View

- (void)configView {
    self.manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    DHTTableViewSection *section = [DHTTableViewSection section];
    [section addItem:self.typeNameItem];
    [self.manager addSection:section];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Method

- (void)leftNavigationButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender {
    
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
    }
    return _typeNameItem;
}


@end
