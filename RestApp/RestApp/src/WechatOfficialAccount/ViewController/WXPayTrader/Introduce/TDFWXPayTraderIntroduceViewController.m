//
//  TDFWXPayTraderIntroduceViewController.m
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayTraderIntroduceViewController.h"
#import "TDFIntroductionHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFTraderIntroduceCell.h"
#import "TDFCenterTitleCell.h"
#import "TDFWXPayTraderEditViewController.h"


@interface TDFWXPayTraderIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *applyButton;
@property (strong, nonatomic) UILabel *promptTitleLabel;
@property (strong, nonatomic) UILabel *promptDetailLabel;

@end

@implementation TDFWXPayTraderIntroduceViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
}

#pragma mark - Methods


#pragma mark Config Views


- (void)configViews {

    [self configFooterView];
    [self configBackgroundView];
    [self configContentViews];
    [self configNavigationBar];
}

/**
 *  配置背景图片
 */
- (void)configBackgroundView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}


/**
 *  配置内容区的 View
 */
- (void)configContentViews {

    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

/**
 *  配置 NavigationBar
 */
- (void)configNavigationBar {
    
    self.title = WXOALocalizedString(@"WXOA_Pay_Trader_Title");
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIImage *backIcon = [UIImage imageWithCGImage:[UIImage imageNamed:@"ico_back"].CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)configFooterView {

    [self.footerView addSubview:self.applyButton];
    [self.footerView addSubview:self.promptTitleLabel];
    [self.footerView addSubview:self.promptDetailLabel];
    @weakify(self);
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.footerView.mas_top).with.offset(20);
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
        make.right.equalTo(self.footerView.mas_right).with.offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.promptTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.applyButton.mas_bottom).with.offset(20);
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
    }];
    [self.promptDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.promptTitleLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.footerView.mas_left).with.offset(10);
    }];
}

#pragma mark Actions


- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)applyButtonTapped {

    TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
    vc.auditPopDepthAddition = self.auditPopDepthAddition;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  UITableViewDelegate & UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? 50 : 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
        {
            TDFCenterTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFCenterTitleCell" forIndexPath:indexPath];
            cell.titleLabel.text = WXOALocalizedString(@"WXOA_Trader_Advance_Title");
            return cell;
        }
        break;
        case 1:
        {
            TDFTraderIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFTraderIntroduceCell" forIndexPath:indexPath];
            cell.iconImageView.image = [UIImage imageNamed:@"wxoa_trader_arrive"];
            cell.titleLabel.text = WXOALocalizedString(@"WXOA_Trader_Arrive_Title");
            cell.detailLabel.text = WXOALocalizedString(@"WXOA_Trader_Arrive_Detail");
            cell.titleLabel.textColor = [UIColor colorWithHeX:0xDA8800];
            return cell;
        }
        case 2:
        {
            TDFTraderIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFTraderIntroduceCell" forIndexPath:indexPath];
            cell.iconImageView.image = [UIImage imageNamed:@"wxoa_trader_refund"];
            cell.titleLabel.text = WXOALocalizedString(@"WXOA_Trader_Refund_Title");
            cell.detailLabel.text = WXOALocalizedString(@"WXOA_Trader_Refund_Detail");
            cell.titleLabel.textColor = [UIColor colorWithHeX:0x0088CC];
            return cell;
        }
        case 3:
            
        {
            TDFTraderIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFTraderIntroduceCell" forIndexPath:indexPath];
            cell.iconImageView.image = [UIImage imageNamed:@"wxoa_trader_attract"];
            cell.titleLabel.text = WXOALocalizedString(@"WXOA_Trader_Attract_Title");
            cell.detailLabel.text = WXOALocalizedString(@"WXOA_Trader_Attract_Detail");
            cell.titleLabel.textColor = [UIColor colorWithHeX:0x417505];
            return cell;
        }
        default:
            return nil;
    }
}


#pragma mark - Accessor

- (UIButton *)applyButton {

    if (!_applyButton) {
        
        _applyButton = [[UIButton alloc] init];
        [_applyButton setTitle:WXOALocalizedString(@"WXOA_Apply_WXPay_Trader") forState:UIControlStateNormal];
        _applyButton.backgroundColor = [UIColor colorWithHeX:0xCC0000];
        _applyButton.titleLabel.textColor = [UIColor whiteColor];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_applyButton addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _applyButton.layer.masksToBounds = YES;
        _applyButton.layer.cornerRadius = 5;
    }
    
    return _applyButton;
}


- (UILabel *)promptTitleLabel {

    if (!_promptTitleLabel) {
        
        _promptTitleLabel = [[UILabel alloc] init];
        _promptTitleLabel.text = WXOALocalizedString(@"WXOA_Trader_Introduce_Title");
        _promptTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _promptTitleLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    
    return _promptTitleLabel;
}

- (UILabel *)promptDetailLabel {

    if (!_promptDetailLabel) {
        
        _promptDetailLabel = [[UILabel alloc] init];
        _promptDetailLabel.text = WXOALocalizedString(@"WXOA_Trader_Introduce_Detail");
        _promptDetailLabel.font = [UIFont systemFontOfSize:13];
        _promptDetailLabel.textColor = [UIColor colorWithHeX:0x333333];
        _promptDetailLabel.numberOfLines = 0;
    }
    
    return _promptDetailLabel;
}

- (UIView *)footerView {

    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206);
    }
    
    return _footerView;
}

- (TDFIntroductionHeaderView *)headerView {

    if (!_headerView) {
        
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_special"]
                                                        description:WXOALocalizedString(@"WXOA_WXPay_Introduce")
                                                          badgeIcon:[UIImage imageNamed:@"wxoa_trader_unopned"]];
        _headerView.subviews.firstObject.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _headerView.subviews.firstObject.alpha = 1;
    }
    
    return _headerView;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[TDFTraderIntroduceCell class] forCellReuseIdentifier:@"TDFTraderIntroduceCell"];
        [_tableView registerClass:[TDFCenterTitleCell class] forCellReuseIdentifier:@"TDFCenterTitleCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
