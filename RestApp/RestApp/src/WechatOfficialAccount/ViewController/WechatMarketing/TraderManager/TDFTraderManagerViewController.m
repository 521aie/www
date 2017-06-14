//
//  TDFTraderManagerViewController.m
//  RestApp
//
//  Created by Octree on 11/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTraderManagerViewController.h"
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
#import "TDFWXMarketingMenuItem.h"

@interface TDFTraderManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) TDFWXMarketingModel *marketingModel;

@end

@implementation TDFTraderManagerViewController

#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configNavigationItem];
    self.title = @"微信支付特约商户申请";
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
            case TDFWXMarketingMenuItemTypeSpecialTrader: {
                
                if (self.marketingModel.wxpayTraderApplyStatus == TDFWXPayTraderAuditStatuseSuccess || self.marketingModel.wxpayTraderEstablishCount != 0) {
                    
                    menuItem.badgeColor = [UIColor colorWithHeX:0x07AD1F];
                    menuItem.badge = [self isChain] ? [NSString stringWithFormat:NSLocalizedString(@"已开通%zd个", nil), self.marketingModel.wxpayTraderEstablishCount] : NSLocalizedString(@"已开通", nil);
                } else {
                    menuItem.badgeColor = [UIColor colorWithHeX:0xCC0000];
                    menuItem.badge = NSLocalizedString(@"未开通", nil);
                }
                break;
            }
            case TDFWXMarketingMenuItemTypeRefund: {
                
                menuItem.hidden = self.marketingModel.wxpayTraderApplyStatus != TDFWXPayTraderAuditStatuseSuccess || hideTraderMenus;
                if (self.marketingModel.refundApplyStatus == TDFRefundAuditStatusSuccess) {
                    
                    menuItem.badgeColor = [UIColor colorWithHeX:0x07AD1F];
                    menuItem.badge = [self isChain] ? [NSString stringWithFormat:NSLocalizedString(@"已开通%zd个", nil), self.marketingModel.refundApplyEstablishCount] : NSLocalizedString(@"已开通", nil);
                } else {
                    
                    menuItem.badgeColor = [UIColor colorWithHeX:0xCC0000];
                    menuItem.badge = NSLocalizedString(@"未开通", nil);
                }
                break;
            }
                
            case TDFWXMarketingMenuItemTypeAutoFollow: {
                
                if (self.marketingModel.wxAutoFollowStatus == TDFAutoFollowAuditStatusSuccess) {
                    
                    menuItem.badgeColor = [UIColor colorWithHeX:0x07AD1F];
                    menuItem.badge = [self isChain] ? [NSString stringWithFormat:NSLocalizedString(@"已开通%zd个", nil), self.marketingModel.wxAutoFollowEstablishCount] : NSLocalizedString(@"已开通", nil);
                } else {
                    menuItem.badgeColor = [UIColor colorWithHeX:0xCC0000];
                    menuItem.badge = NSLocalizedString(@"未开通", nil);
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
    cell.indicatorImageView.image = [UIImage imageNamed:@"wxoa_disclosure_indicator"];
    [cell updateLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFWXMarketingMenuItem *item = self.menuItems[ indexPath.row ];
    if (!item.permitted) {
        
        [self showErrorMessage:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), item.title]];
        return;
    }
    //   换成枚举，不应该用 Magic Number
    switch (item.type) {
        case TDFWXMarketingMenuItemTypeSpecialTrader: {
            
            [self forwardWXPayTrader];
            break;
        }
        case TDFWXMarketingMenuItemTypeRefund: {
            
            [self forwardRefund];
            break;
        }
            
        case TDFWXMarketingMenuItemTypeAutoFollow: {
            
            [self forwardAutoFollow];
            break;
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

/**
 *  特约商户
 */
- (void)forwardWXPayTrader {
    
    if (self.marketingModel.wxpayTraderApplyStatus == TDFWXPayTraderAuditStatusNotApply) {
        
        [self.navigationController pushViewController: [[TDFWXPayTraderIntroduceViewController alloc] init] animated:YES];
        return;
    }
    //      连锁
    if ([self isChain]) {
        
        TDFWXPayTraderListViewController *listVC = [[TDFWXPayTraderListViewController alloc] init];
        @weakify(self);
        listVC.selectBlock = ^void(TDFTraderModel *trader) {
            @strongify(self);
            
            //   连锁 & 已经开通
            if ([self isChain] && (trader.status == TDFWXPayTraderAuditStatuseSuccess || trader.status == TDFWXPayTraderAuditStatusNotApply)) {
                
                [self showTraderInfoWithTrader:trader];
                return;
            }
            
            [self showTraderAuditWithTraderId:trader._id status:trader.status];
        };
        [self.navigationController pushViewController:listVC animated:YES];
    } else {
        
        [self showTraderAuditWithTraderId:[TDFMarketingStore sharedInstance].traderId status:self.marketingModel.wxpayTraderApplyStatus];
    }
}

- (void)showTraderInfoWithTrader:(TDFTraderModel *)trader {
    
    //   重置过
    if (trader.status == TDFWXPayTraderAuditStatusNotApply) {
        
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.traderId = trader._id;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    TDFTraderInfoViewController *vc = [[TDFTraderInfoViewController alloc] init];
    vc.model = trader;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showTraderAuditWithTraderId:(NSString *)traderId status:(TDFWXPayTraderAuditStatus)status {
    
    TDFAsync *async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        
        [[TDFWechatMarketingService service] fetchTraderAuditInfoWithTraderId:traderId callback:callback];
    }].fmap(^id(NSDictionary *dict) {
        
        TDFTraderAuditModel *model = [TDFTraderAuditModel yy_modelWithJSON:dict[@"data"]];
        TDFTraderAuditModel *tempModel = [TDFTraderAuditModel auditModelWithStatus:model.status];
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
    
    //      重新申请
    auditStatusViewContrller.reapplyBlock = ^void() {
        @strongify(self);
        TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
        vc.traderId = traderId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    auditStatusViewContrller.traderId = traderId;
    
    [self.navigationController pushViewController:auditStatusViewContrller animated:YES];
}

/**
 *  微信退款
 */
- (void)forwardRefund {
    
    if ([self isChain]) {
        
        TDFWXPayTraderListViewController *vc = [[TDFWXPayTraderListViewController alloc] init];
        vc.selectBlock = ^void (TDFTraderModel *trader) {
            
            if (trader.status == TDFWXPayTraderAuditStatusNotApply) {
                
                TDFWXPayTraderEditViewController *vc = [[TDFWXPayTraderEditViewController alloc] init];
                vc.traderId = trader._id;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            } else if (trader.status != TDFWXPayTraderAuditStatuseSuccess) {
                
                [self showTraderAuditWithTraderId:trader._id status:trader.status];
                return;
            }
            [self showRefundWithTraderId:trader._id status:trader.refundStatus];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [self showRefundWithTraderId:[TDFMarketingStore sharedInstance].traderId status:self.marketingModel.refundApplyStatus];
}


- (void)showRefundWithTraderId:(NSString *)traderId status:(TDFRefundAuditStatus)status {
    
    TDFRefundApplyViewController *vc = [[TDFRefundApplyViewController alloc] init];
    vc.traderId = traderId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  自动关注
 */
- (void)forwardAutoFollow {
    
    if (self.marketingModel.wxAutoFollowStatus == TDFAutoFollowAuditStatusNerverApply
        && self.marketingModel.wxpayTraderApplyStatus == TDFWXPayTraderAuditStatusNotApply) {
        
        TDFOAAutoFollowIntroduceViewController *vc = [[TDFOAAutoFollowIntroduceViewController alloc] init];
        vc.traderId = [TDFMarketingStore sharedInstance].traderId;
        vc.alreadyOpend = NO;
        vc.traderStatus = [TDFMarketingStore sharedInstance].marketingModel.wxpayTraderApplyStatus;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self isChain]) {
        
        TDFWXPayTraderListViewController *vc = [[TDFWXPayTraderListViewController alloc] init];
        vc.selectBlock = ^void (TDFTraderModel *trader) {
            
            [self showAutoFollowWithTraderId:trader._id status:trader.autoFollowStatus traderStatus:trader.status];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    @weakify(self);
    [self fetchDataWithCallback:^{
        @strongify(self);
        
        [self showAutoFollowWithTraderId:[TDFMarketingStore sharedInstance].traderId status:self.marketingModel.wxAutoFollowStatus traderStatus:[TDFMarketingStore sharedInstance].marketingModel.wxpayTraderApplyStatus];
    }];
    
}


- (void)showAutoFollowWithTraderId:(NSString *)traderId status:(TDFAutoFollowAuditStatus)status traderStatus:(TDFWXPayTraderAuditStatus)traderStatus {
    
    if (status != TDFAutoFollowAuditStatusAuditing) {
        
        TDFOAAutoFollowIntroduceViewController *vc = [[TDFOAAutoFollowIntroduceViewController alloc] init];
        vc.traderId = traderId;
        vc.alreadyOpend = status == TDFAutoFollowAuditStatusSuccess;
        vc.traderStatus = traderStatus;
        vc.status = status;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    __block TDFAutoFollowModel *model;
    TDFAsync *async = [TDFAsync asyncWithTrunck:^(TDFAsyncCallback callback) {
        
        [[TDFWechatMarketingService service] fetchAutoFollowInfoWithTraderId:traderId callback:callback];
    }].fmap(^id(NSDictionary *dict) {
        
        model = [TDFAutoFollowModel yy_modelWithJSON:dict[@"data"]];
        return [model bridgeToTraderAuditModel];
    });
    
    @weakify(self);
    TDFAuditStatusViewController *auditStatusViewContrller = [TDFAuditStatusViewController statusViewWithAsync:async title:NSLocalizedString(@"支付后关注公众号", nil) viewProfileBlock:^{
        @strongify(self);
        TDFAutoFollowEditViewController *vc = [[TDFAutoFollowEditViewController alloc] init];
        vc.readOnly = YES;
        vc.traderId = traderId;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //      重新申请
    auditStatusViewContrller.reapplyBlock = ^void() {
        @strongify(self);
        TDFAutoFollowEditViewController *vc = [[TDFAutoFollowEditViewController alloc] init];
        vc.readOnly = NO;
        vc.traderId = traderId;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [self.navigationController pushViewController:auditStatusViewContrller animated:YES];
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
        
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Pay_Trader_Title")
                                              detail:WXOALocalizedString(@"WXOA_Pay_Trader_Detail")
                                               badge:WXOALocalizedString(@"WXOA_Not_Opened")
                                                icon:[UIImage imageNamed:@"wxoa_special"]
                                           permitted:YES];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_PAY_SPECIAL_MERCHANT":@"WECHAT_PAY_SPECIAL_MERCHANT";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeSpecialTrader;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain;
        [array addObject:item];
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Refund_Title")
                                              detail:WXOALocalizedString(@"WXOA_Refund_Detail")
                                               badge:WXOALocalizedString(@"WXOA_Not_Opened")
                                                icon:[UIImage imageNamed:@"wxoa_refund"]
                                           permitted:YES];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_SPECIAL_MERCHANT_REFUND":@"WECHAT_SPECIAL_MERCHANT_REFUND";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeRefund;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain;
        [array addObject:item];
        item = [TDFWXMarketingMenuItem itemWithTitle:WXOALocalizedString(@"WXOA_Auto_Follow_Title")
                                              detail:WXOALocalizedString(@"WXOA_Auto_Follow_Detail")
                                               badge:WXOALocalizedString(@"WXOA_Not_Opened")
                                                icon:[UIImage imageNamed:@"wxoa_auto_follow"]
                                           permitted:YES];
        item.hidden = YES;
        item.actionCode = [Platform Instance].isChain?@"BRAND_WECHAT_PAY_ATTENTION":@"WECHAT_PAY_ATTENTION";
        item.isBaseVersion = YES;
        item.type = TDFWXMarketingMenuItemTypeAutoFollow;
        item.mode = TDFWXMarketingMenuItemModeHiddenWhenTraderManagedByChain;
        [array addObject:item];
        _menuItems = [array copy];
    }
    
    return _menuItems;
}

- (BOOL)isChain {
    return [[Platform Instance] isChain];
}



@end
