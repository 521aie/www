//
//  TDFOAMenuIntroduceViewController.m
//  RestApp
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAMenuIntroduceViewController.h"
#import "UIColor+Hex.h"
#import "BackgroundHelper.h"
#import "WXOAConst.h"
#import "TDFIntroductionHeaderView.h"
#import "TDFLabelFactory.h"
#import "TDFButtonFactory.h"
#import "Platform.h"
#import <Masonry/Masonry.h>
#import "TDFWechatMarketingService.h"
#import "TDFOfficialAccountView.h"
#import "STTweetLabel.h"
#import "TDFOAMenuModel.h"
#import "TDFOAMenuHelpViewController.h"
#import "TDFURLMenuDetailViewController.h"
#import "UIViewController+HUD.h"
#import "MailInputBox.h"
#import "MemoInputClient.h"
#import "TDFMarketingStore.h"
#import "TDFOAAuthIntrouceViewController.h"
#import "TDFMenuPromptView.h"
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>

@interface TDFOAMenuIntroduceViewController ()<TDFOfficialAccountViewDelegate, TDFOfficialAccountViewDataSource, MemoInputClient>

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) STTweetLabel *detailLabel;
@property (strong, nonatomic) TDFOfficialAccountView *officialAccountView;
@property (strong, nonatomic) UIButton *urlCopyButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) TDFMenuPromptView *promptView;

@end

@implementation TDFOAMenuIntroduceViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self fetchMenus];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![TDFMarketingStore sharedInstance].isMenuCopyPromptShown) {
        
        [TDFMarketingStore sharedInstance].menuCopyPromptShown = YES;
        [self.promptView removeFromSuperview];
    }
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
    
    self.title = NSLocalizedString(@"店家公众号菜单自定义", nil);
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView.contentSize.height);
        make.width.mas_equalTo(self.scrollView.contentSize.width);
    }];
    
    [self.containerView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
        make.height.mas_equalTo(self.headerView.frame.size.height);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(10);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(view.mas_top).with.offset(15);
    }];
    
    [view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(10);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
    }];
    
    [view addSubview:self.officialAccountView];
    [self.officialAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(285);
        make.height.mas_equalTo(412);
    }];
    
    [view addSubview:self.urlCopyButton];
    [self.urlCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.officialAccountView.mas_bottom).with.offset(30);
        make.centerX.equalTo(view).with.offset(-66);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
    }];
    
    [view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.officialAccountView.mas_bottom).with.offset(30);
        make.centerX.equalTo(view).with.offset(66);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(88);
    }];
    
    //  从未显示过
    if (![TDFMarketingStore sharedInstance].isMenuCopyPromptShown) {
        
        [self.officialAccountView addSubview:self.promptView];
        [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.officialAccountView);
            make.bottom.equalTo(self.officialAccountView).with.offset(-164);
            make.width.mas_equalTo(183);
            make.height.mas_equalTo(68);
        }];
    }
}


#pragma mark Network

- (void)fetchMenus {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchMenusWithWXId:nil callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        BOOL hasShop = [[[responseObj objectForKey:@"data"] objectForKey:@"hasShop"] boolValue];
        
        if ([[Platform Instance] isChain] && !hasShop) {
            
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[[responseObj objectForKey:@"data"] objectForKey:@"msg"] preferredStyle:(UIAlertControllerStyleAlert)];
            [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:avc animated:YES completion:nil];
        }
        
        NSArray *array = [[responseObj objectForKey:@"data"] objectForKey:@"menuList"];
        
        NSMutableArray *menus = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            
            TDFOAMenuModel *parentMemu = [TDFOAMenuModel yy_modelWithDictionary:dict[@"parentMenu"]];
            parentMemu.subMenus = [NSArray yy_modelArrayWithClass:[TDFOAMenuModel class] json:dict[@"subMenuList"]];
            [menus addObject:parentMemu];
        }
        
        self.menus = menus;
        [self.officialAccountView reloadData];
    }];
}

#pragma mark Action


- (void)urlCopyButtonTapped {

    [MobClick event:@"wechat_menu_copy"];
    [self copyURLsToPasteboard];
}


- (void)copyURLsToPasteboard {

    [UIPasteboard generalPasteboard].string = [self menuURLStrings];
    [self showErrorMessage:NSLocalizedString(@"链接复制成功，请前往您的微信公众号后台设置！", nil)];
}

- (void)sendButtonTapped {
    [MailInputBox show:1 delegate:self title:NSLocalizedString(@"输入EMAIL地址", nil) val:nil isPresentMode:YES];
}

