//
//  TDFOAAuthIntrouceViewController.m
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAAuthIntrouceViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "Platform.h"
#import <Masonry/Masonry.h>
#import "TDFOAHelpViewController.h"
#import "TDFOAAuthDetailViewController.h"
#import "TDFShopSelectionViewController.h"
#import "ShopVO.h"
#import "TDFWechatMarketingService.h"
#import "BranchShopVo.h"
#import "UIViewController+HUD.h"
#import "TDFOAAuthViewController.h"
#import "RestConstants.h"

@interface TDFOAAuthIntrouceViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *authButton;
@property (strong, nonatomic) UIButton *helpButton;
@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;

@end

@implementation TDFOAAuthIntrouceViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}


#pragma mark - Methods


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

    self.title = NSLocalizedString(@"店家公众号授权", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {
    
    [self.view addSubview:self.headerView];
    @weakify(self);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.headerView.frame.size.height);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(10);
        make.top.equalTo(view.mas_top).with.offset(15);
    }];
    
    [view addSubview:self.imageView];
    CGFloat height = (SCREEN_WIDTH - 20) * self.imageView.image.size.height / self.imageView.image.size.width;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(view.mas_left).with.offset(10);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(height);
    }];
    
    [view addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view.mas_left).with.offset(10);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(20);
    }];
    
    [self.view addSubview:self.authButton];
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(view.mas_left).with.offset(10);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.helpButton];
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(self.authButton.mas_bottom).with.offset(30);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(15);
    }];
}


#pragma mark Action


- (void)authButtonTapped {
    
    if ([Platform Instance].isChain) {
        
        [self showShopSelectionVC];
    } else {
    
        NSString*shopId = [[Platform Instance] getkey:ENTITY_ID];
        [self showAuthVCWithShopIds:[@[shopId] yy_modelToJSONString] topViewController:self];
    }
}

- (void)showShopSelectionVC {

    TDFShopSelectionViewController *vc = [[TDFShopSelectionViewController alloc] init];
    
    vc.title = NSLocalizedString(@"选公众号绑定门店", nil);
    vc.commitTitle = NSLocalizedString(@"继续", nil);
    vc.loadAsync = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        [[TDFWechatMarketingService service] fetchBranchShopsWithOAId:nil callback:callback];
    }].fmap(^id(NSDictionary *obj) {
        return [NSArray yy_modelArrayWithClass:[BranchShopVo class] json:obj[@"data"]];
    });
    @weakify(self);
    __weak __typeof(vc) wvc = vc;
    vc.confirmBlock = ^void (NSArray <ShopVO *>* objs) {
        @strongify(self);
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:objs.count];
        for (ShopVO *shop in objs) {
            [array addObject:shop.entityId];
        }
        
        [self showAuthVCWithShopIds:[array yy_modelToJSONString] topViewController:wvc];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAuthVCWithShopIds:(NSString *)ids topViewController:(UIViewController *)viewController {

    [viewController showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchAuthURLWithShopIds:ids officialAcountId:nil callback:^(id responseObj, NSError *error) {
        [viewController dismissHUD];
        if (error) {
            [viewController showErrorMessage:error.localizedDescription];
            return;
        }
        
        TDFOAAuthViewController *vc = [[TDFOAAuthViewController alloc] init];
        vc.authPopDepthAddition = self.authPopDepthAddition ?: 1;
        vc.authURL = [responseObj objectForKey:@"data"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)helpButtonTapped {

    TDFOAHelpViewController *vc = [[TDFOAHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Accessor

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        
        _titleLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _titleLabel.text = NSLocalizedString(@"请按照以下步骤申请公众号授权：", nil);
    }
    return _titleLabel;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        
        _promptLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _promptLabel.text = NSLocalizedString(@"请在完成第1、2步后，点击下方按钮：", nil);
    }
    return _promptLabel;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        
        NSString *name = [[Platform Instance] isChain] ? @"wxoa_auth_chain" : @"wxoa_auth_normal";
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    }
    return _imageView;
}

- (UIButton *)authButton {
    if (!_authButton) {
        
        _authButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        [_authButton setTitle:NSLocalizedString(@"申请微信公众号授权", nil) forState:UIControlStateNormal];
        [_authButton addTarget:self action:@selector(authButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authButton;
}

- (UIButton *)helpButton {
    if (!_helpButton) {
        
        _helpButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeDetail];
        [_helpButton setTitle:NSLocalizedString(@"查看详细教程", nil) forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

- (TDFIntroductionHeaderView *)headerView {
    if (!_headerView) {
        
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_auth"]
                                                         description:NSLocalizedString(@"店家微信公众号授权后，可在掌柜中直接设置微信公众号菜单内容；可通过店家微信公众号推送订单下厨、支付和会员消费等信息给顾客；可自动获取店家公众号二维码，在顾客在线支付成功后展示。", nil)
                                                           badgeIcon:[UIImage imageNamed:@"wxoa_wechat_unauthed"]];
    }
    return _headerView;
}

@end
