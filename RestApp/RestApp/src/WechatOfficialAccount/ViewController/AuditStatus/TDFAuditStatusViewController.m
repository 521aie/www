//
//  TDFAuditStatusViewController.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditStatusViewController.h"
#import "TDFAuditViewFactory.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "TDFTraderAuditModel.h"
#import "TDFWXPayTraderModel.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "UIViewController+HUD.h"
#import "TDFWechatAuditingView.h"
#import "TDFWXPayTraderEditViewController.h"
#import "TDFWechatMarketingService.h"
#import "TDFAuditFailedView.h"

@interface TDFAuditStatusViewController ()

@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *profileButton;
@property (strong, nonatomic) TDFTraderAuditModel *model;
@property (nonatomic) BOOL custom;
@property (strong, nonatomic) TDFAsync *async;
@property (strong, nonatomic) void (^viewProfileBlock)();
@property (strong, nonatomic) UILabel *traderLabel;
@end

@implementation TDFAuditStatusViewController

#pragma mark - Life Cycle

+ (instancetype)statusViewWithAsync:(TDFAsync *)async title:(NSString *)title viewProfileBlock:(void(^)(void))block; {

    TDFAuditStatusViewController *vc = [[TDFAuditStatusViewController alloc] init];
    vc.custom = YES;
    vc.async = async;
    vc.popDepth = 1;
    vc.viewProfileBlock = block;
    vc.title = title;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationItem];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    self.async.execute(^void(TDFTraderAuditModel *obj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        self.model = obj;
        [self configViewWithModel:obj];
    });
}


#pragma mark - Private Methods



- (void)configViewWithModel:(TDFTraderAuditModel *)model {

    TDFAuditStatusView *statusView = [[[TDFAuditViewFactory alloc] init] statusViewWithModel:model];
    if (model.status == TDFWXPayTraderAuditStatusWaiting) {
        
        ((TDFWechatAuditingView *)statusView).urgentBlock = ^ {
            
            [self urgent];
        };
    }
    
    if (model.status == TDFWXPayTraderAuditStatusFailed) {
    
        ((TDFAuditFailedView *)statusView).retryBlock = ^ {
            
            !self.reapplyBlock ?: self.reapplyBlock();
        };
    }
    [self.view addSubview:self.statusImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:statusView];
    [self.view addSubview:self.profileButton];
    
    self.statusImageView.image = [self iconForAuditStatus:model.status];
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = [self colorForTitleWithAuditStatus:model.status];
    CGFloat marginTop = model.status == TDFWXPayTraderAuditStatusWaiting ? 70 : 100;
    @weakify(self);
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).with.offset(marginTop);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.statusImageView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
    
    UIView *targetView = self.titleLabel;
    if (model.status == TDFWXPayTraderAuditStatuseSuccess && model.traderNumber) {
        
        targetView = self.traderLabel;
        [self.view addSubview:self.traderLabel];
        self.traderLabel.text = [NSString stringWithFormat:NSLocalizedString(@"特约商户号：%@", nil), model.traderNumber];
        [self.traderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
        }];
    }
    
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(targetView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.profileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(statusView.mas_bottom).with.offset(40);
        make.width.mas_equalTo(143);
        make.height.mas_equalTo(16);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.profileButton.hidden = model.status == TDFWXPayTraderAuditStatusFailed || model.isImported;
}

- (void)configNavigationItem {
    
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
    return;
}

- (void)backButtonTapped {
    
    NSInteger count = self.navigationController.viewControllers.count;
    NSAssert(count - 1 - self.popDepth > 0, @"Invalid Pop Depth");
    UIViewController *vc = self.navigationController.viewControllers[ count - 1 - self.popDepth];
    [self.navigationController popToViewController:vc animated:YES];
}


/**
 *  审核状态 icon
 *
 *  @param status 审核状态
 *
 *  @return Image
 */
- (UIImage *)iconForAuditStatus:(TDFWXPayTraderAuditStatus)status {

    switch (status) {
            
        case TDFWXPayTraderAuditStatuseSuccess:                         //  审核成功
            return [UIImage imageNamed:@"wxoa_audit_success"];
            
        case TDFWXPayTraderAuditStatusFailed:                           //  审核失败
            return [UIImage imageNamed:@"wxoa_audit_failed"];
        default:
            return [UIImage imageNamed:@"wxoa_audit_waiting"];
    }
}


- (UIColor *)colorForTitleWithAuditStatus:(TDFWXPayTraderAuditStatus)status {

    switch (status) {
            
        case TDFWXPayTraderAuditStatuseSuccess:                         //  审核成功
            return [UIColor colorWithHeX:0x07AD1F];
            
        case TDFWXPayTraderAuditStatusFailed:                           //  审核失败
            return [UIColor colorWithHeX:0xCC0000];
        default:
            return [UIColor colorWithHeX:0xF58023];
    }
}
#pragma mark Action 

- (void)viewProfileButtonTapped {

    !self.viewProfileBlock ?: self.viewProfileBlock(); 
}

- (void)showAuditVC {

    TDFTraderAuditModel *model = [[TDFTraderAuditModel alloc] init];
    model.title = NSLocalizedString(@"特约商户收款账户验证中", nil);
    model.detail = NSLocalizedString(@"您的验证申请已成功提交，7个工作日内即可开通特约商户（直连账户）", nil);
    model.status = TDFWXPayTraderAuditStatusValidating;
    model.applyTime = self.model.applyTime;
    
    
    @weakify(self);
    TDFAuditStatusViewController *auditStatusViewContrller = [TDFAuditStatusViewController statusViewWithAsync:TDFAsync.unit(model) title:NSLocalizedString(@"微信支付特约商户", nil) viewProfileBlock:^{
        @strongify(self);
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.readOnly = YES;
        vc.traderId = self.traderId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    auditStatusViewContrller.popDepth = self.popDepth + 1;
    [self.navigationController pushViewController:auditStatusViewContrller animated:YES];
}

#pragma mark Network

- (void)urgent {
    
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFWechatMarketingService service] urgentTraderAuditWithTraderId:self.traderId callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        [self showAuditVC];
    }];
}

- (void)loadData {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    self.async.execute(^void(TDFTraderAuditModel *obj, NSError *error) {
        @strongify(self);
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        [self configViewWithModel:obj];
    });
}

#pragma mark - Accessor


- (UIButton *)profileButton {

    if (!_profileButton) {
        _profileButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_profileButton setTitle:WXOALocalizedString(@"WXOA_View_Profile") forState:UIControlStateNormal];
        _profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_profileButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        _profileButton.tintColor = [UIColor colorWithHeX:0x0088CC];
        [_profileButton addTarget:self action:@selector(viewProfileButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _profileButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _profileButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _profileButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [_profileButton setImage:[UIImage imageNamed:@"WXOA_disclosure_indicator_blue"] forState:UIControlStateNormal];
        _profileButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    
    return _profileButton;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor colorWithHeX:0xF58023];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIImageView *)statusImageView {

    if (!_statusImageView) {
        
        _statusImageView = [[UIImageView alloc] init];
    }
    
    return _statusImageView;
}

- (UILabel *)traderLabel {

    if (!_traderLabel) {
        
        _traderLabel = [[UILabel alloc] init];
        _traderLabel.font = [UIFont systemFontOfSize:13];
        _traderLabel.textColor = [UIColor colorWithHeX:0x07AD1F];
        _traderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _traderLabel;
}
@end