- (void)authButtonTapped {
    
    TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
    vc.authPopDepthAddition = 1;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)helpButtonTapped {
    
    TDFOAMenuHelpViewController *vc = [[TDFOAMenuHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonTapped {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MemoInputClient

-(void)finishInput:(NSInteger)event content:(NSString*)content{
    
    [MobClick event:@"wechat_menu_mail"];
    [self showHUBWithText:NSLocalizedString(@"正在发送", nil)];
    [[TDFWechatMarketingService service] sendLinks:[self menuURLStrings] toEmails:content callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
        
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        [self showErrorMessage:NSLocalizedString(@"发送成功", nil)];
    }];
}



#pragma mark - TDFOfficialAccountViewDelegate, TDFOfficialAccountViewDataSource 

- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFURLMenuDetailViewController *vc = [[TDFURLMenuDetailViewController alloc] init];
    TDFOAMenuModel *model = self.menus[indexPath.section];
    vc.model = model.subMenus[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectMenuInSection:(NSUInteger)section {
    
}

- (NSUInteger)numOfSectionInOfficialAccountView:(TDFOfficialAccountView *)accountView {
    
    return self.menus.count;
}

- (NSUInteger)officialAccountView:(TDFOfficialAccountView *)accountView numOfItemsInSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.subMenus.count;
}

- (BOOL)officialAccountView:(TDFOfficialAccountView *)accountView shouldShowAddItemInSection:(NSUInteger)section {
    
    return NO;
}

- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView menuTitleForSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.name;
}

- (TDFMenuType)officialAccountView:(TDFOfficialAccountView *)accountView menuTypeForSection:(NSUInteger)section {
    
    return TDFMenuTypeNormal;
}

- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView titleForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFOAMenuModel *menu = [[self.menus[indexPath.section] subMenus] objectAtIndex:indexPath.item];
    return menu.name;
}

#pragma mark - Accessor

- (NSString *)menuURLStrings {

    NSMutableString *string = [NSMutableString string];
    for (TDFOAMenuModel *model in self.menus) {
        
        for (TDFOAMenuModel *menu in model.subMenus) {
            
            [string appendFormat:@"%@ : %@\n", menu.name, menu.urlDetail.url];
        }
    }
    return string;
}

- (TDFIntroductionHeaderView *)headerView {
    
    if (!_headerView) {
        
        @weakify(self);
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_menu_custom"]
                                                        description:NSLocalizedString(@"如果本店有微信公众号，可以将以下功能加入公众号菜单中。公众号未授权时，需手动复制每个菜单的链接后在微信公众号后台进行设置；公众号授权后，可在此处直接对公众号菜单进行设置。", nil)
                                                          badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]
                                                        detailTitle:NSLocalizedString(@"立即去授权", nil)
                                                        detailBlock:^{
                                                            @strongify(self);
                                                            [self authButtonTapped];
                                                        }];
    }
    return _headerView;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 880);
    }
    return _scrollView;
}



- (STTweetLabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
        NSString *text = NSLocalizedString(@"请点击对应菜单，复制链接后在您的微信公众号后台对菜单进行设置。", nil);
        NSString *hotword = NSLocalizedString(@"微信公众号后台菜单设置教程 〉", nil);
        _detailLabel.hotwordRegex = hotword;
        [_detailLabel setText:[NSString stringWithFormat:@"%@%@", text, hotword]];
        [_detailLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:0x333333],
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }];
        [_detailLabel setAttributes:@{
                                      NSForegroundColorAttributeName : [UIColor colorWithHeX:0x0088CC],
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
                                      }
        hotWord:STTweetLink];
        _detailLabel.textSelectable = NO;
        @weakify(self);
        [_detailLabel setDetectionBlock:^(STTweetHotWord hotword, NSString *text, NSString *protocol, NSRange range) {
            @strongify(self);
            [self helpButtonTapped];
        }];
    }
    return _detailLabel;
}

- (TDFOfficialAccountView *)officialAccountView {
    
    if (!_officialAccountView) {
        
        _officialAccountView = [[TDFOfficialAccountView alloc] init];
        _officialAccountView.delegate = self;
        _officialAccountView.dataSource = self;
    }
    return _officialAccountView;
}

- (UIButton *)urlCopyButton {
    
    if (!_urlCopyButton) {
        
        _urlCopyButton = [[UIButton alloc] init];
        [_urlCopyButton setImage:[UIImage imageNamed:@"wxoa_link_copy"] forState:UIControlStateNormal];
        [_urlCopyButton setTitle:NSLocalizedString(@"复制全部链接", nil) forState:UIControlStateNormal];
        _urlCopyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_urlCopyButton setTitleColor:[UIColor colorWithHeX:0x666666] forState:UIControlStateNormal];
        [_urlCopyButton addTarget:self action:@selector(urlCopyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        CGFloat totalHeight = (54 + 12 + 10);
        _urlCopyButton.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - 54),
                                                           5.0f,
                                                           0.0f,
                                                           - 54);
        
        _urlCopyButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                                           - 54,
                                                           - (totalHeight - 12),
                                                           0.0f);
        _urlCopyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _urlCopyButton;
}

- (UIButton *)sendButton {
    
    if (!_sendButton) {
        
        _sendButton = [[UIButton alloc] init];
        [_sendButton setImage:[UIImage imageNamed:@"wxoa_link_email"] forState:UIControlStateNormal];
        [_sendButton setTitle:NSLocalizedString(@"发送全部链接到邮箱", nil) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendButton setTitleColor:[UIColor colorWithHeX:0x666666] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        CGFloat totalHeight = (54 + 24 + 10);
        _sendButton.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - 54),
                                                          8.0f,
                                                          0.0f,
                                                          - 54);
        
        _sendButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                                          - 54,
                                                          - (totalHeight - 24),
                                                          0.0f);
        _sendButton.titleLabel.numberOfLines = 0;
        _sendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sendButton;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSLocalizedString(@"您尚未进行公众号授权，需复制链接自行设置", nil);
    }
    return _titleLabel;
}

- (TDFMenuPromptView *)promptView {

    if (!_promptView) {
        
        @weakify(self);
        _promptView = [TDFMenuPromptView promptViewWithTitle:NSLocalizedString(@"点击以下各个菜单进行复制", nil) closeBlock:^{
            @strongify(self);
            [TDFMarketingStore sharedInstance].menuCopyPromptShown = YES;
            [self.promptView removeFromSuperview];
        }];
    }
    return _promptView;
}
@end
