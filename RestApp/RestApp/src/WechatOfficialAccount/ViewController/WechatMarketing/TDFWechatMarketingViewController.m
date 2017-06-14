//
//  TDFWechatMarketingViewController.m
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatMarketingViewController.h"
#import "TDFWXMarketingMenuCell.h"
#import "UIColor+Hex.h"
#import "WXOAConst.h"
#import "TDFIsOpen.h"
#import "TDFWechatMarketingService.h"
#import "BackgroundHelper.h"
#import "TDFWXMarketingModel.h"
#import "TDFRefundAuditModel.h"
#import "TDFAutoFollowModel.h"
#import "TDFTraderAuditModel.h"
#import "TDFWXPayTraderModel.h"
#import "TDFAuditStatusViewController.h"
#import "TDFOAAuthIntrouceViewController.h"
#import "TDFWXPayTraderIntroduceViewController.h"
#import "TDFWechatNotificationSettingViewController.h"
#import "TDFWechatNotificationSettingMenuViewController.h"
#import "TDFOAAutoFollowIntroduceViewController.h"
#import "TDFOAMenuIntroduceViewController.h"
#import "TDFMenuPreviewViewController.h"
#import "TDFWechatOfficialAccountsViewController.h"
#import "TDFWXPayTraderListViewController.h"
#import "UIViewController+HUD.h"
#import "TDFWXPayTraderEditViewController.h"
#import "YYModel.h"
#import "Platform.h"
#import "ColorHelper.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFOfficialAccountModel.h"
#import "TDFMarketingStore.h"
#import "BranchShopVo.h"
#import "TDFLimitedShopSelectViewController.h"
#import "TDFWechatAuthorizationListViewController.h"
#import "TDFTraderInfoViewController.h"
#import "TDFRefundApplyViewController.h"
#import "TDFAutoFollowEditViewController.h"
#import "TDFOAAuthDetailViewController.h"
#import "TDFMemberCardToWXListViewController.h"
#import "TDFFansAnalyzeViewController.h"
#import "TDFWXConpousListViewController.h"
#import "TDFWXMarketingMenuItem.h"
#import "TDFTraderManagerViewController.h"
#import "TDFPermissionHelper.h"

@interface TDFWechatMarketingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) TDFWXMarketingModel *marketingModel;

@end

@implementation TDFWechatMarketingViewController

#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [TDFMarketingStore sharedInstance].codeArray = self.codeArray;
    [self configViews];
    [self configNavigationItem];
    self.title = WXOALocalizedString(@"WXOA_MARKETING");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchData];
}

#pragma mark - Private Method

- (void)configViews {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    [self.view addSubview:imageView];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
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
 
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Network

- (void)fetchData {

    [self fetchDataWithCallback:nil];
}


- (void)fetchDataWithCallback:(void(^)())callback {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFWechatMarketingService service] fetchMarkectingInfoWithCallback:^(id responseObj, NSError *error) {
        @strongify(self);
        if (error) {
            [self dismissHUD];
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        self.marketingModel = [TDFWXMarketingModel yy_modelWithJSON:[responseObj objectForKey:@"data"]];
        [TDFMarketingStore sharedInstance].marketingModel = self.marketingModel;
        [self reloadMenus];
        !callback ?: callback();
        [self fetchTraderId];
    }];
}

- (void)fetchTraderId {

    @weakify(self);
    [[TDFWechatMarketingService service] fetchTradersWithCallback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        
        TDFTraderModel *trader = [[NSArray yy_modelArrayWithClass:[TDFTraderModel class] json:[responseObj objectForKey:@"data"]] firstObject];
        [TDFMarketingStore sharedInstance].traderId = trader._id;
        [self.tableView reloadData];
    }];
}

- (void)fecthOfficialAccountsWithCallback:(void(^)(NSArray *array))callback {

    [self showHUBWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService fetchOfficialAccountsAuthorizationListWithCallback:^(id responseObj, NSError *error) {
        [self dismissHUD];
        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSDictionary *dict = responseObj;
            
            NSArray<TDFOfficialAccountModel *> *authorizationList = [NSArray yy_modelArrayWithClass:[TDFOfficialAccountModel class] json:dict[@"data"]];
            callback(authorizationList);
        }
    }];
}

