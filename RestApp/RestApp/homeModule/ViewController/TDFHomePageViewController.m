//
//  TDFHomePageViewController.m
//  Pods
//
//  Created by happyo on 2017/3/8.
//
//

#import "TDFHomePageViewController.h"
#import "DHTTableViewManager.h"
#import "Masonry.h"
#import "TDFHomeNotificationView.h"
#import "TDFHomeTwoInLineView.h"
#import "YYModel.h"
#import "TDFHomeGroupSectionView.h"
#import "TDFHomeReportView.h"
#import "TDFHomePageDisplayAPI.h"
#import "EXTScope.h"
#import "TDFCommonRequestAPI.h"
#import "TDFSwitchTool.h"
#import "TDFCodePermissionAPI.h"
#import "MJRefresh.h"
#import "TDFHomeOldBusinessLogicManager.h"
#import "TDFMBHomeViewController.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFRetryHUDPresenter.h"
#import "TDFMediator+ShopManagerModule.h"
#import "TDFRouter.h"
#import "TDFPermissionHelper.h"
#import "MobClick.h"
#import "Platform.h"
#import "TDFIsOpen.h"
#import "SystemNotePanel.h"
#import "TDFMediator+HomeModule.h"
#import "TDFHomeBossCenterView.h"

// old logic
#import "ShopReviewCenter.h"
#import "MainUnit.h"
#import "TDFRightMenuController.h"
#import "Action.h"
#import "ActionConstants.h"
#import "TDFHomeOldBusinessLogicAPI.h"
#import "TDFKabawService.h"
#import "ACTActivityModel.h"
#import "ACTStatisticViewController.h"

static CGFloat notificationSectionHeight = 45;//系统通知高度

@interface TDFHomePageViewController ()

@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TDFHomePageDisplayAPI *displayApi;

@property (nonatomic, strong) TDFAlertAPIHUDPresenter *hudPresenter;

@property (nonatomic, strong) TDFCommonRequestAPI *memberExtensionApi;

@property (nonatomic, strong) TDFCodePermissionAPI *permissionApi;

@property (nonatomic, strong) TDFHomeOldBusinessLogicManager *oldLogicManager;

@property (nonatomic, strong) DHTTableViewSection *notificationSection;

@property (nonatomic, strong) UIView *navigateView;

@property (nonatomic, assign) BOOL needRefresh;

/**
 导航栏左侧按钮
 */
@property (nonatomic, strong) UIButton *leftNavButton;

/**
 导航栏右侧按钮
 */
@property (nonatomic, strong) UIButton *rightNavButton;

/**
 导航栏title
 */
@property (nonatomic, strong) UILabel *navTitleLabel;

@property (nonatomic, strong) UIImageView *selectShopIcon;

@property (nonatomic, strong) UIButton *selectShopButton;

@property (nonatomic,strong) UIImageView *icoSysNotification;//通知的小红点

@property (nonatomic, strong) SystemNotePanel *systemNotePanel;      //系统通知

@property (nonatomic, strong) NSDate *backgroundDate; // 进入后台时间

@end

@implementation TDFHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self initNavigateView];
    
    [self initNotification];
    
    [self addRefresh];
    
    //    [self fetchData];
}

- (void)viewWillAppearByHand
{
    if (self.needRefresh) {
        self.needRefresh = NO;
        [self fetchData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateHomepage) name:Notification_Permission_Change object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateHomepage) name:Notification_HomeDataSourceChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSesstion:) name:Notification_Logout_Session object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateHomepage) name:UPDATE_HOMEPAGE_AND_LEFT_MENU object:nil];
    //刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateHomepage) name:@"loadBusiness" object:nil];
    
    // 刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotification)
                                                 name:@"systemNoteRefresh"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateHomepage) name:@"Notification_HealthCheck" object:nil];
    
}

- (void)becomeActive
{
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:self.backgroundDate];
    
    int hours=((int)time)%(3600*24)/3600;
    
    if (hours >= 1) { // 进入后台一小时，刷新首页
        [self fetchData];
    }
}

- (void)enterBackground
{
    self.backgroundDate = [NSDate date];
}

- (void)needUpdateHomepage
{
    self.needRefresh = YES;
}

- (void)refreshNotification
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = (UINavigationController *)window.rootViewController;
    UIViewController *firstViewController = nav.viewControllers.firstObject;
    if([firstViewController isKindOfClass:[MainUnit class]]) {
        MainUnit *mainUnit = (MainUnit *)firstViewController;
        [mainUnit.otherMenu refreshSysStatus:0];
    }
    
    self.icoSysNotification.hidden = YES;
    self.systemNotePanel.igvNew.hidden = YES;
}

