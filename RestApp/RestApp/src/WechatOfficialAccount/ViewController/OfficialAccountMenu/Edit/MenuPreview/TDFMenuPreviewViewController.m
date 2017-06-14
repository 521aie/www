//
//  TDFMenuPreviewViewController.m
//  RestApp
//
//  Created by Octree on 8/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuPreviewViewController.h"
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
#import "TDFMenuEditViewController.h"
#import "UIViewController+HUD.h"
#import "TDFMarketingStore.h"
#import "TDFMenuPromptView.h"
#import "TDFURLMenuDetailViewController.h"
#import "TDFOfficialAccountModel.h"
#import "MailInputBox.h"
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>

@interface TDFMenuPreviewViewController ()<TDFOfficialAccountViewDelegate, TDFOfficialAccountViewDataSource, MemoInputClient>

@property (strong, nonatomic) TDFIntroductionHeaderView *headerView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) TDFOfficialAccountView *officialAccountView;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *menus;
@property (nonatomic) BOOL contentChanged;
@property (strong, nonatomic) TDFMenuPromptView *promptView;
@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation TDFMenuPreviewViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    self.title = NSLocalizedString(@"店家公众号菜单自定义", nil);
    [super viewDidLoad];
    [self configViews];
    [self fetchMenus];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![TDFMarketingStore sharedInstance].isMenuSettingPromptShown) {
        
        [TDFMarketingStore sharedInstance].menuCopyPromptShown = YES;
        [self.promptView removeFromSuperview];
    }
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
    
    [view addSubview:self.officialAccountView];
    [self.officialAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(15);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(285);
        make.height.mas_equalTo(412);
    }];
    
    [view addSubview:self.resetButton];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.top.equalTo(self.officialAccountView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.top.equalTo(self.resetButton.mas_bottom).with.offset(15);
    }];
    
    [view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
    }];
    
    if (![TDFMarketingStore sharedInstance].isMenuSettingPromptShown) {
        
        [self.officialAccountView addSubview:self.promptView];
        [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.officialAccountView);
            make.bottom.equalTo(self.officialAccountView).with.offset(-93);
            make.width.mas_equalTo(183);
            make.height.mas_equalTo(68);
        }];
    }
}


- (void)updateNavigationBar {
    
    if (![self contentChanged]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationCancel];
        [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        return;
    }
    
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationClose];
    [button addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationSave];
    [button addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark Network

- (void)fetchMenus {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchMenusWithWXId:self.officialAccountId callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
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
        
        BOOL isSetting = [[[responseObj objectForKey:@"data"] objectForKey:@"isSettings"] boolValue];
        if (isSetting) {
            
            [TDFMarketingStore sharedInstance].menuSettingPromptShown = YES;
            [self.promptView removeFromSuperview];
        }
        
        [self.officialAccountView reloadData];
    }];
}


/**
 *  一键设置成默认的 Menus
 */
- (void)resetMenus {
    
    [MobClick event:@"wechat_menu_set"];
    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFWechatMarketingService service] fetchInitialMenusWithOAId:self.officialAccountId callback:^(id responseObj, NSError *error) {
        
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        
        NSArray *array = [[responseObj objectForKey:@"data"] objectForKey:@"menuList"];
        
        NSMutableArray *menus = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            
            TDFOAMenuModel *parentMemu = [TDFOAMenuModel yy_modelWithDictionary:dict[@"parentMenu"]];
            parentMemu.subMenus = [NSArray yy_modelArrayWithClass:[TDFOAMenuModel class] json:dict[@"subMenuList"]];
            [menus addObject:parentMemu];
        }
        
        self.menus = menus;
        self.contentChanged = NO;
        [self.officialAccountView reloadData];
        [self updateNavigationBar];
    }];
}

#pragma mark Action


- (void)resetButtonTapped {
    
    if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
        
        [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
        return;
    }
    
    if ([[Platform Instance] isChain] && self.officialAccount.storeNum == 0) {
        
        [self showErrorMessage:NSLocalizedString(@"当前公众号并未绑定任何门店！无法设置！", nil)];
        return;
    }
    
    if (![TDFMarketingStore sharedInstance].isMenuSettingPromptShown) {
        
        [TDFMarketingStore sharedInstance].menuCopyPromptShown = YES;
        [self.promptView removeFromSuperview];
    }
    
    [self resetMenus];
}


- (void)saveButtonTapped {
    
    [self showHUBWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFWechatMarketingService service] saveMenusWithWXId:self.officialAccountId menusStrings:[self formatMenuStrings] callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        
        self.contentChanged = NO;
        [self updateNavigationBar];
    }];
}



- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonTapped {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)helpButtonTapped {
    
    TDFOAMenuHelpViewController *vc = [[TDFOAMenuHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sendButtonTapped {

    [MailInputBox show:1 delegate:self title:NSLocalizedString(@"输入EMAIL地址", nil) val:nil isPresentMode:YES];
}


#pragma mark - MemoInputClient

-(void)finishInput:(NSInteger)event content:(NSString*)content{
    
    [MobClick event:@"wechat_menu_mail"];
    [self showHUBWithText:NSLocalizedString(@"正在发送", nil)];
    [[TDFWechatMarketingService service] sendMenuLinksWithOAId:self.officialAccountId toEmail:content callback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        [self showErrorMessage:NSLocalizedString(@"发送成功", nil)];
    }];
}

#pragma mark - TDFOfficialAccountViewDelegate, TDFOfficialAccountViewDataSource

- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectAddItemInSection:(NSUInteger)section {

    if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
    
        [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
        return;
    }
    if ([[Platform Instance] isChain] && self.officialAccount.storeNum == 0) {
        
        [self showErrorMessage:NSLocalizedString(@"当前公众号并未绑定任何门店！无法设置！", nil)];
        return;
    }
    
    TDFOAMenuModel *menu = self.menus[section];
    
    TDFMenuEditViewController *vc = [TDFMenuEditViewController menuEditViewControllerWithModel:nil editType:TDFMenuEditTypeAdd isSubMenu:YES];
    @weakify(self);
    vc.completionBlock = ^(TDFOAMenuModel *model, TDFMenuEditAction action) {
        @strongify(self);
        
        NSMutableArray *array = menu.subMenus != nil ? [NSMutableArray arrayWithArray:menu.subMenus] : [NSMutableArray array];
        [array insertObject:model atIndex:0];
        menu.subMenus = array;
        self.contentChanged = YES;
        [self.officialAccountView reloadData];
        [self updateNavigationBar];
    };
    vc.officialAccountId = self.officialAccountId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFOAMenuModel *menu = self.menus[indexPath.section];
    
    if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
        
        [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
        return;
    }
    
    if ([[Platform Instance] isChain] && self.officialAccount.storeNum == 0) {
        
        [self showErrorMessage:NSLocalizedString(@"当前公众号并未绑定任何门店！无法设置！", nil)];
        return;
    }
    
    TDFMenuEditViewController *vc = [TDFMenuEditViewController menuEditViewControllerWithModel:menu.subMenus[indexPath.item] editType:TDFMenuEditTypeEdit isSubMenu:YES];
    @weakify(self);
    vc.completionBlock = ^(TDFOAMenuModel *model, TDFMenuEditAction action) {
        @strongify(self);
        self.contentChanged = YES;
        if (action == TDFMenuEditActionEdit) {
        
            [self.officialAccountView reloadData];
            [self updateNavigationBar];
        } else {
        
            NSMutableArray *array = [NSMutableArray arrayWithArray:menu.subMenus];
            [array removeObjectAtIndex:indexPath.item];
            menu.subMenus = array;
            [self.officialAccountView reloadData];
            [self updateNavigationBar];
        }
    };
    vc.officialAccountId = self.officialAccountId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectMenuInSection:(NSUInteger)section {
    
    if (section < self.menus.count) {
        
        TDFOAMenuModel *menu = self.menus[section];
        
        //   被连锁管理的单店
        if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
            
            [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
            return;
        }
        
        if ([[Platform Instance] isChain] && self.officialAccount.storeNum == 0) {
            
            [self showErrorMessage:NSLocalizedString(@"当前公众号并未绑定任何门店！无法设置！", nil)];
            return;
        }
        
        TDFMenuEditViewController *vc = [TDFMenuEditViewController menuEditViewControllerWithModel:menu editType:TDFMenuEditTypeEdit isSubMenu:NO];
        @weakify(self);
        vc.completionBlock = ^(TDFOAMenuModel *model, TDFMenuEditAction action) {
            @strongify(self);
            self.contentChanged = YES;
            if (action == TDFMenuEditActionDelete) {
            
                [self.menus removeObjectAtIndex:section];
            }
            [self.officialAccountView reloadData];
            [self updateNavigationBar];
        };
        vc.officialAccountId = self.officialAccountId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
    
        if (![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain) {
            
            [self showErrorMessage:NSLocalizedString(@"您当前没有权限进行操作，请用连锁账号登录操作", nil)];
            return;
        }
        
        if ([[Platform Instance] isChain] && self.officialAccount.storeNum == 0) {
            
            [self showErrorMessage:NSLocalizedString(@"当前公众号并未绑定任何门店！无法设置！", nil)];
            return;
        }
        
        TDFMenuEditViewController *vc = [TDFMenuEditViewController menuEditViewControllerWithModel:nil editType:TDFMenuEditTypeAdd isSubMenu:NO];
        @weakify(self);
        vc.completionBlock = ^(TDFOAMenuModel *model, TDFMenuEditAction action) {
            @strongify(self);
            self.contentChanged = YES;
            [self.menus addObject:model];
            [self.officialAccountView reloadData];
            [self updateNavigationBar];
        };
        vc.officialAccountId = self.officialAccountId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (NSUInteger)numOfSectionInOfficialAccountView:(TDFOfficialAccountView *)accountView {
    
    return self.menus.count;
}

- (NSUInteger)officialAccountView:(TDFOfficialAccountView *)accountView numOfItemsInSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.subMenus.count;
}

- (BOOL)officialAccountView:(TDFOfficialAccountView *)accountView shouldShowAddItemInSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.type == TDFOAMenuTypeNormal && menu.subMenus.count < 5;
}

- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView menuTitleForSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.name;
}

- (TDFMenuType)officialAccountView:(TDFOfficialAccountView *)accountView menuTypeForSection:(NSUInteger)section {
    
    TDFOAMenuModel *menu = self.menus[section];
    return menu.type == TDFOAMenuTypeNormal ? TDFMenuTypeNormal : TDFMenuTypeURL;
}

- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView titleForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFOAMenuModel *menu = [[self.menus[indexPath.section] subMenus] objectAtIndex:indexPath.item];
    return menu.name;
}

#pragma mark - Accessor

- (NSString *)formatMenuStrings {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.menus.count];
    
    for (TDFOAMenuModel *menu in self.menus) {
        
        TDFOAMenuModel *copiedMenu = [menu copy];
        NSArray *subMenus = copiedMenu.subMenus ?: @[];
        copiedMenu.subMenus = nil;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:2];
        dictionary[@"subMenuList"] = subMenus;
        dictionary[@"parentMenu"] = copiedMenu;
        [array addObject:dictionary];
    }
    
    return [array yy_modelToJSONString];
}


