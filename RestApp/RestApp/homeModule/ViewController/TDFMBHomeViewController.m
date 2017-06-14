//
//  TDFMemberViewController.m
//  Pods
//
//  Created by happyo on 2017/4/10.
//
//

#import "TDFMBHomeViewController.h"
#import "TDFMemberDisplayAPI.h"
#import "TDFCommonRequestAPI.h"
#import "DHTTableViewManager.h"
#import "Masonry.h"
#import "TDFHomeReportMemberView.h"
#import "TDFMemberInfoDayModel.h"
#import "TDFMemberInfoMonthModel.h"
#import "TDFNumberUtil.h"
#import "YYModel.h"
#import "TDFMemberHistogramView.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFSearchBarNew.h"
#import "TDFMemAlertController.h"
#import "TDFMediator+MemberModule.h"
#import "TDFMemberSearchAPI.h"
#import "NSString+TDF_Empty.h"
#import "CustomerRegister.h"
#import "TDFMediator+MemberLevelModule.h"
#import "TDFIsOpen.h"
#import "TDFPermissionHelper.h"
#import "TDFMMemberOverviewViewController.h"
#import "TDFMMemberSearchListViewController.h"
#import "TDFMemberInfoViewController.h"
#import "TDFMCustomerInfoModel.h"
#import "UIViewController+AlertMessage.h"
#import "TDFMMemberCodeRouter.h"

#define TDFMEMBER_HOME_HIDEALERT1 @"TDFMEMBER_HOME_HIDEALERT1"
#define TDFMEMBER_HOME_HIDEALERT2 @"TDFMEMBER_HOME_HIDEALERT2"

@interface TDFMBHomeViewController () <TDFMemberHistogramViewProtocol, TDFSearchBarNewDelegate>

@property (nonatomic, strong) TDFMemberDisplayAPI *displayApi;

@property (nonatomic, strong) TDFCommonRequestAPI *dayStyleApi;

@property (nonatomic, strong) TDFCommonRequestAPI *monthStyleApi;

@property (nonatomic, strong) TDFMemberSearchAPI *memberSearchApi;

@property (nonatomic, strong)TDFGeneralPageAPI *queryCustomerListapi;

@property (nonatomic, strong) TDFAlertAPIHUDPresenter *hudPresenter;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DHTTableViewManager *manager;

@property (nonatomic, strong) TDFMemberHistogramView *memberHistogramView;

@property (nonatomic, strong) DHTTableViewSection *forwardSection;

@property (nonatomic, strong) DHTTableViewSection *lastMemberSection;

@property (nonatomic, strong) TDFHomeReportMemberView *lastMemberCell;

@property (nonatomic, strong) DHTTableViewSection *allMemberSection;

@property (nonatomic, strong) TDFHomeReportMemberView *allMemberCell;

@property (nonatomic, strong) NSArray<TDFHomeReportMemberModel *> *dayReportList;

@property (nonatomic, strong) NSArray<TDFHomeReportMemberModel *> *monthReportList;

@property (nonatomic, strong) UIView *forwardView;

@property (nonatomic, assign) BOOL hasEnterBefore;

@property (nonatomic, strong) NSString *selectedDayString;

/**
 会员等级特权 是否有权限
 */
//@property (nonatomic, assign) BOOL isHasPermission;

@end

