//
//  TDFOAAuthDetailViewController.m
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAAuthDetailViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "Platform.h"
#import <Masonry/Masonry.h>
#import "TDFWechatMarketingService.h"
#import "STTweetLabel.h"
#import "TDFForm.h"
#import <TDFAsync/TDFAsync.h>
#import "TDFOfficialAccountModel.h"
#import "UIImageView+WebCache.h"
#import "TDFOAPermissionView.h"
#import "TDFOfficialAccountModel.h"
#import "TDFShopSelectionViewController.h"
#import "TDFOAAuthViewController.h"
#import "BranchShopVo.h"
#import "UIViewController+HUD.h"
#import "TDFMarketingStore.h"
#import "RestConstants.h"

@interface TDFOAAuthDetailViewController ()

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *shopDetailView;
@property (strong, nonatomic) UIButton *shopButton;
@property (strong, nonatomic) UILabel *shopLabel;

@property (strong, nonatomic) UIImageView *avatarImageView;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *badgeLabel;

@property (strong, nonatomic) STTweetLabel *promptLabel;
@property (strong, nonatomic) UILabel *permissionLabel;
@property (strong, nonatomic) UILabel *unauthLabel;

@property (strong, nonatomic) TDFOAPermissionView *permissionView;

@end

@implementation TDFOAAuthDetailViewController


#pragma mark - Life Cycle

- (instancetype)init {

    if (self = [super init]) {
        _popDepth = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configViews];
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
    [self.view addSubview:self.scrollView];
    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView.contentSize.height);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)configContentViews {
    
    @weakify(self);;
    [self.containerView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.mas_equalTo(self.headerView.frame.size.height);
    }];
    
    UIView *targetView = self.headerView;
    CGFloat margin = 0;
    
    if ([self isChain]) {
    
        targetView = self.shopDetailView;
        margin = 1;
        [self.containerView addSubview:self.shopDetailView];
        [self.shopDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
           @strongify(self);
            make.left.equalTo(self.containerView);
            make.right.equalTo(self.containerView);
            make.top.equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(44);
        }];
        [self configShopView];
    }
    
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        make.top.equalTo(targetView.mas_bottom).with.offset(margin);
    }];
    
    [view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.mas_equalTo(view).with.offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(view);
    }];
    
    [view addSubview:self.badgeLabel];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(5);
        make.top.equalTo(self.nameLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(16);
    }];
    
    [view addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(view);
        make.top.equalTo(self.badgeLabel.mas_bottom).with.offset(12);
    }];
    
    [view addSubview:self.permissionLabel];
    [self.permissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(view).with.offset(10);
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(25);
    }];
    
    [view addSubview:self.permissionView];
    [self.permissionView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.top.equalTo(self.permissionLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(390);
    }];
    
    [view addSubview:self.unauthLabel];
    [self.unauthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.top.equalTo(self.permissionView.mas_bottom).with.offset(15);
    }];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.officialAccount.avatarUrl] placeholderImage:[UIImage imageNamed:@"img_nopic_user"]];
}

- (void)configShopView {

    @weakify(self);
    [self.shopDetailView addSubview:self.shopLabel];
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.shopDetailView.mas_left).with.offset(10);
        make.centerY.equalTo(self.shopDetailView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_disclosure_indicator"]];
    [self.shopDetailView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self.shopDetailView).with.offset(-10);
        make.centerY.equalTo(self.shopDetailView);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    [self.shopDetailView addSubview:self.shopButton];
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(imageView.mas_left).with.offset(-5);
        make.centerY.equalTo(self.shopDetailView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
}

- (void)updateNavigationBar {
    
    self.title = NSLocalizedString(@"店家公众号授权", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return;
}


#pragma mark Network

- (void)saveShopsWithShopIds:(NSString *)shopIds count:(NSInteger)count {

    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    @weakify(self);
    [[TDFWechatMarketingService service] updateShopsWithOfficialAccountId:self.officialAccount._id shopIds:shopIds callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        [self.shopButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"共计%zd家门店", nil), count] forState:UIControlStateNormal];
    }];
}

#pragma mark Action

