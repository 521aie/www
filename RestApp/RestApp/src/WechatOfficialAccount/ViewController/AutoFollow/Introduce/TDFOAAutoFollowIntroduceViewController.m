//
//  TDFOAAutoFollowIntroduceViewController.m
//  RestApp
//
//  Created by Octree on 4/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAAutoFollowIntroduceViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "TDFAutoFollowModel.h"
#import "TDFWechatMarketingService.h"
#import "UIViewController+HUD.h"
#import <YYModel/YYModel.h>
#import "TDFAutoFollowEditViewController.h"
#import "TDFMarketingStore.h"
#import "TDFWXPayTraderIntroduceViewController.h"
#import "Platform.h"
#import "TDFAsync.h"
#import "TDFAuditStatusViewController.h"
#import "TDFWXPayTraderEditViewController.h"
#import "TDFMarketingStore.h"

@interface TDFOAAutoFollowIntroduceViewController ()

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
/**
 *  未开通
 */
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIButton *applyButton;
@property (strong, nonatomic) UIImageView *sampleImageView;

/**
 *  已经开通
 */

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *wxnameLabel;
@property (strong, nonatomic) UIButton *changeButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;

/**
 *  Model
 */
@property (strong, nonatomic) TDFAutoFollowModel *model;

@end

@implementation TDFOAAutoFollowIntroduceViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViews];
    
    if (self.status != TDFAutoFollowAuditStatusNerverApply) {
        [self fetchData];
    }
}


#pragma mark - Methods



#pragma mark Config Views

- (void)configViews {

    [self configBackground];
    [self configNavigation];
    [self configContentView];
    
}

- (void)configBackground {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.scrollView];
    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.containerView];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.alreadyOpend ? 690 : 660;
    height = MAX([UIScreen mainScreen].bounds.size.height, height);
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    self.scrollView.contentSize = CGSizeMake(width, height);
}

- (void)configContentView {

    [self.containerView addSubview:self.headerView];
    @weakify(self);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_equalTo(self.headerView.frame.size.height);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    UIView *targetView = self.alreadyOpend ? self.changeButton : self.applyButton;
    
    if (self.alreadyOpend) {
    
        [view addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top).with.offset(30);
        }];
        
        [view addSubview:self.wxnameLabel];
        [self.wxnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           @strongify(self);
            make.left.equalTo(view.mas_left).with.offset(10);
            make.right.equalTo(view.mas_right).with.offset(-10);
            make.height.mas_equalTo(20);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        }];
        
        [view addSubview:self.changeButton];
        [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(self.wxnameLabel.mas_bottom).with.offset(15);
            make.width.mas_equalTo(116);
            make.height.mas_equalTo(15);
        }];
    } else {
    
        [view addSubview:self.promptLabel];
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(10);
            make.right.equalTo(view).with.offset(-10);
            make.top.equalTo(view.mas_top).with.offset(15);
        }];
        
        [view addSubview:self.applyButton];
        [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.promptLabel.mas_bottom).with.offset(15);
            make.left.equalTo(view.mas_left).with.offset(10);
            make.right.equalTo(view.mas_right).with.offset(-10);
            make.height.mas_equalTo(40);
        }];
    }
    
    [view addSubview:self.sampleImageView];
    [self.sampleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(16);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.top.equalTo(targetView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(312);
    }];
}

