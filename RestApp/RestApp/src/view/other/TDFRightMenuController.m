//
//  TDFRightMenuController.m
//  RestApp
//
//  Created by doubanjiang on 2017/4/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRightMenuController.h"
#import "DHTTableViewSection.h"
#import "TDFDisplayCommonItem.h"
#import "DHTTableViewManager.h"
#import "TDFRightMenuItem.h"
#import "TDFRightUserItem.h"
#import "TDFMediator+ShopManagerModule.h"
#import "TDFMediator+AccountRechargeModule.h"
#import "TDFMediator+UserAuth.h"
#import "SysNotificationView.h"
#import "BackgroundView.h"
#import "FeedBackView.h"
#import "AboutView.h"
#import "TDFBarcodeViewController.h"
#import "TDFNetworkEnvironmentController.h"
#import "AppController.h"
#import "NSString+Estimate.h"
#import "SysNotificationVO.h"
#import "EventConstants.h"

static TDFRightMenuController *instance;

@interface TDFRightMenuController ()<IEventListener>

@property (nonatomic, strong) UITableView *tbvBase;

@property (nonatomic, strong) DHTTableViewManager *manager;


///all items
@property (nonatomic ,strong) TDFRightMenuItem *shopsItem;

@property (nonatomic ,strong) TDFRightMenuItem *accountItem;

@property (nonatomic ,strong) TDFRightMenuItem *sysNotiItem;

@property (nonatomic ,strong) TDFRightMenuItem *scanQrItem;

@property (nonatomic ,strong) TDFRightMenuItem *changeBgItem;

@property (nonatomic ,strong) TDFRightMenuItem *feedBackItem;

@property (nonatomic ,strong) TDFRightMenuItem *aboutItem;

///user
@property (nonatomic ,strong) TDFRightUserItem *userItem;

@property (nonatomic ,strong) UIImageView *bgImageView;


@property (nonatomic,strong) UINavigationController *rootViewController;

@property (nonatomic,strong) UINavigationController *rootController;

@end

@implementation TDFRightMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLayout];
    
    [self registCell];
    
    [[Platform Instance] hasWorkShop]?[self showAllItems]:[self showLessItems];
    
    [self addNotifications];
    
    [self refreshUI];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(judgeHasWorkShop:) name:Notification_ShopWorkStatus_Change object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoChanged:) name:Notification_UserInfo_Change object:nil];
    
#if DEBUG
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogout) name:kTDFNetworkDidSwitchEnvironmentNotification object:nil];
#endif
}

- (void)userInfoChanged:(NSNotification *)notification
{
    [self refreshUI];
}

- (void)judgeHasWorkShop:(NSNotification *)notification {
    
    NSDictionary *object = notification.object;
    
    [self configWithhasWorkShop:([object[@"hasWorkShop"] integerValue] == 1)];
}

- (void)configWithhasWorkShop:(BOOL )hasworkShop{

    if (hasworkShop) {
        
        [self showAllItems];
    }else {
    
        [self showLessItems];
    }
}

- (void)showLessItems {

    [self.manager removeAllSections];
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    [section addItem:self.userItem];
    
    [section addItems:@[self.shopsItem,self.changeBgItem,self.aboutItem]];
    
    [self.manager addSection:section];
    
    [self.manager reloadData];
}

- (void)showAllItems {
    
    [self.manager removeAllSections];
    
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    [section addItem:self.userItem];
    
    [section addItem:self.shopsItem];
    
    if (![[Platform Instance] isBranch]) {
        
        [section addItem:self.accountItem];
    }
    
    [section addItems:@[self.sysNotiItem,self.scanQrItem,self.changeBgItem,self.feedBackItem,self.aboutItem]];
    
    [self.manager addSection:section];
    
    [self.manager reloadData];
}

- (void)refreshUI
{
    NSString *nickName, *imageUrl;
    nickName = [Platform Instance].memberExtend.userName;
    imageUrl =[Platform Instance].memberExtend.url;
    NSString *roleName = [Platform Instance].memberExtend.roleName;
//    NSString *shopName = [Platform Instance].memberExtend.shopName;
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];//上述方法取不到值
    
    NSString *company = @"";
    if ([NSString isNotBlank:shopName] && [NSString isNotBlank:roleName]) {
        company = [NSString stringWithFormat:@"%@, %@", shopName, roleName];
    }else if ([NSString isNotBlank:shopName]) {
        company = shopName;
    }
    self.userItem.userName = nickName;
    self.userItem.userCompany = company;
    self.userItem.icoUrl = imageUrl;
    
    [self.manager reloadData];
}