- (void)initNavigateView
{
    [self.view addSubview:self.navigateView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePage_setting_icon"]];
    [self.leftNavButton addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftNavButton).with.offset(15);
        make.bottom.equalTo(self.leftNavButton).with.offset(-10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.navigateView addSubview:self.leftNavButton];
    [self.leftNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navigateView);
        make.top.equalTo(self.navigateView);
        make.height.equalTo(@64);
        make.width.equalTo(@64);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePage_user_icon"]];
    [self.rightNavButton addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightNavButton).with.offset(-15);
        make.bottom.equalTo(self.rightNavButton).with.offset(-10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.navigateView addSubview:self.rightNavButton];
    [self.rightNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.navigateView);
        make.top.equalTo(self.navigateView);
        make.height.equalTo(@64);
        make.width.equalTo(@64);
    }];
    
    [self.navigateView addSubview:self.navTitleLabel];
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigateView);
        make.bottom.equalTo(self.navigateView).with.offset(-12);
        make.height.equalTo(@20);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.navigateView addSubview:self.selectShopIcon];
    [self.selectShopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navTitleLabel.mas_trailing);
        make.centerY.equalTo(self.navTitleLabel);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.navigateView addSubview:self.selectShopButton];
    [self.selectShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navTitleLabel);
        make.top.equalTo(self.navTitleLabel);
        make.bottom.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.selectShopIcon);
    }];
    
    UIView *spliteView = [[UIView alloc] initWithFrame:CGRectZero];
    spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:spliteView];
    [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navigateView);
        make.leading.equalTo(self.navigateView).with.offset(10);
        make.trailing.equalTo(self.navigateView).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    [self.rightNavButton addSubview:self.icoSysNotification];
    [self.icoSysNotification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView.mas_trailing).with.offset(-3);
        make.centerY.equalTo(rightImageView.mas_top).with.offset(3);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
    
}

/**
 下拉刷新
 */
- (void)addRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_LEFT_MENU object:nil];
        [self fetchData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉刷新...", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"正在刷新...", nil) forState:MJRefreshStateRefreshing];
    [header setTitle:NSLocalizedString(@"下拉刷新...", nil) forState:MJRefreshStatePulling];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = header;
}

- (void)fetchData
{
    @weakify(self);
    [self.displayApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        [self configureSectionsWithDataList:response[@"data"]];
    }];
    
    self.oldLogicManager.successApiBlock = ^(TDFHomeOldBusinessLogicManager *manager) {
        @strongify(self);
        [self updateNavbarWithHasOtherEntity:manager.hasOtherEntity];
        if([[Platform Instance] isBranch]) {
            [self dealWithFindNotice:nil];
        }else {
            [self dealWithFindNotice:manager.findNoticeResultVo];
        }
    };
    [self.oldLogicManager configureApis];
    
    [self.permissionApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        [TDFPermissionHelper sharedInstance].functionModelList = [NSArray<TDFHomeGroupForwardChildCellModel *> yy_modelArrayWithClass:[TDFHomeGroupForwardChildCellModel class] json:response[@"data"]];
        
        [Platform Instance].notLockedActionCodeList = [[TDFPermissionHelper sharedInstance] notLockedActionCodeList];
        [Platform Instance].allModuleChargeList = [[TDFPermissionHelper sharedInstance] allModuleChargeList];
        [Platform Instance].codeArray = [Platform Instance].notLockedActionCodeList;
        [self dealWithPowerList:[Platform Instance].notLockedActionCodeList];
        
        [self.oldLogicManager.logicApi start];
    }];
    
    TDFBatchAPIRequest *request = [[TDFBatchAPIRequest alloc] init];
    request.presenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    
    [request addBatchAPIRequests:@[self.displayApi, self.permissionApi]];
    [request setRequestSuccessHandler:^(TDFBatchAPIRequest *request){
        [self.tableView.mj_header endRefreshing];
    }];
    
    [request setRequestFailureHandler:^(TDFBatchAPIRequest *request, NSError *error){
        [self.tableView.mj_header endRefreshing];
    }];
    request.presenter = self.hudPresenter;
    
    [request start];
    
}