@implementation TDFMBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"会员";
    
    TDFSearchBarNew *searchBar = [[TDFSearchBarNew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    searchBar.delegate = self;
    searchBar.placeholder = @"会员卡号／手机号";
    searchBar.rightButtonTitle = @"查询";
    
    [self.view addSubview:searchBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(48);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self configureSections];
    
    @weakify(self);
    [self.dayStyleApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        NSArray<TDFMemberInfoDayModel *> *dayList = [NSArray<TDFMemberInfoDayModel *> yy_modelArrayWithClass:[TDFMemberInfoDayModel class] json:response[@"data"]];
        
        self.dayReportList = [self dayReportListWithDayModelList:dayList];
        @weakify(self);
        [self.displayApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
            @strongify(self);
            NSArray *customerLevelVos = response[@"data"][@"customerLevelVos"];
            TDFMemberLevelModel *memberBarModel = [[TDFMemberLevelModel alloc] init];
            memberBarModel.barCells = [self cellModelListWithDictList:customerLevelVos];
            [self.memberHistogramView configureViewWithDayList:dayList];

            [self.allMemberCell configureViewWithModel:[self transformMemberDayToAllMemberItem:dayList.lastObject memberBarModel:memberBarModel]];
            
            self.allMemberSection.headerHeight = [self.allMemberCell heightForView];
            [self.manager reloadData];
            
//            NSNumber *isHasPermission = response[@"data"][@"isHasPermission"];
//            self.isHasPermission = [isHasPermission boolValue];

            TDFMemberInfoDayModel *infoModel = dayList.firstObject;
            [self showAlertWindowWithHasSet:[response[@"data"][@"isPrivilegeSet"] integerValue]==1 ? YES : NO andCustomerNumsmall:(infoModel.customerNum < 1000)];

        }];
        [self.displayApi start];

    }];
    [self.dayStyleApi start];
}

- (void)configureSections
{
    DHTTableViewSection *histogramSection = [DHTTableViewSection section];
    
    histogramSection.headerView = self.memberHistogramView;
    histogramSection.headerHeight = [self.memberHistogramView heightForView];
    
    [self.manager addSection:histogramSection];
    
    self.forwardSection.headerView = [self forwardView];
    
    if ([[Platform Instance] isChain]) {
        self.forwardSection.headerView.hidden = YES;
        self.forwardSection.headerHeight = 0;
    } else {
        self.forwardSection.headerView.hidden = NO;
        self.forwardSection.headerHeight = 50;
    }
    
    [self.manager addSection:self.forwardSection];
    
    UIView *lastMemberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [lastMemberView addSubview:self.lastMemberCell];
    [self.lastMemberCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastMemberView);
        make.leading.equalTo(lastMemberView).with.offset(10);
        make.trailing.equalTo(lastMemberView).with.offset(-10);
        make.bottom.equalTo(lastMemberView);
    }];
    
    self.lastMemberSection.headerView = lastMemberView;
    self.lastMemberSection.headerHeight = 254;
    [self.manager addSection:self.lastMemberSection];
    
    UIView *allMemberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [allMemberView addSubview:self.allMemberCell];
    [self.allMemberCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allMemberView).with.offset(10);
        make.leading.equalTo(allMemberView).with.offset(10);
        make.trailing.equalTo(allMemberView).with.offset(-10);
        make.bottom.equalTo(allMemberView);
    }];
    
    self.allMemberSection.headerView = allMemberView;
    self.allMemberSection.headerHeight = 350;
    [self.manager addSection:self.allMemberSection];
}

- (NSArray<TDFMemberLevelCellModel *> *)cellModelListWithDictList:(NSArray *)dictList
{
    NSMutableArray<TDFMemberLevelCellModel *> *cellModelList = [NSMutableArray<TDFMemberLevelCellModel *> array];
    
    for (NSDictionary *dict in dictList) {
        TDFMemberLevelCellModel *cellModel = [[TDFMemberLevelCellModel alloc] init];
        
        cellModel.title = dict[@"name"];
        NSNumber *count = dict[@"count"];
        cellModel.count = [count integerValue];
        NSNumber *level = dict[@"level"];
        cellModel.countUnit = [NSString stringWithFormat:@"V%i", [level intValue]];
        cellModel.percent = [NSString stringWithFormat:@"%@%@", dict[@"percent"], @"%"];
        
        [cellModelList addObject:cellModel];
    }
    
    return cellModelList;
}

- (NSArray<TDFHomeReportMemberModel *> *)dayReportListWithDayModelList:(NSArray<TDFMemberInfoDayModel *> *)dayModelList
{
    NSMutableArray<TDFHomeReportMemberModel *> *dayReportList = [NSMutableArray<TDFHomeReportMemberModel *> array];
    
    for (TDFMemberInfoDayModel *dayModel in dayModelList) {
        [dayReportList addObject:[self transformMemberDayToLastMemberItem:dayModel]];
    }
    
    return dayReportList;
}

