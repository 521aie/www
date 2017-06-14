//
//  TDFKindCharTypeListViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindCharTypeListViewController.h"
#import "TDFKindCharTypeListCell.h"
#import "TDFKindChatTypeListEditViewController.h"
#import "TDFKindCharTypeListAddViewController.h"
@interface TDFKindCharTypeListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *addBtn;

@end
@implementation TDFKindCharTypeListViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报表统计分类";
    [self configView];
}

- (void)configView {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.addBtn];

    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@56);
        make.width.equalTo(@56);
    }];
}

#pragma mark - Tableview delegate && datasource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFKindCharTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartypecell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFKindChatTypeListEditViewController *vc = [[TDFKindChatTypeListEditViewController alloc] init];
    vc.typeName = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Method

- (void)addBtnClick {
    TDFKindCharTypeListAddViewController *vc = [[TDFKindCharTypeListAddViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Accessor

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableFooterView.frame = CGRectZero;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[TDFKindCharTypeListCell class]  forCellReuseIdentifier:@"chartypecell"];
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"分类一",@"分类二",@"分类三",@"分类四", nil];
    }
    return _dataArray;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"ico_footer_button_addd"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
