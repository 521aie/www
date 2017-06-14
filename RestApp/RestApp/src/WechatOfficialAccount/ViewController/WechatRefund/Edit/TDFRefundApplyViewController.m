//
//  TDFRefundApplyViewController.m
//  RestApp
//
//  Created by Octree on 4/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRefundApplyViewController.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "BackgroundHelper.h"
#import "TDFImageSelectView.h"
#import <Masonry/Masonry.h>
#import "UIViewController+HUD.h"
#import "TDFMemberCouponService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+TDF_fixOrientation.h"
#import "TDFRefundAuditModel.h"
#import "TDFWechatMarketingService.h"
#import "TDFAuditStatusViewController.h"
#import "NSDate+TDFMilliInterval.h"
#import "UIColor+Hex.h"
#import "Platform.h"
#import "TDFMarketingStore.h"
#import "TDFIntroductionHeaderView.h"

@interface TDFRefundApplyViewController ()

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *guideLabel;
@property (strong, nonatomic) UILabel *footLabel;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *containerView;

//   审核信息

@property (strong, nonatomic) UIImageView *statusIcon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (nonatomic) TDFRefundAuditStatus status;

@end

@implementation TDFRefundApplyViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请微信公众号托管";
    [self configViews];
    [self fetchData];
}


#pragma mark - Methods

#pragma mark Config Views

- (void)configViews {

    [self updateNavigationBar];
    [self configBackground];
}

- (void)configBackground {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configContentViewsWithStatus:(TDFRefundAuditStatus)status {

    self.status = status;
    switch (status) {
        case TDFRefundAuditStatusNerverApply:
            [self configViewWhenNotApply];
            break;
        case TDFRefundAuditStatusSuccess:
            [self configViewWhenSuccess];
            break;
        default:
            [self configViewOtherwise];
            break;
    }
}

- (void)removeAllViews {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)configViewWhenNotApply {
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(self.headerView.frame.size.height));
    }];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [self.containerView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.top.equalTo(self.containerView).with.offset(15);
    }];
    
    [self.containerView addSubview:self.imageView];
    self.imageView.image = [self imageForStatus:self.status];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(@(300));
        make.height.equalTo(@(70));
    }];
    [self configBottomLabels];
}

- (void)configViewWhenSuccess {
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self configAuditInfoView];
    self.guideLabel.textColor = [UIColor colorWithHeX:0x666666];
    self.guideLabel.text = @"您可在使用此特约商户的门店内，在收银机上对微信支付的金额进行“清空支付”或删除。";
    self.footLabel.text = @"请确认您特约商户账户内有充足余额便于退款。";
    [self.containerView addSubview:self.guideLabel];
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(30);
    }];
    
    [self.containerView addSubview:self.footLabel];
    [self.footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.guideLabel.mas_bottom).with.offset(10);
    }];

}

- (void)configViewOtherwise {
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self configAuditInfoView];
    [self.containerView addSubview:self.imageView];
    self.imageView.image = [self imageForStatus:self.status];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(@(300));
        make.height.equalTo(@(70));
    }];
    [self configBottomLabels];
}

- (void)configAuditInfoView {

    self.statusIcon.image = [self iconForStatus:self.status];
    [self.containerView addSubview:self.statusIcon];
    [self.statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.height.width.equalTo(@(30));
        make.top.equalTo(self.containerView).with.offset(60);
    }];
    
    UIColor *color = [UIColor colorWithHeX:self.status == TDFRefundAuditStatusSuccess ? 0x07AD1F : 0xF58023];
    self.titleLabel.textColor = color;
    self.titleLabel.text = [self titleForStatus:self.status];
    self.descriptionLabel.textColor = color;
    self.descriptionLabel.text = [self descriptionForStatus:self.status];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.statusIcon.mas_bottom).with.offset(10);
    }];
    
    [self.containerView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
    }];
}

- (void)configBottomLabels {
    
    
    if (self.status == TDFRefundAuditStatusAccept) {
        self.guideLabel.text = @"您可在使用此特约商户的门店内，在收银机上对微信支付的金额进行“清空支付”或删除。";
        self.footLabel.text = @"请确认您特约商户账户内有充足余额便于退款。";
    }
    
    [self.containerView addSubview:self.guideLabel];
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(20);
    }];
    
    [self.containerView addSubview:self.footLabel];
    [self.footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.guideLabel.mas_bottom).with.offset(10);
    }];
    
    if (self.status == TDFRefundAuditStatusNerverApply) {
    
        [self.button setTitle:@"我要申请退款功能" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).with.offset(10);
            make.right.equalTo(self.containerView).with.offset(-10);
            make.height.equalTo(@(40));
            make.top.equalTo(self.footLabel.mas_bottom).with.offset(20);
        }];
    } else if (self.status == TDFRefundAuditStatusInvited) {
        
        [self.button setTitle:@"我已完成以上步骤" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(nextStepButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).with.offset(10);
            make.right.equalTo(self.containerView).with.offset(-10);
            make.height.equalTo(@(40));
            make.top.equalTo(self.footLabel.mas_bottom).with.offset(20);
        }];
    }
}