- (TDFHomeReportMemberModel *)transformMemberDayToLastMemberItem:(TDFMemberInfoDayModel *)dayModel
{
    TDFHomeReportMemberModel *model = [[TDFHomeReportMemberModel alloc] init];
    
    NSMutableArray<TDFHomeReportListCellModel *> *commonCells = [NSMutableArray<TDFHomeReportListCellModel *> array];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"新增会员"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.customerNumDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.customerNumDay baseUnit:@"人"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"老会员"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.customerOldNumDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.customerOldNumDay baseUnit:@"人"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"领卡数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.receiveCardDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.receiveCardDay baseUnit:@"张"]]];
    
    TDFHomeReportListCellModel *rechargeMoney = [TDFHomeReportListCellModel cellModelWithTitle:@"充值金额"
                                                                                         count:[TDFNumberUtil seperatorDotStringWithDouble:dayModel.memberChargeAmountDay]
                                                                                     countUnit:[TDFNumberUtil unitWithNum:dayModel.memberChargeAmountDay baseUnit:@"元"]];
    rechargeMoney.isImportant = YES;
    [commonCells addObject:rechargeMoney];

    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"充值次数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.memberChargeTimesDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.memberChargeTimesDay baseUnit:@"次"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"卡消费金额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:dayModel.cardPayMoneyDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.cardPayMoneyDay baseUnit:@"元"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"卡消费次数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.cardPayNumDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.cardPayNumDay baseUnit:@"次"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费单数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.customerPayNumDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.customerPayNumDay baseUnit:@"单"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费单数占比"
                                                                    count:dayModel.customerPayNumPercent
                                                                countUnit:@""]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费金额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:dayModel.customerPayMoneyDay]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.customerPayMoneyDay baseUnit:@"元"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费金额占比"
                                                                    count:dayModel.customerPayMoneyPercent
                                                                countUnit:@""]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;

    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[dateFormatter dateFromString:dayModel.date]];
    
    NSString *prefix = [yesterdayString isEqualToString:dayModel.date] ? @"昨" : @"当";

    model.title = [NSString stringWithFormat:@"%@日会员信息汇总（%i年%02i月%02i日）", prefix, (int)components.year, (int)components.month, (int)components.day];
    
    model.commonCells = commonCells;
    
    return model;
}

- (TDFHomeReportMemberModel *)transformMemberDayToAllMemberItem:(TDFMemberInfoDayModel *)dayModel memberBarModel:(TDFMemberLevelModel *)memberBarModel
{
    TDFHomeReportMemberModel *model = [[TDFHomeReportMemberModel alloc] init];
    
    NSMutableArray<TDFHomeReportListCellModel *> *commonCells = [NSMutableArray<TDFHomeReportListCellModel *> array];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员总数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.customerNum]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.customerNum baseUnit:@"人"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"领卡总数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:dayModel.receiveCard]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.receiveCard baseUnit:@"张"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员充值余额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:dayModel.rechargeMoney]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.rechargeMoney baseUnit:@"元"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员充值总额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:dayModel.memberChargeAmount]
                                                                countUnit:[TDFNumberUtil unitWithNum:dayModel.memberChargeAmount baseUnit:@"元"]]];
    
    model.title = @"会员信息汇总（截止到昨日）";
    
    model.commonCells = commonCells;
    
    model.desc = @"提示：会员卡消费和充值明细，请到“报表中心-会员报表”查看。";
    NSString *actionCode = [[Platform Instance] isChain] ? @"PHONE_BRAND_PRIVILEGE" : @"PHONE_PRIVILEGE";
//    NSString *couponActionCode = [[Platform Instance] isChain] ? @"PHONE_BRAND_DISCOUNT_COUPON" : @"PHONE_COUPON";
    // 会员等级特权有权限 , 并且还有模块开通过才显示 会员等级分布图 和 跳转按钮
    BOOL hasPermission = (![[TDFPermissionHelper sharedInstance] isLockedWithActionCode:actionCode])
                         && [TDFIsOpen isOpen:actionCode childFunctionArr:[[TDFPermissionHelper sharedInstance] allModuleChargeList]];
    if (hasPermission) {
        model.memberBarModel = memberBarModel;
        
        self.allMemberCell.forwardString = @"会员等级特权设置";
        @weakify(self);
        self.allMemberCell.forwardWithUrlBlock = ^(NSString *forwardUrl) {
            @strongify(self);
            [self goPrivilege];
        };
        self.allMemberCell.forwardUrl = @"";
    }
    
    return model;
}

