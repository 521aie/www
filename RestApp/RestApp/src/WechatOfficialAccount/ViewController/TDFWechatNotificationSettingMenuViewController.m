//
//  TDFWechatNotificationSettingMenuViewController.m
//  RestApp
//
//  Created by Xihe on 17/3/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatNotificationSettingMenuViewController.h"
#import "TDFIntroductionHeaderView.h"
#import "WXOAConst.h"
#import "TDFWXMarketingMenuCell.h"
#import "TDFWechatMarketingService.h"
#import "TDFWechatAuthorizationListViewController.h"
#import "TDFWechatNotificationSettingViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFOfficialAccountModel.h"
#import "TDFWechatNotificationPromotionViewController.h"
#import "TDFMarketingStore.h"
#import "TDFWCKeywordsAutoreplyViewController.h"

@interface TDFWXSettingMenuItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (strong, nonatomic) UIImage *icon;
@property (nonatomic) BOOL hidden;                      //   是否要显示

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail  icon:(UIImage *)icon;
+ (instancetype)itemWithTitle:(NSString *)title detail:(NSString *)detail  icon:(UIImage *)icon;

@end

@interface TDFWechatNotificationSettingMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TDFWechatNotificationSettingMenuViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"店家公众号消息推送设置", nil);
    [self configViews];
}

#pragma mark - Config View

- (void)configViews {
    [self.view addSubview:self.tableView];
    [self configureHeaderViewWithAuthorizedStatus:self.isAuthorization];
}

- (void)configureHeaderViewWithAuthorizedStatus:(BOOL)isAuthorized {
    UIImage *iconImage = [UIImage imageNamed:@"wxoa_wechat_notification_icon"];
    NSString *description = NSLocalizedString(@"您可选择开启使用店家公众号给顾客发送订单状态变化的系统消息，也可以推送卡/券/促销活动消息给您的公众号粉丝。", nil);
    TDFIntroductionHeaderView *headerView;
    if (isAuthorized) {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_authorization"]];
    } else {
        headerView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:[UIImage imageNamed:@"wxoa_wechat_notification_unauthorization"]];
    }
    [headerView changeBackAlpha:0.7];
    self.tableView.tableHeaderView=headerView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFWXSettingMenuItem *item = self.menuItems[indexPath.row];
    return item.hidden?0:88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {   
    TDFWXMarketingMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFWXMarketingMenuCell" forIndexPath:indexPath];
    TDFWXSettingMenuItem *item = self.menuItems[ indexPath.row ];
    cell.titleLabel.text = item.title;
    cell.detailLabel.text = item.detail;
    cell.iconImageView.image = item.icon;
    cell.isShowindicatorImageView = YES;
    cell.viewalpha = 0.7;
    cell.hidden = item.hidden;
    [cell updateLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self forwardWechatNotification];
            break;
        }
        case 1: {
            [self forwardPromotion];
            break;
        }
        case 2: {
            [self forwardKeywordsAutoreply];
        } break;
        default:
            break;
    }
}

#pragma mark - Action

- (void)forwardPromotion {
    TDFWechatNotificationPromotionViewController *vc = [[TDFWechatNotificationPromotionViewController alloc] init];
    vc.officialAccount = self.officialAccount;
    vc.isAuthorization = self.isAuthorization;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)forwardWechatNotification {
    TDFWechatNotificationSettingViewController *vc = [[TDFWechatNotificationSettingViewController alloc] init];
    vc.isChain = [self isChain];
    vc.isAuthorization = self.officialAccount != nil;
    vc.hasPermission = ![TDFMarketingStore sharedInstance].marketingModel.isWxManagedByChain;
    vc.wechatId = self.officialAccount._id ?: @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forwardKeywordsAutoreply {

    TDFWCKeywordsAutoreplyViewController *viewController = [[TDFWCKeywordsAutoreplyViewController alloc] initWithAuthorised:self.isAuthorization wxAppId: self.officialAccount._id ?: @""];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Method

- (BOOL)isChain {
    return [[Platform Instance] isChain];
}


#pragma mark - Accessor

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
        TDFWXSettingMenuItem *item;
        item = [[TDFWXSettingMenuItem alloc] initWithTitle:WXOALocalizedString(@"WXOA_Order_State_Title")
                                                    detail:WXOALocalizedString(@"WXOA_Order_State_Detail")
                                                      icon:[UIImage imageNamed:@"wxoa_order_message"]];
        item.hidden = NO;
        [array addObject:item];
        item = [[TDFWXSettingMenuItem alloc]initWithTitle:WXOALocalizedString(@"WXOA_Notification_Promotion_Title")
                                                   detail:WXOALocalizedString(@"WXOA_Notification_Promotion_Detail")
                                                     icon:[UIImage imageNamed:@"wxoa_promotion_message"]];
        item.hidden = NO;
        [array addObject:item];
        
        item = [[TDFWXSettingMenuItem alloc]initWithTitle:@"设置关键词自动回复"
                                                   detail:@"公众号里回复特定文字可以收到卡/券/消息"
                                                     icon:[UIImage imageNamed:@"wx_set_keywords_replay"]];
        [array addObject:item];
        _menuItems = [array copy];
    }
    return _menuItems;
}

@end

@implementation TDFWXSettingMenuItem
+(instancetype) itemWithTitle:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon
{
    return [[[self class] alloc]initWithTitle:title detail:detail icon:icon];
}
-(instancetype) initWithTitle:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon
{
    if (self = [super init]){
        _title = title;
        _detail = detail;
        _icon = icon;
    }
    return  self;
}
@end