- (void)doLogout
{
    [[AppController shareInstance] startLogout];
}

- (void)registCell {
    
    [self.manager registerCell:@"TDFRightUserCell" withItem:@"TDFRightUserItem"];
    [self.manager registerCell:@"TDFRightMenuCell" withItem:@"TDFRightMenuItem"];
}

- (void)configLayout {
    
    [self.view addSubview:self.bgImageView];
    
    [self.view addSubview:self.tbvBase];
    
    [self configConstrains];
}

- (void)configConstrains {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.tbvBase mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.offset(SCREEN_WIDTH-260);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*2/3);
        make.top.right.bottom.offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IEventListener

- (void)onEvent:(NSString *)eventType {

}

- (void)onEvent:(NSString *)eventType object:(id)object {

    if ([REFRESH_SYS_NOTIFICAION isEqualToString:eventType]) {
        
        SysNotificationVO *sysNotification = (SysNotificationVO *)object;
        [self changeSysNotiNumWithNum:sysNotification.count];
        NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
        
        if ((sysNotification.count>0) && (![isRead boolValue])) {
            
            [self changeSysNotiNumWithNum:sysNotification.count];
            
        }else {
            
            [self changeSysNotiNumWithNum:0];
        }
        [self.manager reloadData];
    }
}

- (void)changeSysNotiNumWithNum:(NSInteger )num {

    self.sysNotiItem.num = num;
    
    [self.manager reloadData];
}

#pragma mark - Getter

- (UINavigationController *)rootViewController{
    if (!_rootViewController) {
        if (self.navigationController) {
            _rootViewController = self.navigationController;
        }else
        {
            _rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        }
    }
    return _rootViewController;
}
- (UITableView *)tbvBase {
    
    if (!_tbvBase) {
        
        _tbvBase = [[UITableView alloc] init];
        _tbvBase.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _tbvBase.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvBase.backgroundColor = [UIColor clearColor];
    }
    return _tbvBase;
}

- (DHTTableViewManager *)manager {
    
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc]initWithTableView:self.tbvBase];
    }
    return _manager;
}

- (TDFRightMenuItem *)shopsItem {
    
    if (!_shopsItem) {
        
        __weak typeof(self) ws = self;
        _shopsItem = [[TDFRightMenuItem alloc]init];
        _shopsItem.title = @"我工作的店家";
        _shopsItem.iconImage = [UIImage imageNamed:@"right_menu_shop"];
        _shopsItem.selectedBlock = ^(){
            
            [ws btnWorkShop];
        };
    }
    return _shopsItem;
}

- (TDFRightMenuItem *)accountItem {
    
    if (!_accountItem) {
        
        __weak typeof(self) ws = self;
        _accountItem = [[TDFRightMenuItem alloc]init];
        _accountItem.title = @"点券账户";
        _accountItem.iconImage = [UIImage imageNamed:@"right_menu_account"];
        _accountItem.selectedBlock = ^(){
            
            [ws btnShowAccountRechargeClick];
        };
    }
    return _accountItem;
}

- (TDFRightMenuItem *)sysNotiItem {
    
    if (!_sysNotiItem) {
        
        __weak typeof(self) ws = self;
        _sysNotiItem = [[TDFRightMenuItem alloc]init];
        _sysNotiItem.title = @"系统通知";
        _sysNotiItem.iconImage = [UIImage imageNamed:@"right_menu_notif"];
        _sysNotiItem.selectedBlock = ^(){
            
            [ws btnSysNotification];
        };
    }
    return _sysNotiItem;
}

- (TDFRightMenuItem *)scanQrItem {
    
    if (!_scanQrItem) {
        
        __weak typeof(self) ws = self;
        _scanQrItem = [[TDFRightMenuItem alloc]init];
        _scanQrItem.title = @"扫一扫";
        _scanQrItem.iconImage = [UIImage imageNamed:@"right_menu_scan"];
        _scanQrItem.selectedBlock = ^(){
            
            [ws btnQRcodeClicked];
        };
    }
    return _scanQrItem;
}

