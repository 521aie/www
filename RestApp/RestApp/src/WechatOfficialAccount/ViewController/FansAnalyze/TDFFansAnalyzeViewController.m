//
//  TDFFansAnalyzeViewController.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "MobClick.h"
#import "TDFFansAnalyzeViewController.h"
#import "TDFOfficialAccountModel.h"
#import "TDFFansAnalyzeModel.h"
#import "UIColor+Hex.h"
#import "UIViewController+HUD.h"
#import "TDFOptionPickerController.h"
#import "TDFButtonFactory.h"
#import "TDFLabelFactory.h"
#import "TDFWechatMarketingService.h"
#import "TDFOAFanPieChartView.h"
#import "BackgroundHelper.h"
#import "TDFWXNotificationEditViewController.h"

#import "TDFWXCumulativeView.h"
#import "TDFWXFansAnalyzeLineChartView.h"
#import "TDFWXFansAnalyzeInfoModel.h"

@interface TDFFansAnalyzeViewController ()<TDFOAFanPieChartViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *pickerContainerView;
@property (strong, nonatomic) TDFOAFanPieChartView *chartView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) NSArray *models;

@property (strong, nonatomic) UILabel *officialAccountTitleLabel;
@property (strong, nonatomic) UILabel *officialAccountNameLabel;

@property (strong, nonatomic) UILabel *conditionTitleLabel;
@property (strong, nonatomic) UIButton *conditionNameButton;
@property (strong, nonatomic) UIImageView *conditionIndicator;

@property (strong, nonatomic) TDFFansAnalyzeModel *currentSelectedModel;
@property (strong, nonatomic) TDFFansAnalyzeItemModel *currentSelectedItem;

@property (strong, nonatomic) TDFWXFansAnalyzeLineChartView *fanChartView;
@property (strong, nonatomic) TDFWXFansAnalyzeLineChartView *couponChartView;
@property (strong, nonatomic) TDFWXCumulativeView *cumulativeView;
@property (strong, nonatomic) TDFWXFansAnalyzeInfoModel *analyzeInfo;
@end

@implementation TDFFansAnalyzeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackground];
    [self configNavigationBar];
    if (self.officialAccount) {
        [self fetchData];
    } else {
    
        [self configPrompt];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MobClick beginLogPageView:self.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:self.title];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = [self scrollViewContentSize];
}

#pragma mark - Method


#pragma mark Config View

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configNavigationBar {
    
    self.title = @"公众号粉丝数据分析";
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configPrompt {

    UILabel *label = [[UILabel alloc] init];
    label.text = @"您还没有授权店家微信公众号给二维火，无法获取粉丝数据！";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.view).with.offset(-40);
    }];
}

- (void)configContentViews {
 
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGSize size = [self scrollViewContentSize];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(size.height));
    }];
    
    id cumulativeViewTopMas = nil;
    if (self.analyzeInfo.fansChart.count >= 7) {
        [self.containerView addSubview:self.fanChartView];
        [self.fanChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(10);
            make.right.equalTo(self.containerView).offset(-10);
            make.top.equalTo(self.containerView).offset(10);
            make.height.equalTo(@216);
        }];
        cumulativeViewTopMas = self.fanChartView.mas_bottom;
        
    } else {
        cumulativeViewTopMas = self.containerView.mas_top;
    }
    
    [self.containerView addSubview:self.cumulativeView];
    [self.cumulativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kTDFWXCumulativeViewDefaultHeight));
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.top.equalTo(cumulativeViewTopMas).offset(10);
    }];
    
    id pickerContainerViewTopMas = nil;
    if (self.analyzeInfo.couponsChart.count >= 7) {
        [self.containerView addSubview:self.couponChartView];
        [self.couponChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(self.containerView).offset(-10);
            make.height.equalTo(@216);
            make.top.equalTo(self.cumulativeView.mas_bottom).offset(10);
        }];
        pickerContainerViewTopMas = self.couponChartView.mas_bottom;
    } else {
        pickerContainerViewTopMas = self.cumulativeView.mas_bottom;
    }
    
    [self.containerView addSubview:self.pickerContainerView];
    [self.pickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(pickerContainerViewTopMas).with.offset(10);
        make.height.equalTo(@89);
    }];
    
    [self.pickerContainerView addSubview:self.officialAccountTitleLabel];
    [self.officialAccountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickerContainerView).with.offset(10);
        make.top.equalTo(self.pickerContainerView).with.offset(14);
    }];
    
    [self.pickerContainerView addSubview:self.officialAccountNameLabel];
    [self.officialAccountNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pickerContainerView).with.offset(-10);
        make.top.equalTo(self.pickerContainerView).with.offset(14);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.pickerContainerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickerContainerView).with.offset(10);
        make.right.equalTo(self.pickerContainerView).with.offset(-10);
        make.centerY.equalTo(self.pickerContainerView);
        make.height.equalTo(@1);
    }];
    
    [self.pickerContainerView addSubview:self.conditionTitleLabel];
    [self.conditionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickerContainerView).with.offset(10);
        make.top.equalTo(line.mas_bottom).with.offset(14);
    }];
    
    [self.pickerContainerView addSubview:self.conditionIndicator];
    [self.conditionIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pickerContainerView).with.offset(-10);
        make.top.equalTo(line.mas_bottom).with.offset(18);
    }];
    
    [self.pickerContainerView addSubview:self.conditionNameButton];
    [self.conditionNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.conditionIndicator.mas_left).with.offset(-5);
        make.top.equalTo(line.mas_bottom).with.offset(7);
        make.height.equalTo(@(30));
        make.width.equalTo(@200);
    }];
    
    [self.containerView addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.pickerContainerView.mas_bottom).with.offset(10);
        make.height.equalTo(@([self.chartView expectedHeight]));
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.top.equalTo(self.chartView.mas_bottom).with.offset(20);
    }];
    
    [self.containerView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
    }];
    self.currentSelectedModel = self.models[0];
    [self updateViewWithFansAnalyzeModel:self.currentSelectedModel];
}

