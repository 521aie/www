//
//  TDFWXPayTraderListViewController.m
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayTraderListViewController.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFWXPayTraderCell.h"
#import "UIViewController+HUD.h"
#import "TDFWXPayTraderModel.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "TDFButtonFactory.h"
#import "BackgroundHelper.h"
#import "TDFWechatMarketingService.h"
#import "YYModel.h"
#import "TDFShopSelectionViewController.h"
#import "BranchShopVo.h"
#import "TDFWXPayTraderIntroduceViewController.h"
#import "TDFWXPayTraderEditViewController.h"

@interface TDFWXPayTraderListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;

@property (copy, nonatomic) NSArray *traders;
@property (strong, nonatomic) UIButton *addButton;

@end

@implementation TDFWXPayTraderListViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}

#pragma mark - Method

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchTraders];
}

#pragma mark Config Views


- (void)configViews {
    
    [self configBackground];
    [self configNavigationBar];
    [self configContentViews];
}


- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configNavigationBar {
    
    self.title = NSLocalizedString(@"微信支付特约商户", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {
    
    @weakify(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
}

#pragma mark Network

- (void)fetchTraders {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFWechatMarketingService service] fetchTradersWithCallback:^(id responseObj, NSError *error) {
       @strongify(self);
        [self dismissHUD];
        if (error) {
        
            [self showHUBWithText:error.localizedDescription];
            return ;
        }
        
        self.traders = [NSArray yy_modelArrayWithClass:[TDFTraderModel class] json:[responseObj objectForKey:@"data"]];
        self.addButton.hidden = self.traders.count >= 30;
        [self.tableView reloadData];
    }];
}

#pragma mark Action

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addButtonTapped {
    
    TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
    vc.auditPopDepthAddition = -1;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.traders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TDFWXPayTraderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFWXPayTraderCell" forIndexPath:indexPath];
    
    TDFTraderModel *trader = self.traders[indexPath.row];
    cell.nameLabel.text = trader.name;
    cell.badgeLabel.text = trader.status == TDFWXPayTraderAuditStatuseSuccess ? NSLocalizedString(@"已开通", nil) : NSLocalizedString(@"未开通", nil);
    [cell.detailButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"共计绑定%zd家门店", nil), trader.count] forState:UIControlStateNormal];
    cell.badgeLabel.backgroundColor = [UIColor colorWithHeX:trader.status == TDFWXPayTraderAuditStatuseSuccess ? 0x07AD00 : 0xCC0000];
    @weakify(self);
    cell.buttonBlock = ^ {
        @strongify(self);
        !self.selectBlock ?: self.selectBlock(trader);
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFTraderModel *trader = self.traders[indexPath.row];
    !self.selectBlock ?: self.selectBlock(trader);
}

#pragma mark - Accessor

- (UIButton *)addButton {

    if (!_addButton) {
        
        _addButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeBottomAdd];
        [_addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _addButton.hidden = self.hideAddButton;
    }
    
    return _addButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor colorWithHeX:0x999999];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TDFWXPayTraderCell class] forCellReuseIdentifier:@"TDFWXPayTraderCell"];
    }
    return _tableView;
}


- (TDFIntroductionHeaderView *)headerView {

    if (!_headerView) {
        
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_special"] description:NSLocalizedString(@"以下为您已提交审核/已通过的特约商户信息，您可以变更每个特约商户绑定的店铺，也可以继续增加特约商户，您最多可添加30个特约商户。", nil)];
    }
    
    return _headerView;
}


@end