- (void)reloadMenus {

    BOOL hideTraderMenus = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.managedByChain;
    
    for (TDFWXMarketingMenuItem *menuItem in self.menuItems) {
        
        menuItem.hidden = NO;
        if (menuItem.mode & TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain) {
            menuItem.hidden = hideTraderMenus;
        }
        
        if (menuItem.mode & TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain) {
            menuItem.hidden = self.marketingModel.isWxManagedByChain;
        }
        
        switch (menuItem.type) {
            case TDFWXMarketingMenuItemTypeOAAuth: {
                
                if (self.marketingModel.wxoaAuthCount > 0) {
                    
                    menuItem.badgeColor = [UIColor colorWithHeX:0x07AD1F];
                    menuItem.badge = [self isChain] ? [NSString stringWithFormat:NSLocalizedString(@"已授权%zd个", nil), self.marketingModel.wxoaAuthCount] : NSLocalizedString(@"已授权", nil);
                } else {
                    menuItem.badgeColor = [UIColor colorWithHeX:0xCC0000];
                    menuItem.badge = NSLocalizedString(@"未授权", nil);
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TDFWXMarketingMenuItem *item = self.menuItems[indexPath.row];
    return item.hidden ? 0 : 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TDFWXMarketingMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFWXMarketingMenuCell" forIndexPath:indexPath];
    
    TDFWXMarketingMenuItem *item = self.menuItems[ indexPath.row ];
    cell.titleLabel.text = item.title;
    cell.detailLabel.text = item.detail;
    cell.iconImageView.image = item.icon;
    cell.badgeLabel.hidden = item.badgeHidden;
    cell.badgeLabel.text = item.badge;
    cell.badgeLabel.backgroundColor = item.badgeColor;
    cell.hidden = item.hidden;
    cell.versionLabel.backgroundColor = item.isBaseVersion?[ColorHelper getTipColor9]:[ColorHelper getBlueColor];
    cell.versionLabel.text= item.isBaseVersion?@"基础版":@"中级版";
    cell.indicatorImageView.image = [UIImage imageNamed:item.permitted ? ([TDFIsOpen isOpen:item.actionCode childFunctionArr:self.childFunctionArr]?@"wxoa_disclosure_indicator":@"ico_pw_red" ): @"wxoa_lock_white"];
    [cell updateLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TDFWXMarketingMenuItem *item = self.menuItems[ indexPath.row ];
    if (!item.permitted) {
        
        [self showErrorMessage:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), item.title]];
        return;
    }
    if (![TDFIsOpen isOpen:item.actionCode childFunctionArr:self.childFunctionArr]) {
        for (TDFFunctionVo *functionVo in self.childFunctionArr) {
            if ([item.actionCode isEqualToString:functionVo.actionCode]) {
                [TDFIsOpen goToModuleDetailViewController:functionVo];
                return;
            }
        }
    }
    //   换成枚举，不应该用 Magic Number
    switch (item.type) {
        
        case TDFWXMarketingMenuItemTypeTraderManager: {
        
            [self forwardTraderManager];
            break;
        }
            
        case TDFWXMarketingMenuItemTypeOAAuth: {
            
            [self forwardWechatAuth];
            break;
        }
            
        case TDFWXMarketingMenuItemTypeOAMenu: {
            
            [self forwardOfficialAccountMenu];
            break;
        }
            
        case TDFWXMarketingMenuItemTypeOANotification: {
            [self forwardWechatNotification];
            break;
        }
            
        case TDFWXMarketingMenuItemTypeOAQRCode: {
            [self forwardWechatQrcode];
            break;
        }
        case TDFWXMarketingMenuItemTypeOAMemberCard: {
            [self forwardMemberCardToWX];
            break;
        }
        case TDFWXMarketingMenuItemTypeOACoupon: {
            [self forwardConpousToWX];
            break;
        }
        case TDFWXMarketingMenuItemTypeOAFansAnalyze: {
            
            [self forwardFansAnalyze];
        }
        default:
            break;
    }
}

#pragma mark Forword ViewController


/**
 *    各种奇怪的跳转，此处将会成为一坨 💩
 *    男人看了沉默，女人看了落泪的跳转
 */

- (void)forwardTraderManager {

    TDFTraderManagerViewController *vc = [[TDFTraderManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  微信授权
 */
- (void)forwardWechatAuth {
 
    if (self.marketingModel.wxoaAuthStatus == TDFAutoFollowAuditStatusNerverApply) {
        
        TDFOAAuthIntrouceViewController *vc = [[TDFOAAuthIntrouceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
        
            [self showInfoWithOfficialAccount:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self showInfoWithOfficialAccount:[array firstObject]];
        }];
    }
}

- (void)showInfoWithOfficialAccount:(TDFOfficialAccountModel *)model {

    TDFOAAuthDetailViewController *vc = [[TDFOAAuthDetailViewController alloc] init];
    vc.officialAccount = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  自定义公众号菜单
 */
- (void)forwardOfficialAccountMenu {
    
    if (self.marketingModel.wxoaAuthCount == 0) {
        
        TDFOAMenuIntroduceViewController *vc = [[TDFOAMenuIntroduceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.headerHidden = YES;
        vc.navTitle = @"选择您要设置的公众号";
        vc.addButtonHidden = YES;
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
            
            [self showMenuPreviewWithOfficialAccount:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self showMenuPreviewWithOfficialAccount:[array firstObject]];
        }];
    }
}

- (void)showMenuPreviewWithOfficialAccount:(TDFOfficialAccountModel *)model {

    TDFMenuPreviewViewController *vc = [[TDFMenuPreviewViewController alloc] init];
    vc.officialAccountId = model._id;
    vc.officialAccount = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  公众号消息推送
 */
- (void)forwardWechatNotification
{
    if (self.marketingModel.wxoaAuthCount == 0) {
        
        [self forwardWechatNotificationPromotionWithOfficialAccount:nil];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.headerHidden = YES;
        vc.navTitle = @"选择您要设置的公众号";
        vc.addButtonHidden = YES;
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
            
            [self forwardWechatNotificationPromotionWithOfficialAccount:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self forwardWechatNotificationPromotionWithOfficialAccount:[array firstObject]];
        }];
    }
    
}

- (void)forwardWechatNotificationPromotionWithOfficialAccount:(TDFOfficialAccountModel *) officialAccount {
    TDFWechatNotificationSettingMenuViewController *vc =[[TDFWechatNotificationSettingMenuViewController alloc] init];
    vc.officialAccount = officialAccount;
    vc.isAuthorization = officialAccount != nil;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  公众号二维码
 */
- (void)forwardWechatQrcode
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFWechatMarketingService fetchOfficialAccountsAuthorizationListWithCallback:^(id responseObj, NSError *error) {
        [self.progressHud setHidden:YES];

        if (error) {
            [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:error.localizedDescription cancelTitle:NSLocalizedString(@"我知道了", nil)];
        } else {
            NSDictionary *dict = responseObj;
            
            NSArray<TDFOfficialAccountModel *> *authorizationList = [NSArray yy_modelArrayWithClass:[TDFOfficialAccountModel class] json:dict[@"data"]];
            
            if ([self isChain]) {
                if (authorizationList.count > 0) {
                    TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
                    vc.headerHidden = YES;
                    vc.navTitle = @"选择您要设置的公众号";
                    vc.addButtonHidden = YES;
                    @weakify(vc);
                    vc.selectedBlock = ^ (TDFOfficialAccountModel *model) {
                        @strongify(vc);
                        TDFWechatOfficialAccountsViewController *officialAccountsVC = [[TDFWechatOfficialAccountsViewController alloc] init];
                        officialAccountsVC.isChain = YES;
                        officialAccountsVC.isAuthorization = YES;
                        officialAccountsVC.wechatName = model.name;
                        officialAccountsVC.wechatId = model._id;
                        
                        [vc.navigationController pushViewController:officialAccountsVC animated:YES];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    TDFWechatOfficialAccountsViewController *officialAccountsVC = [[TDFWechatOfficialAccountsViewController alloc] init];
                    officialAccountsVC.isChain = YES;
                    officialAccountsVC.isAuthorization = NO;
                    officialAccountsVC.wechatName = @"";
                    officialAccountsVC.wechatId = @"";
                    
                    [self.navigationController pushViewController:officialAccountsVC animated:YES];
                }
            } else {
                if (authorizationList.count > 0) {
                    TDFOfficialAccountModel *singleModel = [authorizationList firstObject];
                    
                    TDFWechatOfficialAccountsViewController *officialAccountsVC = [[TDFWechatOfficialAccountsViewController alloc] init];
                    officialAccountsVC.isChain = NO;
                    officialAccountsVC.isAuthorization = YES;
                    officialAccountsVC.wechatName = singleModel.name;
                    officialAccountsVC.wechatId = singleModel._id;
                    
                    [self.navigationController pushViewController:officialAccountsVC animated:YES];
                } else {
                    TDFWechatOfficialAccountsViewController *officialAccountsVC = [[TDFWechatOfficialAccountsViewController alloc] init];
                    officialAccountsVC.isChain = NO;
                    officialAccountsVC.isAuthorization = NO;
                    officialAccountsVC.wechatName = @"";
                    officialAccountsVC.wechatId = @"";
                    
                    [self.navigationController pushViewController:officialAccountsVC animated:YES];
                    
                }
            }
        }
    }];
}

/**
 * 同步会员卡到微信卡包
 */
- (void)forwardMemberCardToWX {
    if (self.marketingModel.wxoaAuthCount == 0) {
        [self forwardMemberCardToWechat:nil];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.headerHidden = YES;
        vc.navTitle = @"选择您要设置的公众号";
        vc.addButtonHidden = YES;
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
            [self forwardMemberCardToWechat:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self forwardMemberCardToWechat:[array firstObject]];
            
        }];
    }
}

- (void)forwardMemberCardToWechat:(TDFOfficialAccountModel *)model {
    TDFMemberCardToWXListViewController *memberCardToWX = [[TDFMemberCardToWXListViewController alloc] init];
    memberCardToWX.isAuthorized = model!= nil;
    memberCardToWX.officialAccount = model;
    [self.navigationController pushViewController:memberCardToWX animated:YES];
}

/**
 * 同步优惠券到微信卡包
 */
- (void)forwardConpousToWX {
    if (self.marketingModel.wxoaAuthCount == 0) {
        [self forwardConpousToWechat:nil];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.headerHidden = YES;
        vc.navTitle = @"选择您要设置的公众号";
        vc.addButtonHidden = YES;
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
            [self forwardConpousToWechat:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self forwardConpousToWechat:[array firstObject]];
            
        }];
    }

}

- (void)forwardConpousToWechat:(TDFOfficialAccountModel *)model {
    TDFWXConpousListViewController *conpousToWX = [[TDFWXConpousListViewController alloc] init];
    conpousToWX.isAuthorized = model != nil;
    conpousToWX.officialAccount = model;
    [self.navigationController pushViewController:conpousToWX animated:YES];
}

- (void)forwardFansAnalyze {
    
    if (self.marketingModel.wxoaAuthCount == 0) {
        [self showFansAnalyzeWithOfficialAccount:nil];
        return;
    }

    if ([self isChain]) {
        
        TDFWechatAuthorizationListViewController *vc = [[TDFWechatAuthorizationListViewController alloc] init];
        vc.headerHidden = YES;
        vc.navTitle = @"选择您要设置的公众号";
        vc.addButtonHidden = YES;
        vc.selectedBlock = ^void (TDFOfficialAccountModel *model) {
            
            [self showFansAnalyzeWithOfficialAccount:model];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self fecthOfficialAccountsWithCallback:^(NSArray *array) {
            
            [self showFansAnalyzeWithOfficialAccount:[array firstObject]];
        }];
    }
}

- (void)showFansAnalyzeWithOfficialAccount:(TDFOfficialAccountModel *)model {

    TDFFansAnalyzeViewController *vc = [[TDFFansAnalyzeViewController alloc] init];
    vc.officialAccount = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Accessor

- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -100, 0, 0);
        [_tableView registerClass:[TDFWXMarketingMenuCell class] forCellReuseIdentifier:@"TDFWXMarketingMenuCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

- (NSArray *)menuItems {

    if (!_menuItems) {
    
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
        TDFWXMarketingMenuItem *item;

        //   公众号授权
        
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Auth_Title")
                                              detail:WXOALocalizedString(@"WXOA_Auth_Detail")
                                               badge:WXOALocalizedString(@"WXOA_Not_Authed")
                                                icon:[UIImage imageNamed:@"wxoa_auth"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_MERCHANT_GRANT":@"WECHAT_MERCHANT_GRANT";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeOAAuth;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        
        //   公众号菜单自定义
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Menu_Custom_Title")
                                              detail:WXOALocalizedString(@"WXOA_Menu_Custom_Detail")
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_menu_custom"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_MERCHANT_MENU_CUSTOM":@"WECHAT_MERCHANT_MENU_CUSTOM";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeOAMenu;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        //   公众号二维码
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_QRCode_Title")
                                              detail:WXOALocalizedString(@"WXOA_QRCode_Detail")
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_qrcode"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_MERCHANT_QR_CODE":@"WECHAT_MERCHANT_QR_CODE";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeOAQRCode;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        
        //   特约商户申请
        item = [TDFWXMarketingMenuItem itemWithTitle:@"微信支付特约商户申请"
                                              detail:@"包括微信直连、支付即关注等功能"
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_special"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_PAY_SPECIAL_MERCHANT":@"WECHAT_PAY_SPECIAL_MERCHANT";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeTraderManager;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain;
        [array addObject:item];
        
        //   公众号通知
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Notification_Title")
                                              detail:WXOALocalizedString(@"WXOA_Notification_Detail")
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_notification"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_MERCHANT_MESSAGE_PUSH":@"WECHAT_MERCHANT_MESSAGE_PUSH";
        item.isBaseVersion = NO;
        item.type = TDFWXMarketingMenuItemTypeOANotification;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];

        //   卡同步
        item = [TDFWXMarketingMenuItem itemWithTitle:@"同步会员卡到微信卡包"
                                              detail:@"顾客可收到公众号消息领卡，并在卡包中收藏所领到的卡片"
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_member_card"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_SYNC_MEMBER_CARD":@"WECHAT_SYNC_MEMBER_CARD";
        item.isBaseVersion = NO;
        item.type = TDFWXMarketingMenuItemTypeOAMemberCard;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        //   券同步
        item = [TDFWXMarketingMenuItem itemWithTitle:@"同步优惠券到微信卡包"
                                              detail:@"顾客可在公众号中领券，并在卡包中收藏优惠券"
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_coupon"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_SYNC_COUPON":@"WECHAT_SYNC_COUPON";
        item.isBaseVersion = NO;
        item.type = TDFWXMarketingMenuItemTypeOACoupon;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        
        //   粉丝分析
        item = [TDFWXMarketingMenuItem itemWithTitle:@"公众号粉丝数据分析"
                                              detail:@"为公众号粉丝的消费行为提供分析，帮助店家获得更多会员"
                                               badge:nil
                                                icon:[UIImage imageNamed:@"wxoa_fans_analyze"]
                                           permitted:![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode]];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_FANS_DATA_ANALYSIS":@"WECHAT_FANS_DATA_ANALYSIS";
        item.isBaseVersion = NO;
        item.type = TDFWXMarketingMenuItemTypeOAFansAnalyze;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenOAManagedByChain;
        item.permitted = ![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:item.actionCode];

        [array addObject:item];
        _menuItems = [array copy];
    }
    
    return _menuItems;
}

- (BOOL)isChain {
    return [[Platform Instance] isChain];
}

@end