- (void)configureSectionsWithDataList:(NSArray *)dataList
{
    [self.manager removeAllSections];
    
    // 默认添加通知栏
    self.notificationSection = [DHTTableViewSection section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [view addSubview:self.systemNotePanel];
    [self.systemNotePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.leading.equalTo(view);
        make.trailing.equalTo(view);
        make.height.equalTo(@(notificationSectionHeight));
    }];
    self.notificationSection.headerView = view;
    self.notificationSection.headerHeight = notificationSectionHeight + 10;
    
    [self.manager addSection:self.notificationSection];
    
    for (NSDictionary *sectionDict in dataList) {
        NSString *sectionStyle = sectionDict[@"sectionStyle"];
        
        if ([sectionStyle isEqualToString:@"section_notification_style"]) {
            TDFHomeNotificationView *notificationView = [[TDFHomeNotificationView alloc] initWithFrame:CGRectZero];
            
            TDFHomeNotificationModel *model = [TDFHomeNotificationModel yy_modelWithDictionary:sectionDict[@"sectionModel"]];
            
            [notificationView configureViewWithModel:model];
            
            DHTTableViewSection *section = [DHTTableViewSection section];
            section.headerView = notificationView;
            section.headerHeight = 44;
            
            [self.manager addSection:section];
        }
        
        if ([sectionStyle isEqualToString:@"section_twoInLine_style"]) {
            NSArray<TDFHomeTwoInLineCellModel *> *cellModelList = [NSArray<TDFHomeTwoInLineCellModel *> yy_modelArrayWithClass:[TDFHomeTwoInLineCellModel class] json:sectionDict[@"sectionModel"]];
        
            @weakify(self);
            TDFHomeTwoInLineView *twoInLineView = [[TDFHomeTwoInLineView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 100)];
            twoInLineView.clickAction = ^ (TDFHomeTwoInLineCellModel *model) {
                @strongify(self);
                [self goNextWithCode:model.actionCode isLock:model.isLock isOpen:model.isOpen functionId:model._id actionName:model.title];
            };
            
            [twoInLineView configureViewWithModelList:cellModelList];
            
            
            DHTTableViewSection *section = [DHTTableViewSection section];
            section.headerView = twoInLineView;
            section.headerHeight = [twoInLineView heightForView];
            
            [self.manager addSection:section];
        }
        
        if ([sectionStyle isEqualToString:@"section_forward_group_style"]) {
            @weakify(self);
            TDFHomeGroupSectionView *groupView = [[TDFHomeGroupSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            
            groupView.clickAction = ^(TDFHomeGroupForwardChildCellModel *model) {
                @strongify(self);
                [self goNextWithCode:model.actionCode isLock:model.isLock isOpen:model.isOpen functionId:model._id actionName:model.title];
            };
            
            TDFHomeGroupSectionModel *groupModel = [TDFHomeGroupSectionModel yy_modelWithDictionary:sectionDict[@"sectionModel"]];
            [groupView configureViewWithModel:groupModel];
            
            DHTTableViewSection *section = [DHTTableViewSection section];
            section.headerView = groupView;
            section.headerHeight = [groupView heightForView];
            
            [self.manager addSection:section];
        }
        
        if ([sectionStyle isEqualToString:@"section_report_style"]) {
            TDFHomeReportView *reportView = [[TDFHomeReportView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
            reportView.forwardWithUrlBlock = ^(NSString *forwardUrl) {
                [self goNextWithUrlString:forwardUrl];
            };
            
            TDFHomeReportModel *reportModel = [TDFHomeReportModel yy_modelWithDictionary:sectionDict[@"sectionModel"]];
            
            [reportView configureViewWithModel:reportModel];
            
            DHTTableViewSection *section = [DHTTableViewSection section];
            section.headerView = reportView;
            section.headerHeight = [reportView heightForView];
            @weakify(self);
            @weakify(section);
            reportView.viewHeightChanged = ^ (CGFloat newHeight) {
                @strongify(self);
                @strongify(section);
                section.headerHeight = newHeight;
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            };
            
            @weakify(reportView);
            reportView.fetchExtensionData = ^(NSString *serviceName) {
                self.memberExtensionApi.serviceName = serviceName;
                @weakify(self);
                [self.memberExtensionApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
                    @strongify(self);
                    reportModel.reportModel = response[@"data"];
                    reportModel.isFold = NO;
                    @strongify(reportView);
                    [reportView configureViewWithModel:reportModel];
                    
                    section.headerView = reportView;
                    section.headerHeight = [reportView heightForView];
                    
                    [self.manager reloadData];
                }];
                [self.memberExtensionApi start];
            };
            
            [self.manager addSection:section];
        }
        
        if ([sectionStyle isEqualToString:@"section_notify_oneInLine_style"]) {
            TDFHomeBossCenterView *bossCenterView = [[TDFHomeBossCenterView alloc] initWithFrame:CGRectZero];
            
            TDFHomeBossCenterModel *model = [TDFHomeBossCenterModel yy_modelWithDictionary:sectionDict[@"sectionModel"]];
            
            [bossCenterView configureViewWithModel:model];
            @weakify(self);
            bossCenterView.clickBlock = ^void (NSString *url) {
                @strongify(self);
                [self goNextWithUrlString:url];
            };
            
            DHTTableViewSection *section = [DHTTableViewSection section];
            section.headerView = bossCenterView;
            section.headerHeight = [TDFHomeBossCenterView heightForView];
            
            [self.manager addSection:section];
        }
    }
    
    [self.manager reloadData];
}

- (void)goNextWithCode:(NSString *)code isLock:(BOOL)isLock isOpen:(BOOL)isOpen functionId:(NSString *)_id actionName:(NSString *)actionName;
{
    if ([code isEqualToString:@"PAD_LOAN_SET"]) {
        [MobClick event:@"click_loan"];//点击"我要贷款"
    }
    if ([code isEqualToString:@"PHONE_BRAND_SYNC_SHOP"]) {
        [MobClick event:@"click_copy_to_shop_icon"];//点击下发到门店
    }
    if ([code isEqualToString:@"PHONE_BRAND_MENU"]) {
        [MobClick event:@"click_commodity_icon"];//点击商品与套餐icon
    }
    
    if (isLock) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),actionName]];
        return ;
    }
    if (isOpen == 0) {
        if ([[Platform Instance] isBranch]) {
            [AlertBox show:NSLocalizedString(@"连锁总部尚未开通企业连锁管理，分公司功能无法使用。", nil)];
        }else{
            TDFFunctionVo *functionVO = [[TDFFunctionVo alloc] init];
            functionVO.id = _id;
            functionVO.actionCode = code;
            [TDFIsOpen goToModuleDetailViewController:functionVO];
        }
        return;
    }
    NSArray *moduleChargeDeniedList = [[TDFPermissionHelper sharedInstance] allModuleChargeList];
    NSArray *roleAllowedList = [[TDFPermissionHelper sharedInstance] notLockedActionCodeList];
    if ([code isEqualToString:PHONE_GUAGUALE]) {
        [self loadShopActivityStatusWithCode:code withModuleChargeDeniedList:moduleChargeDeniedList];
        return;
    }
    
    [[TDFSwitchTool switchTool] pushViewControllerWithCode:code andObject:roleAllowedList andObject:moduleChargeDeniedList withViewController:self];
}