- (void)updateViewWithFansAnalyzeModel:(TDFFansAnalyzeModel *)model {

    [self arrangePieColorsForModel:model];
    [self.conditionNameButton setTitle:model.name forState:UIControlStateNormal];
    NSString *titleString = [NSString stringWithFormat:@"粉丝总数:%@人", [self prettyReadingNumber:model.count]];
    if ([model._id isEqualToString:@"4"]) {
        titleString = [NSString stringWithFormat:@"粉丝会员总数:%@人", [self prettyReadingNumber:model.count]];
    }
    self.chartView.title = model.parts.count == 0 ? @"本数据为隔日统计，请明日再来查看" : titleString;
    [self.chartView reloadWithPresenters:model.parts];
    [self.chartView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self.chartView expectedHeight]));
    }];
    CGSize size = [self scrollViewContentSize];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height));
    }];
    
    self.scrollView.contentSize = size;
}

- (void)updateViewWithAnalyzeInfo:(TDFWXFansAnalyzeInfoModel *)info {
    self.cumulativeView.fansCount = info.freshFansCount;
    self.cumulativeView.potentialCost = info.potentialConsumer;
    self.cumulativeView.peopleCount = info.takeCardCount;
    
    self.fanChartView.title = @"每日新增粉丝";
    self.fanChartView.detail = info.fansTip;
    self.fanChartView.chart = info.fansChart;
    
    self.couponChartView.title = @"每日领取优惠券数量";
    self.couponChartView.detail = info.couponsTip;
    self.couponChartView.chart = info.couponsChart;
}

- (void)arrangePieColorsForModel:(TDFFansAnalyzeModel *)model {

    NSArray *colors = @[ @"#F9EE94", @"#FF9739" , @"#FD5D45" , @"#D0011B" ,
                         @"#50E3C2" , @"#2EADC4" , @"#7BA4D3" , @"#19659B" ];
    NSArray *sortedArr = [model.parts sortedArrayUsingComparator:^NSComparisonResult(TDFFansAnalyzeItemModel *obj1, TDFFansAnalyzeItemModel *obj2) {
        if (obj1.ratio < obj2.ratio) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    NSInteger index = 0;
    for (TDFFansAnalyzeItemModel *item in sortedArr) {
        
        item.pieColor = [UIColor colorWithHexString:colors[index++]];
    }
}

- (CGSize)scrollViewContentSize {
    CGFloat height = 184 + self.detailLabel.frame.size.height + [self.chartView expectedHeight] +
        kTDFWXCumulativeViewDefaultHeight + 14 * 2 +
    (self.analyzeInfo.fansChart.count < 7 ? 0 : (216 + 14)) +
    (self.analyzeInfo.couponsChart.count < 7 ? 0 : (216 + 14));
    
    if (height < SCREEN_HEIGHT) {
        
        height = SCREEN_HEIGHT;
    }
    return CGSizeMake(SCREEN_WIDTH, height);
}

- (NSString *)prettyReadingNumber:(NSInteger)num {
    
    if (num >= 100000) {
        
        CGFloat anum = num / 10000.0;
        return [NSString stringWithFormat:@"%.2f万", anum];
    } else {
        
        return [NSString stringWithFormat:@"%zd", num];
    }
}

#pragma mark Action

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchButtonTapped {
    
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:@"选择查询条件" options:self.models currentItemId:self.currentSelectedModel._id];
    @weakify(self);
    pvc.competionBlock = ^(NSInteger index) {
        @strongify(self);
        self.currentSelectedModel = self.models[index];
        self.currentSelectedItem = nil;
        [self updateViewWithFansAnalyzeModel:self.currentSelectedModel];
    };
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)fansButtonTapped {
    [MobClick event:@"wechat_fans_transfer"];
    
    TDFWXNotificationEditViewController *evc = [[TDFWXNotificationEditViewController alloc] init];
    evc.officialAccount = self.officialAccount;
    TDFWXNotificationModel *model = [[TDFWXNotificationModel alloc] init];
    if (self.currentSelectedItem) {
    
        model.targetType = TDFWXNotificationTargetTypeIntelligentGroup;
        model.groupId = self.currentSelectedItem._id;                       //  item 的 id 就是智能分组的 id
    } else {
        model.targetType = TDFWXNotificationTargetTypeAll;
    }
    evc.model = model;
    [self.navigationController pushViewController:evc animated:YES];
}

#pragma mark Network

- (void)fetchData {

    [self showHUBWithText:@"正在加载"];
    
    @weakify(self);
    [[TDFWechatMarketingService service] fetchOfficialAccountFansInfoWithId:self.officialAccount._id callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        
        self.analyzeInfo = [TDFWXFansAnalyzeInfoModel yy_modelWithJSON:responseObj[@"data"]];
        [self updateViewWithAnalyzeInfo:self.analyzeInfo];
        
        
        self.models = self.analyzeInfo.fansAnalyze;
        [self configContentViews];
    }];
}