- (NSString *)titleForStatus:(TDFRefundAuditStatus)status {

    switch (status) {
        case TDFRefundAuditStatusAuditing:
            return @"您的申请已提交";
        case TDFRefundAuditStatusSuccess:
            return @"申请成功！";
        case TDFRefundAuditStatusInvited:
            return @"二维火已对您发起邀请！";
        case TDFRefundAuditStatusAccept:
            return @"待二维火核实授权状态";
        default:
            return @"";
    }
}

- (NSString *)descriptionForStatus:(TDFRefundAuditStatus)status {
    switch (status) {
        case TDFRefundAuditStatusAuditing:
            return @"二维火会在1-3个工作日内对您发起邀请。请登陆您的微信商户后—在“产品大全”、“我授权的产品”中找到“服务商API退款”并授权。";
        case TDFRefundAuditStatusSuccess:
            return @"您可在收银机上发起退款操作";
        case TDFRefundAuditStatusInvited:
            return @"请登录微信商户后台同意并授权";
        default:
            return nil;
    }
}

- (UIImage *)iconForStatus:(TDFRefundAuditStatus)status {
    return [UIImage imageNamed:status == TDFRefundAuditStatusSuccess ? @"wxoa_audit_success" : @"wxoa_audit_waiting"];
}

- (UIImage *)imageForStatus:(TDFRefundAuditStatus)status {
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wxoa_refund_audit_%zd", self.status]];
    switch (status) {
        case TDFRefundAuditStatusNerverApply:
            return [UIImage imageNamed:@"wxoa_refund_audit_0"];
        case TDFRefundAuditStatusAuditing:
            return [UIImage imageNamed:@"wxoa_refund_audit_1"];
        case TDFRefundAuditStatusInvited:
            return [UIImage imageNamed:@"wxoa_refund_audit_2"];
        case TDFRefundAuditStatusAccept:
            return [UIImage imageNamed:@"wxoa_refund_audit_2"];
        default:
            return nil;
    }
}

#pragma mark Update Views

- (void)updateNavigationBar {

    self.navigationItem.rightBarButtonItem = nil;
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Network


- (void)showMessageWithMessage:(NSString *)msg block:(void(^)())block {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", @"我知道了") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block();
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)fetchData {
    [self showHUBWithText:@"正在加载"];
    @weakify(self);
    [[TDFWechatMarketingService service] fetchRefundAuditInfoWithTraderId:self.traderId callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        TDFRefundAuditStatus status = [[[responseObj objectForKey:@"data"] objectForKey:@"status"] integerValue];
        [self configContentViewsWithStatus:status];
    }];
}


- (void)applyRefund {

    [self showHUBWithText:@"正在加载"];
    @weakify(self);
    [[TDFWechatMarketingService service] applyRefundWithTraderId:self.traderId callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        
        [self showMessageWithMessage:@"您的申请已提交！二维火会在1-3个工作日内对您发起邀请。请登陆您的微信商户后—在“产品大全”、“我授权的产品”中找到“服务商API退款”并授权" block:^{
            [self removeAllViews];
            [self configContentViewsWithStatus:TDFRefundAuditStatusAuditing];
        }];
    }];
}


- (void)acceptInvitation {

    [self showHUBWithText:@"正在加载"];
    @weakify(self);
    [[TDFWechatMarketingService service] acceptRefundInvitationWithTraderId:self.traderId callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showHUBWithText:error.localizedDescription];
            return;
        }
        
        [self showMessageWithMessage:@"您的申请已提交！二维火会在1-2个工作日内核实，请耐心等候。" block:^{
            [self removeAllViews];
            [self configContentViewsWithStatus:TDFRefundAuditStatusAccept];
        }];
    }];
}

#pragma mark Action

- (void)applyButtonTapped {

    [self applyRefund];
}

//   就是已经完成操作的按钮
- (void)nextStepButtonTapped {

    [self acceptInvitation];
}

#pragma mark - Accessor

- (TDFIntroductionHeaderView *)headerView {
    if (!_headerView) {
        
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_refund"]
                                                        description:@"本店成为微信支付特约商户（直连商户）后，即可申请微信支付退款功能。随时用收银机对微信支付进行退款（非特约商户仅支持当天24点前退款）"
                                                          badgeIcon:[UIImage imageNamed:@"wxoa_trader_unopned"]];
    }
    return _headerView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        
        _promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _promptLabel.text = @"请按照以下步骤申请公众号授权：";
    }
    return _promptLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)guideLabel {
    if (!_guideLabel) {
        
        _guideLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeComment];
        _guideLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _guideLabel.numberOfLines = 0;
        _guideLabel.text = @"请登陆您的微信商户后台--在“产品大全”、“我授权的产品”中找到“服务商API退款”并授权。";
    }
    return _guideLabel;
}

- (UILabel *)footLabel {
    if (!_footLabel) {
        
        _footLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeComment];
        _footLabel.text = @"您需先申请通过退款功能，才可在微信中使用外卖点餐功能。";
        _footLabel.numberOfLines = 0;
    }
    return _footLabel;  
}

- (UIButton *)button {
    if (!_button) {
        
        _button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
    }
    return _button;  
}

- (UIView *)containerView {

    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _containerView;
}

- (UIImageView *)statusIcon {
    if (!_statusIcon) {
        _statusIcon = [[UIImageView alloc] init];
    }
    return _statusIcon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:15];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 0;
    }
    return _descriptionLabel;
}


@end