- (void)loadShopActivityStatusWithCode:(NSString *)code withModuleChargeDeniedList:(NSArray *)moduleChargeDeniedList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFKabawService new] getShopActivityStatusParams:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        self.progressHud.hidden = YES;
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSString *activityId = [data objectForKey:@"activityId"];
        //        NSInteger activityStatus = [[data objectForKey:@"activityStatus"] integerValue];
        BOOL downGrade = [[data objectForKey:@"downGrade"] boolValue];
        ACTActivityModel *activityModel = [[ACTActivityModel alloc] init];
        activityModel.status = [[data objectForKey:@"activityStatus"] integerValue];
        if (activityModel.status == 50) {
            [AlertBox show:NSLocalizedString(@"本店目前使用品牌总部的刮刮乐活动，无法单独设置，如需改变请至总部进行设置", nil)];
        }
        else if (activityModel.status == ACTActivityModelStatusWaitRelease || activityModel.status == ACTActivityModelStatusNone) {   /// 去往设置页，围餐椰果 或者待发布的活动
            [self pushWithCode:code withObject:@[activityId?:@"",@(activityModel.status)] andChildFunctionArr:moduleChargeDeniedList];
        }
        else {
            if (downGrade) {  /// 降级 去往设置页
                [self pushWithCode:code withObject:@[activityId?:@"",@(activityModel.status)] andChildFunctionArr:moduleChargeDeniedList];
            }
            else {    ///  去往 报表页
                ACTStatisticVCType vcType;
                if (activityModel.status == ACTActivityModelStatusInProgress || activityModel.status == ACTActivityModelStatusBookingClose) {   /// 进行中 | 预约停止进行 的活动进当月报表
                    vcType = ACTStatisticVCTypeSingleMonth;
                }
                else {
                    vcType = ACTStatisticVCTypeTotal;
                }
                [self pushWithCode:@"PHONE_GUAGUALE_STATISTIC" withObject:@[activityId?:@"",@(vcType),@(activityModel.status)] andChildFunctionArr:moduleChargeDeniedList];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.progressHud.hidden = YES;
        [AlertBox show:NSLocalizedString(error.userInfo[@"NSLocalizedDescription"], nil)];
    }];
}