#pragma mark - TDFOAFanPieChartViewDelegate

- (void)fanPieChartView:(TDFOAFanPieChartView *)chartView didSelectItemAtIndex:(NSInteger)index {
    
    self.currentSelectedItem = self.currentSelectedModel.parts[index];
}

- (void)fanPieChartViewDidDeSelectItem:(TDFOAFanPieChartView *)chartView {

    self.currentSelectedItem = nil;
}

#pragma mark - Accessor

- (UIScrollView *)scrollView {

    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _scrollView;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.opaque = NO;
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}
- (UIView *)pickerContainerView {
    
    if (!_pickerContainerView) {
        
        _pickerContainerView = [[UIView alloc] init];
        _pickerContainerView.opaque = NO;
        _pickerContainerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _pickerContainerView.layer.masksToBounds = YES;
        _pickerContainerView.layer.cornerRadius = 3;
    }
    return _pickerContainerView;
}
- (TDFOAFanPieChartView *)chartView {
    
    if (!_chartView) {
        
        _chartView = [[TDFOAFanPieChartView alloc] init];
        _chartView.opaque = NO;
        _chartView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        [_chartView.fansButton addTarget:self action:@selector(fansButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _chartView.layer.masksToBounds = YES;
        _chartView.layer.cornerRadius = 3;
        _chartView.delegate = self;
    }
    return _chartView;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"攻略：让更多粉丝成为会员";
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = @"您可根据查询条件，筛选出不同类型的粉丝，可查看您公众号的运营情况，包括：本月生日会员、领卡会员、充值会员与会员等级在您粉丝中的占比。";
    }
    return _detailLabel;
}

- (UILabel *)officialAccountTitleLabel {
    
    if (!_officialAccountTitleLabel) {
        
        _officialAccountTitleLabel = [[UILabel alloc] init];
        _officialAccountTitleLabel.textColor = [UIColor whiteColor];
        _officialAccountTitleLabel.font = [UIFont systemFontOfSize:15];
        _officialAccountTitleLabel.text = @"公众号";
    }
    return _officialAccountTitleLabel;
}
- (UILabel *)officialAccountNameLabel {
    
    if (!_officialAccountNameLabel) {
        
        _officialAccountNameLabel = [[UILabel alloc] init];
        _officialAccountNameLabel.textColor = [UIColor colorWithHeX:0x0088CC];
        _officialAccountNameLabel.font = [UIFont systemFontOfSize:15];
        _officialAccountNameLabel.text = self.officialAccount.name;
    }
    return _officialAccountNameLabel;
}

- (UILabel *)conditionTitleLabel {
    
    if (!_conditionTitleLabel) {
        
        _conditionTitleLabel = [[UILabel alloc] init];
        _conditionTitleLabel.textColor = [UIColor whiteColor];
        _conditionTitleLabel.font = [UIFont systemFontOfSize:15];
        _conditionTitleLabel.text = @"查询条件";
    }
    return _conditionTitleLabel;
}
- (UIButton *)conditionNameButton {
    
    if (!_conditionNameButton) {
        
        _conditionNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conditionNameButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        _conditionNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _conditionNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_conditionNameButton addTarget:self action:@selector(switchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionNameButton;
}
- (UIImageView *)conditionIndicator {
    
    if (!_conditionIndicator) {
        
        _conditionIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_indicator_down_white"]];
    }
    return _conditionIndicator;
}

- (TDFWXCumulativeView *)cumulativeView {
    if (!_cumulativeView) {
        _cumulativeView = [[TDFWXCumulativeView alloc] init];
    }
    
    return _cumulativeView;
}

- (TDFWXFansAnalyzeLineChartView *)couponChartView {
    if (!_couponChartView) {
        _couponChartView = [[TDFWXFansAnalyzeLineChartView alloc] init];
    }
    
    return _couponChartView;
}

- (TDFWXFansAnalyzeLineChartView *)fanChartView {
    if (!_fanChartView) {
        _fanChartView = [[TDFWXFansAnalyzeLineChartView alloc] init];
    }
    
    return _fanChartView;
}
@end