- (TDFRightMenuItem *)changeBgItem {
    
    if (!_changeBgItem) {
        
        __weak typeof(self) ws = self;
        _changeBgItem = [[TDFRightMenuItem alloc]init];
        _changeBgItem.title = @"更换背景图";
        _changeBgItem.iconImage = [UIImage imageNamed:@"right_menu_changeBg"];
        _changeBgItem.selectedBlock = ^(){
            
            [ws btnChageBg];
        };
    }
    return _changeBgItem;
}

- (TDFRightMenuItem *)feedBackItem {
    
    if (!_feedBackItem) {
        
        __weak typeof(self) ws = self;
        _feedBackItem = [[TDFRightMenuItem alloc]init];
        _feedBackItem.title = @"意见反馈";
        _feedBackItem.iconImage = [UIImage imageNamed:@"right_menu_feedback"];
        _feedBackItem.selectedBlock = ^(){
            
            [ws btnMail];
        };
    }
    return _feedBackItem;
}

- (TDFRightMenuItem *)aboutItem {
    
    if (!_aboutItem) {
        
        __weak typeof(self) ws = self;
        _aboutItem = [[TDFRightMenuItem alloc]init];
        _aboutItem.title = @"关于";
        _aboutItem.iconImage = [UIImage imageNamed:@"right_menu_about"];
        _aboutItem.selectedBlock = ^(){
            
            [ws btnAbout];
        };
    }
    return _aboutItem;
}

- (TDFRightUserItem *)userItem {
    
    if (!_userItem) {
        
        __weak typeof(self) ws = self;
        _userItem = [[TDFRightUserItem alloc]init];
        _userItem.selectedBlock = ^(){
            
            [ws btnUserInfo];
        };
        
#if DEBUG
        
        _userItem.changeEnv = ^(){
            
            [ws changeEnvironmentButtonAction:nil];
        };
#endif
    }
    return _userItem;
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_00"]];
    }
    return _bgImageView;
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return _rootController;
}

#pragma indexPathRowSelect

#if DEBUG
- (void)changeEnvironmentButtonAction:(id)sender {
    TDFNetworkEnvironmentController *environmentController = [TDFNetworkEnvironmentController sharedInstance];
    [environmentController switchEnvironmentWithHostViewController:self.rootController];
}

#endif
- (void)btnUserInfo
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_UserInfoViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)btnWorkShop
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopListViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)btnSysNotification
{
    SysNotificationView *syst = [[SysNotificationView alloc]init];
    [syst initDataView];
    [self.rootViewController pushViewController:syst animated:YES];
}

- (void)btnChageBg
{
    [self.rootViewController pushViewController:[[BackgroundView alloc]init] animated:YES];
    
}

- (void)btnMail
{
    [self.rootViewController pushViewController:[[FeedBackView alloc]init] animated:YES];
}

- (void)btnAbout
{
    AboutView *aboutView= [[AboutView alloc]init];
    [self.rootViewController pushViewController:aboutView animated:YES];
}

- (void)btnExit
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确认要退出吗？退出登录不会删除任何数据,重新登录后可继续使用.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    alert.tag=1;
    [alert show];
}

- (void)btnQRcodeClicked{
    TDFBarcodeViewController *bvc = [[TDFBarcodeViewController alloc]init];
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:bvc animated:YES];
}
- (void)btnShowAccountRechargeClick {
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TDFMainAccountRechgeViewController];
    [self.rootViewController pushViewController:viewController animated:YES];
}

/// old funcs

- (void)refreshSysStatus:(NSUInteger)sysNoteCount {
    
    NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
    
    if ((sysNoteCount>0) && (![isRead boolValue])) {
        
        [self changeSysNotiNumWithNum:sysNoteCount];
        
    }else {
    
        [self changeSysNotiNumWithNum:0];
    }
    [self.manager reloadData];
}
+ (TDFRightMenuController *)sharedInstance {

    return instance;
}
- (void)resetShopInfo {

    self.userItem.userCompany = nil;
    
    [self.manager reloadData];
}
- (void)resetDataView {
    
    self.userItem.userName = nil;
    self.userItem.userCompany = nil;
    self.userItem.icoUrl = nil;
    
    [self.manager reloadData];
}

@end





