- (NSArray<TDFHomeReportMemberModel *> *)monthReportListWithMonthModelList:(NSArray<TDFMemberInfoMonthModel *> *)monthModelList
{
    NSMutableArray<TDFHomeReportMemberModel *> *monthReportList = [NSMutableArray<TDFHomeReportMemberModel *> array];
    
    for (TDFMemberInfoMonthModel *monthModel in monthModelList) {
        [monthReportList addObject:[self transformMemberMonthToLastMemberItem:monthModel]];
    }
    
    return monthReportList;
}

- (TDFHomeReportMemberModel *)transformMemberMonthToLastMemberItem:(TDFMemberInfoMonthModel *)monthModel
{
    TDFHomeReportMemberModel *model = [[TDFHomeReportMemberModel alloc] init];
    
    NSMutableArray<TDFHomeReportListCellModel *> *commonCells = [NSMutableArray<TDFHomeReportListCellModel *> array];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"新增会员"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.customerNumMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.customerNumMonth baseUnit:@"人"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"老会员"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.customerOldNumMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.customerOldNumMonth baseUnit:@"人"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"领卡数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.receiveCardMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.receiveCardMonth baseUnit:@"张"]]];
    TDFHomeReportListCellModel *rechargeMoney = [TDFHomeReportListCellModel cellModelWithTitle:@"充值金额"
                                                                                         count:[TDFNumberUtil seperatorDotStringWithDouble:monthModel.memberChargeAmountMonth]
                                                                                     countUnit:[TDFNumberUtil unitWithNum:monthModel.memberChargeAmountMonth baseUnit:@"元"]];
    rechargeMoney.isImportant = YES;
    [commonCells addObject:rechargeMoney];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"充值次数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.memberChargeTimesMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.memberChargeTimesMonth baseUnit:@"次"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"卡消费金额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:monthModel.cardPayMoneyMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.cardPayMoneyMonth baseUnit:@"元"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"卡消费次数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.cardPayNumMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.cardPayNumMonth baseUnit:@"次"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费单数"
                                                                    count:[TDFNumberUtil seperatorDotStringWithInt:monthModel.customerPayNumMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.customerPayNumMonth baseUnit:@"单"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费单数占比"
                                                                    count:monthModel.customerPayNumPercent
                                                                countUnit:@""]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费金额"
                                                                    count:[TDFNumberUtil seperatorDotStringWithDouble:monthModel.customerPayMoneyMonth]
                                                                countUnit:[TDFNumberUtil unitWithNum:monthModel.customerPayMoneyMonth baseUnit:@"元"]]];
    
    [commonCells addObject:[TDFHomeReportListCellModel cellModelWithTitle:@"会员消费金额占比"
                                                                    count:monthModel.customerPayMoneyPercent
                                                                countUnit:@""]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMM";
    
    NSString *currentMonthString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *prefix = [currentMonthString isEqualToString:monthModel.month] ? @"本" : @"当";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[dateFormatter dateFromString:monthModel.month]];
    
    model.title = [NSString stringWithFormat:@"%@月会员信息汇总（%i年%02i月）", prefix,(int)components.year, (int)components.month];
    
    model.commonCells = commonCells;
    
    return model;
}