- (void)configNavigation {

    self.title = NSLocalizedString(@"支付后关注公众号", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark Network

- (void)fetchData {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[[TDFWechatMarketingService alloc] init] fetchAutoFollowInfoWithTraderId:self.traderId callback:^void(id responseObj, NSError *error) {
       @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        
        self.model = [TDFAutoFollowModel yy_modelWithDictionary:[responseObj objectForKey:@"data"]];
        self.wxnameLabel.text = self.model.officialAccount.name;
        if (self.model.status == TDFAutoFollowAuditStatusFailed) {
        
            NSString *string = [NSString stringWithFormat:NSLocalizedString(@"您的申请未通过，申请微信号为：%@\n失败原因：%@", nil), self.model
                                .officialAccount.name, self.model.reason];
            self.promptLabel.text = string;
        }
    }];
}

#pragma mark Action

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyButtonTapped {

    if (self.traderStatus != TDFWXPayTraderAuditStatuseSuccess) {
        
        [self showErrorMessage:NSLocalizedString(@"需开通微信支付特约商户，才能使用此功能", nil)];
        return;
    }
    
    TDFAutoFollowEditViewController *vc = [[TDFAutoFollowEditViewController alloc] init];
    vc.model = self.model;
    vc.traderId = self.traderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changedButtonTapped {

    TDFAutoFollowEditViewController *vc = [[TDFAutoFollowEditViewController alloc] init];
    vc.model = [self.model copy];
    vc.traderId = self.traderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)establishTrader {

    if (!self.traderId) {
        TDFWXPayTraderIntroduceViewController *vc = [[TDFWXPayTraderIntroduceViewController alloc] init];
        vc.auditPopDepthAddition = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.traderStatus == TDFWXPayTraderAuditStatusNotApply) {
        
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.traderId = self.traderId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else {
    
        [self showTraderAuditWithTraderId:self.traderId status:self.traderStatus];
    }
}

- (void)showTraderAuditWithTraderId:(NSString *)traderId status:(TDFWXPayTraderAuditStatus)status {
    
    TDFAsync *async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        
        [[TDFWechatMarketingService service] fetchTraderAuditInfoWithTraderId:traderId callback:callback];
    }].fmap(^id(NSDictionary *dict) {
        
        TDFTraderAuditModel *model = [TDFTraderAuditModel yy_modelWithJSON:dict[@"data"]];
        TDFTraderAuditModel *tempModel = [TDFTraderAuditModel auditModelWithStatus:status];
        model.title = tempModel.title;
        model.detail = tempModel.detail;
        return model;
    });
    
    @weakify(self);
    TDFAuditStatusViewController *auditStatusViewContrller = [TDFAuditStatusViewController statusViewWithAsync:async title:NSLocalizedString(@"微信支付特约商户", nil) viewProfileBlock:^{
        @strongify(self);
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.readOnly = YES;
        vc.traderId = traderId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    auditStatusViewContrller.traderId = self.traderId;
    
    //      重新申请
    auditStatusViewContrller.reapplyBlock = ^void() {
        @strongify(self);
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.traderId = traderId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    auditStatusViewContrller.popDepth = 2;
    [self.navigationController pushViewController:auditStatusViewContrller animated:YES];
}

#pragma mark - Accessor

- (TDFIntroductionHeaderView *)headerView {
    
    if (!_headerView) {

        BOOL flag = self.traderStatus == TDFWXPayTraderAuditStatuseSuccess;
        UIImage *badge = [UIImage imageNamed:flag ? @"wxoa_trader_opened" : @"wxoa_trader_unopned"];
        NSString *description = flag ? NSLocalizedString(@"顾客使用微信付款后，在微信中的支付凭证页面会展示此处设置的公众号，顾客对凭证进行确认时会自动关注此公众号，有助于店家吸纳公众号粉丝。", nil) : NSLocalizedString(@"店家开通微信支付特约商户后，如果顾客使用微信进行支付，在支付完成后会自动关注店家设置的公众号。店家可以通过提升扫码点餐和支付率，极速吸纳公众号粉丝。", nil);
        @weakify(self);
        void (^block)(void) = flag ? nil : ^void() {
            @strongify(self);
            [self establishTrader];
        };
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_auto_follow"]
                                                        description:description
                                                          badgeIcon:badge
                                                        detailTitle:self.alreadyOpend ? nil : NSLocalizedString(@"立即去开通", nil)
                                                        detailBlock:block];
    }
    return _headerView;
}

- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _promptLabel.text = NSLocalizedString(@"需开通微信支付特约商户，才能使用此功能", nil);
        _promptLabel.numberOfLines = 0;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
//        _promptLabel.hidden = self.traderStatus == TDFWXPayTraderAuditStatuseSuccess;
    }
    
    return _promptLabel;
}

- (UIButton *)applyButton {
    
    if (!_applyButton) {
        
        
        _applyButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        [_applyButton setTitle:self.status == TDFAutoFollowAuditStatusFailed ? NSLocalizedString(@"重新申请\"支付后自动关注公众号\"", nil) : NSLocalizedString(@"申请“支付后自动关注公众号”", nil) forState:UIControlStateNormal];
        [_applyButton addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.managedByChain) {
            _applyButton.backgroundColor = [UIColor colorWithHeX:0x999999];
            _applyButton.enabled = NO;
        }
    }
    return _applyButton;
}

- (UIImageView *)sampleImageView {
    
    if (!_sampleImageView) {
        
        _sampleImageView = [[UIImageView alloc] init];
        _sampleImageView.image = [UIImage imageNamed:@"wxoa_auto_follow_sample"];
        _sampleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _sampleImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
     
        _titleLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _titleLabel.text = NSLocalizedString(@"顾客微信支付后自动关注公众号", nil);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)wxnameLabel {
    
    if (!_wxnameLabel) {
        
        _wxnameLabel = [[UILabel alloc] init];
        _wxnameLabel.font = [UIFont boldSystemFontOfSize:20];
        _wxnameLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _wxnameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _wxnameLabel;
}

- (UIButton *)changeButton {
    
    if (!_changeButton) {
        
        _changeButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeDetail];
        BOOL flag = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.managedByChain;
        [_changeButton setTitleColor:[UIColor colorWithHeX:0x999999] forState:UIControlStateDisabled];
        _changeButton.enabled = !flag;
        [_changeButton setTitle:NSLocalizedString(@"我要变更此公众号", nil) forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changedButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
    
}

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
        _containerView.backgroundColor = [UIColor clearColor];
    }
    
    return _containerView;
}

@end