- (void)pushWithCode:(NSString *)code withObject:(NSArray *)object andChildFunctionArr:(NSArray *)childFunctionArr
{
    [[TDFSwitchTool switchTool] pushViewControllerWithCode:code andObject:object andObject:childFunctionArr withViewController:self];
}

- (void)goNextWithUrlString:(NSString *)urlString
{
    id vc = [[TDFRouter sharedInstance] routerWithUrlString:urlString];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:(UIViewController *)vc animated:YES];
    }
}

#pragma mark -- Old Logic --

///老的权限判断
- (void)dealWithPowerList:(NSArray<NSString *> *)actionList {
    NSMutableDictionary *actionMap = [NSMutableDictionary dictionary];
    for (NSString *actionCode in actionList) {
        Action *action = [[Action alloc] init];
        action.code = actionCode;
        [actionMap setObject:action forKey:action.code];
    }
    if ([[actionMap allKeys] containsObject:PAD_ACCOUNT_OPERATION]) {
        actionMap[PAD_HANDLE_OPERATION] = @"";
        actionMap[PAD_AUTO_OPERATION] = @"";
    }
    [[Platform Instance] setActDic:actionMap];
}


- (void)updateNavbarWithHasOtherEntity:(BOOL)hasOtherEntity
{
    self.leftNavButton.hidden = [[Platform Instance] isBranch];
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    self.navTitleLabel.text = shopName;
    
    if (hasOtherEntity) {
        [self.selectShopIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18);
        }];
        self.selectShopButton.userInteractionEnabled = YES;
    } else {
        [self.selectShopIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        self.selectShopButton.userInteractionEnabled = NO;
    }
}

///通知
- (void)dealWithFindNotice:(NSDictionary *)findNoticeResultVo
{
    if (!findNoticeResultVo) {
        self.notificationSection.headerView.hidden = YES;
        self.notificationSection.headerHeight = 0;
        [self.manager reloadData];
        
        return;
    }
    self.notificationSection.headerView.hidden = NO;
    self.notificationSection.headerHeight = 55;
    NSDictionary *sysNotificationDic = findNoticeResultVo[@"sysNotification"];
    NSUInteger sysNotificationCount = [findNoticeResultVo[@"sysNotificationCount"] integerValue];
    SysNotification *sysNotification = [SysNotification convertToSysNotification:sysNotificationDic];
    id  content = [[NSUserDefaults standardUserDefaults] objectForKey:@"TDFSystemNotifications"];
    BOOL isRead = NO;
    
    if (!sysNotification || !sysNotification._id) {
        isRead = YES;
    }
    
    NSDictionary *notiDict = content [@"data"];
    NSArray *list = [notiDict objectForKey:@"sysNotificationVos"];
    NSMutableArray *notificationList=[SysNotification convertToSysNotificationsByArr:list];
    for (SysNotification *notification in notificationList) {
        if ([notification._id isEqualToString:sysNotification._id]) {
            isRead = YES;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(isRead) forKey:@"isNotificationRead"];
    
    
    [self.systemNotePanel initWithData:sysNotification count:sysNotificationCount];
    [self refreshSysNotification:sysNotificationCount];
    [self.manager reloadData];
}

- (void)refreshSysNotification:(NSUInteger)sysNotificationCount
{
    UINavigationController *naviViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *viewControllers = nil;
    if ([naviViewController isKindOfClass:[UINavigationController class]]) {
        viewControllers = naviViewController.viewControllers;
    }
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[MainUnit class]]) {
            MainUnit *main = (MainUnit *)viewController;
            [main.otherMenu refreshSysStatus:sysNotificationCount];
            break;
        }
    }
    
    NSNumber *isRead = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNotificationRead"];
    
    self.icoSysNotification.hidden = [isRead boolValue];
}

#pragma mark -- Actions --

- (void)selectShopButtonClicked
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    UIViewController *viewController = [mediator TDFMediator_shopSelectViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:nav animated:YES completion:nil];
}