- (void)showAlertWindowWithHasSet:(BOOL )hasSet andCustomerNumsmall:(BOOL )customerNumS
{
    NSString *shopName = [TDFDataCenter sharedInstance].shopName;
    
    if (!self.hasEnterBefore) {
        
        self.hasEnterBefore = YES;
        
        NSMutableArray *param = [NSMutableArray new];
        
        
        
        if (customerNumS&&(![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",TDFMEMBER_HOME_HIDEALERT1,shopName]])&&(![[Platform Instance] isChain])) {
            
            [param addObject:@"1"];//会员太少
            
        }
        // 这期服务端工作量有点大，这个弹框就不弹了，下期再改动
//        else if (!hasSet&&(![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",TDFMEMBER_HOME_HIDEALERT2,shopName]])&&(self.isHasPermission)) {
//            
//            [param addObject:@"2"];//等级特权
//            
//        }
        else {
            
            return;
        }
        TDFMemAlertController *alertVc = [[TDFMemAlertController alloc]init];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
        
        [alertVc loadDatas:param left:^(NSDictionary *dict) {//不再提醒
            
            if ([[dict objectForKey:@"code"] isEqualToString:@"1"]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",TDFMEMBER_HOME_HIDEALERT1,shopName]];
                
            }else if ([[dict objectForKey:@"code"] isEqualToString:@"2"]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",TDFMEMBER_HOME_HIDEALERT2,shopName]];
            }
            
        } right:^(NSDictionary *dict) {
            
            if ([[dict objectForKey:@"code"] isEqualToString:@"1"]) {
                
                
            }else if ([[dict objectForKey:@"code"] isEqualToString:@"2"]) {
                
                [self goPrivilege];
            }
        }];
    }
}

#pragma mark -- Actions --

- (void)goMemberList
{
//    UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_tdfMemberListViewController];
//    
//    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
    
    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:[[TDFMMemberOverviewViewController alloc] init] animated:YES];
}

- (void)goMemberConsumption
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSDate *date = [dateFormatter dateFromString:self.selectedDayString];
    UIViewController *vc = [[TDFMediator sharedInstance] TDFMediator_TDFTodayVipSpendControllerWithDate:date];
    
    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
}

//跳转会员等级特权
- (void)goPrivilege {
    UIViewController *vc = [[Platform Instance] isChain] ? [[TDFMediator sharedInstance] TDFMediator_memberChainLevelViewController] :[[TDFMediator sharedInstance] TDFMediator_memberlevelViewController];

    [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:vc animated:YES];
}

#pragma mark -- TDFSearchBarNewDelegate --

- (void)searchBarCancelButtonClicked:(TDFSearchBarNew *)searchBar
{
    [self.view endEditing:YES];

    [self searchWithKeyword:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(TDFSearchBarNew *)searchBar
{
    [self.view endEditing:YES];

    [self searchWithKeyword:searchBar.text];
}

- (void)searchWithKeyword:(NSString *)keyword
{
    if (keyword.length == 0) {
        [self.navigationController pushViewController:[[TDFMMemberOverviewViewController alloc] init] animated:YES];
        return;
    }
    
    self.queryCustomerListapi.params[kTDFAPMemberQueryCustomerListKeywordKey] = keyword;
    @weakify(self)
    [self.queryCustomerListapi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self)
        NSArray *dataList = [NSArray yy_modelArrayWithClass:[TDFMCustomerInfoModel class] json:response[@"data"]];
        switch (dataList.count) {
            case 0: {
                [self showAlert:NSLocalizedString(@"抱歉，没有查询到该会员信息", nil) confirm:nil];
            } break;
                
            case 1: {
                TDFMemberInfoViewController *viewController = [[TDFMemberInfoViewController alloc] init];
                TDFMCustomerInfoModel *info = [dataList firstObject];
                viewController.customerId = info.customerId;
                viewController.customerRegisterId = info.customerRegisterId;
                [self.navigationController pushViewController:viewController animated:YES];
            } break;
                
            default: {
                TDFMMemberSearchListViewController *viewController = [[TDFMMemberSearchListViewController alloc] initWithInformations:dataList];
                viewController.selectInfoHandler = ^(TDFMCustomerInfoModel *info) {
                    [[TDFMMemberCodeRouter shareInstance] codeRouterWithFunctionCode:TDFMemberSearchViewFunctionMemberInfo
                                                                   CustomerInfoModel:info
                                                                andCurrentController:self];
                };
                [self.navigationController pushViewController:viewController animated:YES];
            } break;
        }
    }];
    
    [self.queryCustomerListapi setCurrentPageSizeBlock:^NSInteger(id response) {
        return [(NSArray *)response[@"data"] count];
    }];
    [self.queryCustomerListapi start];
}


#pragma mark -- TDFMemberHistogramViewProtocol --

- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView switchStyle:(BOOL)isDayStyle
{
    if (isDayStyle) {
        @weakify(self);
        [self.dayStyleApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
            @strongify(self);
            NSArray<TDFMemberInfoDayModel *> *dayList = [NSArray<TDFMemberInfoDayModel *> yy_modelArrayWithClass:[TDFMemberInfoDayModel class] json:response[@"data"]];
            self.dayReportList = [self dayReportListWithDayModelList:dayList];

            [self.memberHistogramView configureViewWithDayList:dayList];

        }];
        [self.dayStyleApi start];
        if ([[Platform Instance] isChain]) {
            self.forwardSection.headerView.hidden = YES;
            self.forwardSection.headerHeight = 0;
        } else {
            self.forwardSection.headerView.hidden = NO;
            self.forwardSection.headerHeight = 50;
        }
        
        [self.manager reloadData];
    } else {
        @weakify(self);
        [self.monthStyleApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
            @strongify(self);
            NSArray<TDFMemberInfoMonthModel *> *monthList = [NSArray<TDFMemberInfoMonthModel *> yy_modelArrayWithClass:[TDFMemberInfoMonthModel class] json:response[@"data"]];
            self.monthReportList = [self monthReportListWithMonthModelList:monthList];

            [self.memberHistogramView configureViewWithMonthList:monthList];
            
        }];
        [self.monthStyleApi start];
        self.forwardSection.headerView.hidden = YES;
        self.forwardSection.headerHeight = 0;
        [self.manager reloadData];
    }
}

- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView didScrollToDayModel:(TDFMemberInfoDayModel *)dayModel atIndex:(NSInteger)index
{
    self.selectedDayString = dayModel.date;
    [self.lastMemberCell configureViewWithModel:self.dayReportList[index]];
}

- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView didScrollToMonthModel:(TDFMemberInfoMonthModel *)monthModel atIndex:(NSInteger)index
{
    [self.lastMemberCell configureViewWithModel:self.monthReportList[index]];
}

#pragma mark -- Getters && Setters --

