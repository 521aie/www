//
//  TDFTraderInfoViewController.m
//  RestApp
//
//  Created by Octree on 20/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTraderInfoViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import <Masonry/Masonry.h>
#import "UIViewController+HUD.h"
#import "TDFShopSelectionViewController.h"
#import "BranchShopVo.h"
#import "TDFWXPayTraderEditViewController.h"
#import "TDFWechatMarketingService.h"

@interface TDFTraderInfoViewController ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *viewProfileButton;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *shopButton;
@property (strong, nonatomic) UIImageView *disclosureImageView;

@property (strong, nonatomic) UILabel *traderLabel;

@end

@implementation TDFTraderInfoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    self.title = self.model.name;
}

#pragma mark - Methods


#pragma mark Config Views
- (void)configViews {
    
    [self configBackground];
    [self updateNavigationBar];
    [self configContentViews];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
}

- (void)configContentViews {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 0);
    size = [self.detailLabel sizeThatFits:size];
    CGFloat headerHeight = size.height + 162;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(headerHeight);
    }];
    
    [self.headerView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).with.offset(10);
        make.centerX.equalTo(self.headerView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(15);
    }];
    
    [self.headerView addSubview:self.traderLabel];
    [self.traderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.headerView).with.offset(10);
        make.right.equalTo(self.headerView).with.offset(-10);
    }];
    
    [self.headerView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.traderLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.headerView).with.offset(10);
        make.right.equalTo(self.headerView).with.offset(-10);
    }];
    
    [self.headerView addSubview:self.viewProfileButton];
    [self.viewProfileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.headerView).with.offset(-10);
        make.width.mas_equalTo(142);
        make.height.mas_equalTo(13);
    }];
    
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).with.offset(1);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.detailView addSubview:self.disclosureImageView];
    [self.disclosureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailView).with.offset(-10);
        make.centerY.equalTo(self.detailView);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    [self.detailView addSubview:self.shopButton];
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.disclosureImageView.mas_left).with.offset(-5);
        make.centerY.equalTo(self.detailView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.detailView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView).with.offset(10);
        make.centerY.equalTo(self.detailView);
        make.right.equalTo(self.shopButton.mas_left).with.offset(-10);
    }];
}

- (void)updateNavigationBar {
    
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark Network

- (void)saveTraderShops:(NSArray *)shops topViewController:(UIViewController *)vc {

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:shops.count];
    for (ShopVO *shop in shops) {
    
        [array addObject:shop.entityId];
    }
    
    [vc showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFWechatMarketingService service] saveTraderShopsWithTraderId:self.model._id shopIds:[array yy_modelToJSONString] callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [vc dismissHUD];
        if (error) {
            
            [vc showErrorMessage:error.localizedDescription];
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
        [self.shopButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"共计%zd家门店", nil), shops.count] forState:UIControlStateNormal];
    }];
}

#pragma mark Action

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shopButtonTapped {

    TDFShopSelectionViewController *vc = [[TDFShopSelectionViewController alloc] init];
    vc.loadAsync = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        
        [[TDFWechatMarketingService service] fetchTraderBranchShopsWithTraderId:self.model._id callback:callback];
    }].fmap(^id(NSDictionary *obj) {
        
        return [NSArray yy_modelArrayWithClass:[BranchShopVo class] json:obj[@"data"]];
    });
    
    vc.title = NSLocalizedString(@"选择绑定的门店", nil);
    vc.commitTitle = NSLocalizedString(@"保存", nil);
    
    __weak __typeof(vc) weakVC = vc;
    vc.confirmBlock = ^void (NSArray <ShopVO *>* objs) {
    
        [self saveTraderShops:objs topViewController:weakVC];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewProfileButtonTapped {

    TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
    vc.readOnly = YES;
    vc.traderId = self.model._id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Accessor

- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _headerView;
}

- (UIView *)detailView {
    
    if (!_detailView) {
        
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _detailView;
}

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_audit_success"]];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor colorWithHeX:0x07AD1F];
        _titleLabel.text = NSLocalizedString(@"本店已开通微信支付特约商户", nil);
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor colorWithHeX:0x666666];
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = NSLocalizedString(@"注：特约商户开通后，您的微信支付收款将切换到此特约商户下，您可点击以下链接查看结算账户。特约商户信息无法修改，如结算方式需要变更，请联系二维火在线客服。", nil);
    }
    return _detailLabel;
}

- (UIButton *)viewProfileButton {
    
    if (!_viewProfileButton) {
        
        _viewProfileButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeDetail];
        [_viewProfileButton setTitle:NSLocalizedString(@"查看我提交的申请资料", nil) forState:UIControlStateNormal];
        [_viewProfileButton addTarget:self action:@selector(viewProfileButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewProfileButton;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _nameLabel.text = NSLocalizedString(@"当前特约商户已绑定", nil);
    }
    return _nameLabel;
}

- (UIButton *)shopButton {
    
    if (!_shopButton) {
        
        _shopButton = [[UIButton alloc] init];
        [_shopButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        _shopButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_shopButton addTarget:self action:@selector(shopButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_shopButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"共计%zd家门店", nil), self.model.count] forState:UIControlStateNormal];
        _shopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _shopButton;
}

- (UIImageView *)disclosureImageView {
    
    if (!_disclosureImageView) {
        
        _disclosureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_disclosure_indicator"]];
    }    
    return _disclosureImageView;
}

- (UILabel *)traderLabel {
    
    if (!_traderLabel) {
        
        _traderLabel = [[UILabel alloc] init];
        _traderLabel.font = [UIFont systemFontOfSize:13];
        _traderLabel.textColor = [UIColor colorWithHeX:0x07AD1F];
        _traderLabel.textAlignment = NSTextAlignmentCenter;
        _traderLabel.text = [NSString stringWithFormat:@"特约商户号：%@", self.model.traderNumber];
    }
    return _traderLabel;
}

@end