- (TDFIntroductionHeaderView *)headerView {
    
    if (!_headerView) {
        
        @weakify(self);
        _headerView = [TDFIntroductionHeaderView headerViewWithIcon:[UIImage imageNamed:@"wxoa_menu_custom"]
                                                        description:NSLocalizedString(@"店家可以在这里对本店公众号菜单进行调整，请点击下图中底部的菜单栏进行添加或修改，保存后会同步到您的公众号。此功能仅限服务号或认证后的订阅号可用。", nil)
                                                          badgeIcon:[UIImage imageNamed:@"wxoa_wechat_authed"]
                                                        detailTitle:NSLocalizedString(@"查看详细教程", nil)
                                                        detailBlock:^{
                                                            @strongify(self);
                                                            [self helpButtonTapped];
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
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 793);
    }
    return _scrollView;
}



- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[TDFLabelFactory factory] labelForType:TDFLabelTypeSubTitle];
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = NSLocalizedString(@"使用“一键设置公众号菜单”，可将所有功能一次性同步到您的公众号。同步完成后您可以按需要对菜单进行编辑和删除操作。", nil);
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

- (UIButton *)resetButton {

    if (!_resetButton) {
       
        _resetButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeSave];
        BOOL flag = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain;
        [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_resetButton setTitle:NSLocalizedString(@"一键设置公众号菜单", nil) forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        if (flag) {
            _resetButton.backgroundColor = [UIColor colorWithHeX:0x999999];
        }
    }
    
    return _resetButton;
}

- (NSMutableArray *)menus {

    if (!_menus) {

        _menus = [NSMutableArray array];
    }
    
    return _menus;
}

- (TDFMenuPromptView *)promptView {
    
    if (!_promptView) {
        
        @weakify(self);
        _promptView = [TDFMenuPromptView promptViewWithTitle:NSLocalizedString(@"点击以下各个菜单进行设置", nil) closeBlock:^{
            @strongify(self);
            [TDFMarketingStore sharedInstance].menuCopyPromptShown = YES;
            [self.promptView removeFromSuperview];
        }];
    }
    return _promptView;
}

- (UIButton *)sendButton {

    if (!_sendButton) {
    
        _sendButton = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeDetail];
        [_sendButton setTitle:@"发送全部链接到邮箱" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end