///系统通知
- (void)goSystemNotification{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_sysNotificationViewController];
    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:viewController animated:YES];
}

#pragma mark -- Public Methods --

- (void)showHomeView
{
    self.tableView.hidden = NO;
    //    self.leftNavButton.hidden = NO;
    //    self.rightNavButton.hidden = NO;
    //    self.navTitleLabel.hidden = NO;
    self.navigateView.hidden = NO;
    [self.oldLogicManager showHomeView];
    [self fetchData];
    [Platform Instance].hasWorkShop = YES;
}

- (void)showEntryView
{
    self.tableView.hidden = YES;
    self.navigateView.hidden = YES;
    //    self.leftNavButton.hidden = YES;
    //    self.rightNavButton.hidden = YES;
    //    self.navTitleLabel.hidden = YES;
    [self.oldLogicManager showEntryView];
    [Platform Instance].hasWorkShop = NO;
}

#pragma mark -- Actions --

- (void)leftNavButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
}

- (void)rightNavButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_OTHER_SHOW_NOTIFICATION object:nil];
}

#pragma mark -- Notifications --

- (void)logoutSesstion:(NSNotification *)notification
{
    !self.reSetRootVCFromeMainModuleCallBack?:self.reSetRootVCFromeMainModuleCallBack();
}



#pragma mark -- Getters && Setters --

- (TDFHomePageDisplayAPI *)displayApi
{
    if (!_displayApi) {
        _displayApi = [[TDFHomePageDisplayAPI alloc] init];
        _displayApi.pageCode = @"homepage";
    }
    
    return _displayApi;
}

- (TDFAlertAPIHUDPresenter *)hudPresenter
{
    if (!_hudPresenter) {
        _hudPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _hudPresenter;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    }
    
    return _tableView;
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
    }
    
    return _manager;
}

- (UIView *)navigateView
{
    if (!_navigateView) {
        _navigateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    
    return _navigateView;
}

- (TDFCommonRequestAPI *)memberExtensionApi
{
    if (!_memberExtensionApi) {
        _memberExtensionApi = [[TDFCommonRequestAPI alloc] init];
        _memberExtensionApi.presenter = self.hudPresenter;
    }
    
    return _memberExtensionApi;
}

- (TDFCodePermissionAPI *)permissionApi
{
    if (!_permissionApi) {
        _permissionApi = [[TDFCodePermissionAPI alloc] init];
    }
    
    return _permissionApi;
}

- (UIButton *)leftNavButton
{
    if (!_leftNavButton) {
        _leftNavButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftNavButton addTarget:self action:@selector(leftNavButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _leftNavButton.hidden = [[Platform Instance] isBranch];
    }
    
    return _leftNavButton;
}

- (UIButton *)rightNavButton
{
    if (!_rightNavButton) {
        _rightNavButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightNavButton addTarget:self action:@selector(rightNavButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightNavButton;
}

- (UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _navTitleLabel.font = [UIFont systemFontOfSize:20];
        _navTitleLabel.textColor = [UIColor whiteColor];
    }
    
    return _navTitleLabel;
}

- (UIImageView *)selectShopIcon
{
    if (!_selectShopIcon) {
        _selectShopIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectShopIcon.image = [UIImage imageNamed:@"homePage_shop_select_icon"];
    }
    
    return _selectShopIcon;
}

- (UIButton *)selectShopButton
{
    if (!_selectShopButton) {
        _selectShopButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectShopButton addTarget:self action:@selector(selectShopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectShopButton;
}


- (TDFHomeOldBusinessLogicManager *)oldLogicManager
{
    if (!_oldLogicManager) {
        _oldLogicManager = [[TDFHomeOldBusinessLogicManager alloc] initWithView:self.view];
        _oldLogicManager.rootViewController = TDF_ROOT_NAVIGATION_CONTROLLER;
    }
    
    return _oldLogicManager;
}

- (SystemNotePanel *)systemNotePanel
{
    if (!_systemNotePanel) {
        _systemNotePanel = [[SystemNotePanel alloc] init];
        @weakify(self);
        _systemNotePanel.callBack = ^{
            @strongify(self);
            [self goSystemNotification];
        };
    }
    
    return _systemNotePanel;
}

- (UIImageView *)icoSysNotification
{
    if (!_icoSysNotification) {
        _icoSysNotification = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notiNumIconOne.png"]];
        _icoSysNotification.hidden = YES;
    }
    
    return _icoSysNotification;
}

@end