- (TDFMemberDisplayAPI *)displayApi
{
    if (!_displayApi) {
        _displayApi = [[TDFMemberDisplayAPI alloc] init];
        _displayApi.presenter = self.hudPresenter;
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

- (TDFGeneralPageAPI *)queryCustomerListapi {
    if (!_queryCustomerListapi) {
        _queryCustomerListapi = [[TDFGeneralPageAPI alloc] init];
        _queryCustomerListapi.requestModel = [TDFMemberRequestModel modelWithActionPath:kTDFAPMemberQueryCustomerList
                                                                             andVersion:TDFRquestActionPathVersionV2];
        _queryCustomerListapi.pageNumberKey = @"page";
        _queryCustomerListapi.presenter = self.hudPresenter;
        _queryCustomerListapi.pageNumber = 0;
    }
    return _queryCustomerListapi;
}

- (TDFCommonRequestAPI *)dayStyleApi
{
    if (!_dayStyleApi) {
        _dayStyleApi = [[TDFCommonRequestAPI alloc] init];
        _dayStyleApi.presenter = self.hudPresenter;
        _dayStyleApi.serviceName = @"/memberstat/v3/get_member_statistics_by_date";
    }
    
    return _dayStyleApi;
}

- (TDFCommonRequestAPI *)monthStyleApi
{
    if (!_monthStyleApi) {
        _monthStyleApi = [[TDFCommonRequestAPI alloc] init];
        _monthStyleApi.presenter = self.hudPresenter;
        _monthStyleApi.serviceName = @"/memberstat/v3/get_member_statistics_month";
    }
    
    return _monthStyleApi;
}

- (TDFMemberSearchAPI *)memberSearchApi
{
    if (!_memberSearchApi) {
        _memberSearchApi = [[TDFMemberSearchAPI alloc] init];
        _memberSearchApi.presenter = self.hudPresenter;
    }
    
    return _memberSearchApi;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
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

- (TDFHomeReportMemberView *)lastMemberCell
{
    if (!_lastMemberCell) {
        _lastMemberCell = [[TDFHomeReportMemberView alloc] initWithFrame:CGRectZero];
        _lastMemberCell.layer.cornerRadius = 5;
        _lastMemberCell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    
    return _lastMemberCell;
}

- (DHTTableViewSection *)lastMemberSection
{
    if (!_lastMemberSection) {
        _lastMemberSection = [DHTTableViewSection section];
    }
    
    return _lastMemberSection;
}

- (TDFHomeReportMemberView *)allMemberCell
{
    if (!_allMemberCell) {
        _allMemberCell = [[TDFHomeReportMemberView alloc] initWithFrame:CGRectZero];
        _allMemberCell.layer.cornerRadius = 5;
        _allMemberCell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    
    return _allMemberCell;
}

- (DHTTableViewSection *)allMemberSection
{
    if (!_allMemberSection) {
        _allMemberSection = [DHTTableViewSection section];
    }
    
    return _allMemberSection;
}

- (DHTTableViewSection *)forwardSection
{
    if (!_forwardSection) {
        _forwardSection = [DHTTableViewSection section];
    }
    
    return _forwardSection;
}

- (TDFMemberHistogramView *)memberHistogramView
{
    if (!_memberHistogramView) {
        _memberHistogramView = [[TDFMemberHistogramView alloc] initWithFrame:self.view.bounds];
        _memberHistogramView.delegate = self;
    }
    
    return _memberHistogramView;
}


- (UIView *)forwardView
{
    if (!_forwardView) {
        _forwardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        
        // 查看会员一览
        UIButton *memberListButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [memberListButton addTarget:self action:@selector(goMemberList) forControlEvents:UIControlEventTouchUpInside];
        
        [_forwardView addSubview:memberListButton];
        
        [memberListButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_forwardView);
            make.centerY.equalTo(_forwardView);
            make.height.equalTo(@13);
            make.width.equalTo(@90);
        }];
        
        UILabel *memberListLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        memberListLabel.font = [UIFont systemFontOfSize:13];
        memberListLabel.textColor = [UIColor whiteColor];
        memberListLabel.text = @"查看会员一览";
        [memberListButton addSubview:memberListLabel];
        [memberListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(memberListButton).with.offset(20);
            make.centerY.equalTo(memberListButton);
            make.height.equalTo(memberListButton);
        }];
        
        UIImageView *memberListIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        memberListIcon.image = [UIImage imageNamed:@"homePage_arrow_right"];
        [memberListButton addSubview:memberListIcon];
        [memberListIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(memberListLabel.mas_trailing);
            make.centerY.equalTo(memberListButton);
            make.width.equalTo(@13);
            make.height.equalTo(@13);
        }];
        
        // 查看当日会员消费记录
        UIButton *memberConsumptionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [memberConsumptionButton addTarget:self action:@selector(goMemberConsumption) forControlEvents:UIControlEventTouchUpInside];
        
        [_forwardView addSubview:memberConsumptionButton];
        
        [memberConsumptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_forwardView);
            make.trailing.equalTo(_forwardView);
            make.width.equalTo(@150);
            make.height.equalTo(@13);
        }];
        
        UIImageView *memberConsumptionIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        memberConsumptionIcon.image = [UIImage imageNamed:@"homePage_arrow_right"];
        [memberConsumptionButton addSubview:memberConsumptionIcon];
        [memberConsumptionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(memberConsumptionButton).with.offset(-20);
            make.centerY.equalTo(memberConsumptionButton);
            make.width.equalTo(@13);
            make.height.equalTo(@13);
        }];
        
        UILabel *memberConsumptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        memberConsumptionLabel.font = [UIFont systemFontOfSize:13];
        memberConsumptionLabel.textColor = [UIColor whiteColor];
        memberConsumptionLabel.text = @"查看当日会员消费记录";
        memberConsumptionLabel.textAlignment = NSTextAlignmentRight;
        [memberConsumptionButton addSubview:memberConsumptionLabel];
        [memberConsumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(memberConsumptionIcon.mas_leading);
            make.centerY.equalTo(memberConsumptionButton);
            make.height.equalTo(@13);
            make.width.equalTo(@150);
        }];

    }
    return _forwardView;
}

@end