- (void)showAuthVCWithShopIds:(NSArray *)ids topViewController:(UIViewController *)viewController {
    
    [viewController showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFWechatMarketingService service] fetchAuthURLWithShopIds:[ids yy_modelToJSONString] officialAcountId:self.officialAccount._id callback:^(id responseObj, NSError *error) {
        [viewController dismissHUD];
        if (error) {
            [viewController showErrorMessage:error.localizedDescription];
            return;
        }
        
        TDFOAAuthViewController *vc = [[TDFOAAuthViewController alloc] init];
        vc.authPopDepthAddition = self.popDepth ?: 1;
        vc.authURL = [responseObj objectForKey:@"data"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)reauthButtonTapped {
    
    if (![self isChain]) {
        
        NSString *shopId = [[Platform Instance] getkey:ENTITY_ID];
        [self showAuthVCWithShopIds:@[shopId] topViewController:self];
        return;
    }
    
    TDFShopSelectionViewController *vc = [[TDFShopSelectionViewController alloc] init];
    
    vc.title = NSLocalizedString(@"选公众号绑定门店", nil);
    vc.commitTitle = NSLocalizedString(@"继续", nil);
    vc.loadAsync = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        [[TDFWechatMarketingService service] fetchBranchShopsWithOAId:self.officialAccount._id callback:callback];
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
        
        [self showAuthVCWithShopIds:array topViewController:wvc];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)shopButtonTapped {
    
    TDFShopSelectionViewController *vc = [[TDFShopSelectionViewController alloc] init];
    
    vc.title = NSLocalizedString(@"选公众号绑定门店", nil);
    vc.commitTitle = NSLocalizedString(@"保存", nil);
    vc.loadAsync = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        [[TDFWechatMarketingService service] fetchBranchShopsWithOAId:self.officialAccount._id callback:callback];
    }].fmap(^id(NSDictionary *obj) {
        return [NSArray yy_modelArrayWithClass:[BranchShopVo class] json:obj[@"data"]];
    });
    
    @weakify(self);
    vc.confirmBlock = ^void (NSArray <ShopVO *>* objs) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:objs.count];
        for (ShopVO *shop in objs) {
            [array addObject:shop.entityId];
        }
        
        [self saveShopsWithShopIds:[array yy_modelToJSONString] count:array.count];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)backButtonTapped {
    
    NSInteger count = self.navigationController.viewControllers.count;
    NSAssert(count - 1 - self.popDepth > 0, @"Invalid Pop Depth");
    UIViewController *vc = self.navigationController.viewControllers[ count - 1 - self.popDepth];
    [self.navigationController popToViewController:vc animated:YES];
}

#pragma mark - Accessor

- (TDFIntroductionHeaderView *)headerView {

    if (!_headerView) {
        
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_auth"]
                                                        description:NSLocalizedString(@"店家微信公众号授权后，可在掌柜中直接设置微信公众号菜单内容；可通过店家微信公众号推送订单下厨、支付和会员消费等信息给顾客；可自动获取店家公众号二维码，在顾客在线支付成功后展示。", nil)
                                                          badgeIcon:[UIImage imageNamed:@"wxoa_wechat_authed"]];
    }
    
    return _headerView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 890);
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

- (UIView *)shopDetailView {
    
    if (!_shopDetailView) {
        
        _shopDetailView = [[UIView alloc] init];
        _shopDetailView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _shopDetailView;
}

- (UIButton *)shopButton {
    
    if (!_shopButton) {
        
        _shopButton = [[UIButton alloc] init];
        [_shopButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"共计%zd家门店", nil), self.officialAccount.storeNum]
                     forState:UIControlStateNormal];
        [_shopButton addTarget:self action:@selector(shopButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _shopButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_shopButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        _shopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _shopButton;
}

- (UILabel *)shopLabel {
    
    if (!_shopLabel) {
        
        _shopLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _shopLabel.text = NSLocalizedString(@"当前公众号已绑定", nil);
    }
    return _shopLabel;
}


- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
    
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 40;
    }
    return _avatarImageView;
}


- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = self.officialAccount.name;
        _nameLabel.textColor = [UIColor colorWithHeX:0x333333];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)badgeLabel {
    
    if (!_badgeLabel) {
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:11];
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 3;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.text = self.officialAccount.type;
        _badgeLabel.backgroundColor = [UIColor colorWithHeX:0x0088CC];
    }
    return _badgeLabel;
}


- (STTweetLabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
        NSString *text = NSLocalizedString(@"您已授权成功，如您的公众号添加了新\n功能组件或账号有变更，请 ", nil);
        NSString *hotword = NSLocalizedString(@"重新授权 〉", nil);
        _promptLabel.hotwordRegex = hotword;
        _promptLabel.numberOfLines = 2;
        BOOL flag = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain;
        [_promptLabel setText:[NSString stringWithFormat:@"%@%@", text, hotword]];
        [_promptLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:0x333333],
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }];
        [_promptLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:flag ? 0x999999:0x0088CC],
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }
                            hotWord:STTweetLink];
        _promptLabel.textSelectable = NO;
        @weakify(self);
        [_promptLabel setDetectionBlock:^(STTweetHotWord hotword, NSString *text, NSString *protocol, NSRange range) {
            @strongify(self);
            if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
                
                [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
                return;
            }
            [self reauthButtonTapped];
        }];
    }
    return _promptLabel;
}

- (UILabel *)permissionLabel {
    
    if (!_permissionLabel) {
        
        _permissionLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeContent];
        _permissionLabel.text = NSLocalizedString(@"已授权给二维火的权限：", nil);
    }
    return _permissionLabel;
}

- (UILabel *)unauthLabel {
    
    if (!_unauthLabel) {
        
        _unauthLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeComment];
        _unauthLabel.text = NSLocalizedString(@"说明：如需解绑，请登陆微信公众号后台，可取消授权", nil);
        _unauthLabel.numberOfLines = 0;
    }
    return _unauthLabel;    
}


- (TDFOAPermissionView *)permissionView {
    
    if (!_permissionView) {
        
        _permissionView = [[TDFOAPermissionView alloc] initWithOfficialAccount:self.officialAccount];
        _permissionView.backgroundColor = [UIColor colorWithHeX:0xE4E4E4];
        _permissionView.layer.masksToBounds = YES;
        _permissionView.layer.cornerRadius = 5;
        _permissionView.layer.borderColor = [UIColor colorWithHeX:0x999999].CGColor;
        _permissionView.layer.borderWidth = 1;
    }
    return _permissionView;    
}


- (BOOL)isChain {

    return [[Platform Instance] isChain];
}

@end
