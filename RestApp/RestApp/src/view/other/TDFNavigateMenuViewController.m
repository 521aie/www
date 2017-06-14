//
//  TDFNavigateMenuViewController.m
//  RestApp
//
//  Created by 黄河 on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFNavigateMenuViewController.h"
#import "TDFMediator+SettingModule.h"
#import "TDFLocalDeliveryViewController.h"
#import "TDFMediator+SKBaseSetting.h"
#import "TDFBaseSettingModuleType.h"
#import "TDFFunctionKindVo.h"
#import "TDFNavigateView.h"
#import "TDFChainService.h"
#import "ActionConstants.h"
#import "RestConstants.h"
#import "MBProgressHUD.h"
#import "TDFFunctionVo.h"
#import "NetworkBox.h"
#import "AlertBox.h"
#import "Platform.h"
#import "YYModel.h"
#import "TDFHomePageDisplayAPI.h"
#import "TDFHomeGroupForwardItem.h"
#import "TDFLeftMenuSearchAPI.h"
#import "TDFSwitchTool.h"
//#import "TDFAlertAPIHUDPresenter.h"
#import "TDFRetryHUDPresenter.h"


@interface TDFNavigateMenuViewController ()<TDFNavigateViewDelegate>

@property (nonatomic, strong)UIImageView *backgroundImageView;

@property (nonatomic, strong)UINavigationController *rootViewController;

@property (nonatomic, strong)TDFNavigateView *navigateView;

@property (nonatomic, strong) TDFHomePageDisplayAPI *displayApi;

@property (nonatomic, strong) TDFLeftMenuSearchAPI *searchApi;

@property (nonatomic, strong) TDFRetryHUDPresenter *hudPresenter;

@property (nonatomic, assign) BOOL needRefresh;

@end

@implementation TDFNavigateMenuViewController

#pragma mark --init
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

- (TDFNavigateView *)navigateView
{
    if (!_navigateView) {
        _navigateView = [[TDFNavigateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/3, SCREEN_HEIGHT)];
        _navigateView.backgroundColor = [UIColor clearColor];
    }
    return _navigateView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view insertSubview:_backgroundImageView atIndex:0];
    }
    return _backgroundImageView;
}

#pragma mark --loadView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@"bg_00.png"];
    self.navigateView.delegate = self;
    [self.view addSubview:self.navigateView];
//    self.navigateView.dataArray = [Platform Instance].allLeftFunctionArray;
//    self.navigateView.allSearchDataArray = [Platform Instance].allFunctionArray;
    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateViewUpdate:) name:Notification_LeftDataSourceChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataSoucreChange:) name:Notification_AllDataSourceChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workShopStatusChange:) name:Notification_ShopWorkStatus_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange) name:Notification_Permission_Change object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange) name:UPDATE_HOMEPAGE_AND_LEFT_MENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange) name:UPDATE_LEFT_MENU object:nil];
}

- (void)fetchData
{
    @weakify(self);
    [self.displayApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        self.needRefresh = NO;

        NSArray *sectionList = response[@"data"];
        
        for (NSDictionary *sectionDict in sectionList) {
            
            NSString *sectionStyle = sectionDict[@"sectionStyle"];
            
            if ([sectionStyle isEqualToString:@"section_left_forward_group_style"]) {
                NSDictionary *sectionModel = sectionDict[@"sectionModel"];
                
                NSString *title = sectionModel[@"title"];
                self.navigateView.title = title;
                
                NSArray *cellList = sectionModel[@"cells"];
                self.navigateView.dataArray = [self transformCellListToDataList:cellList];
                //                self.navigateView.dataArray = [Platform Instance].allLeftFunctionArray;
                self.navigateView.allSearchDataArray =  [self.navigateView.dataArray copy];
                
                [self.navigateView reloadData];
            }
            
        }

    }];
    [self.displayApi start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.needRefresh) {
        [self fetchData];
    }
    self.navigateView.footerView.hidden = [[Platform Instance] isChainOrBranch];
}

- (void)viewWillAppearByHand
{
    if (self.needRefresh) {
        [self fetchData];
    }
    self.navigateView.footerView.hidden = [[Platform Instance] isChainOrBranch];
}

- (void)permissionChange
{
    self.needRefresh = YES;
}

- (void)workShopStatusChange:(NSNotification *)noti {

//    [self.displayApi retry];
    self.needRefresh = YES;
}

- (NSArray<TDFFunctionKindVo *> *)transformCellListToDataList:(NSArray *)cellList
{
    NSMutableArray<TDFFunctionKindVo *> *kindVoList = [NSMutableArray<TDFFunctionKindVo *> array];
    
    for (NSDictionary *cellDict in cellList) {
        NSString *cellStyle = cellDict[@"cellStyle"];
        
//        if ([cellStyle isEqualToString:@"cell_left_forward_style"]) {
            NSDictionary *cellModel = cellDict[@"cellModel"];
            
            NSString *title = cellModel[@"title"];
            NSArray<TDFHomeGroupForwardChildCellModel *> *forwardModelList = [NSArray<TDFHomeGroupForwardChildCellModel *> yy_modelArrayWithClass:[TDFHomeGroupForwardChildCellModel class] json:cellModel[@"forwardCells"]];
            
            TDFFunctionKindVo *kindVo = [[TDFFunctionKindVo alloc] init];
            kindVo.name = title;
            kindVo.functionVoList = [self functionVoListWithForwardModelList:forwardModelList];
            
            [kindVoList addObject:kindVo];
//        }
    }
    
    return kindVoList;
}

- (NSArray<TDFFunctionVo *> *)functionVoListWithForwardModelList:(NSArray<TDFHomeGroupForwardChildCellModel *> *)forwardModelList
{
    NSMutableArray<TDFFunctionVo *> *functionVoList = [NSMutableArray<TDFFunctionVo *> array];
    
    for (TDFHomeGroupForwardChildCellModel *forwardModel in forwardModelList) {
        TDFFunctionVo *functionVo = [[TDFFunctionVo alloc] init];
        
        functionVo.actionName = forwardModel.title;
        functionVo.actionCode = forwardModel.actionCode;
        functionVo.actionId = forwardModel.actionId;
        functionVo.isHide = forwardModel.isHide;
        functionVo.isLock = forwardModel.isLock;
        functionVo.isOpen = forwardModel.isOpen;
        TDFFunctionVoIconImageUrl *imageUrl = [[TDFFunctionVoIconImageUrl alloc] init];
        imageUrl.sUrl = forwardModel.iconUrl;
        functionVo.iconImageUrl = imageUrl;
        
        [functionVoList addObject:functionVo];
    }
    
    return functionVoList;
}


#pragma mark --notification

- (void)searchDataSoucreChange:(NSNotification *)notification
{
//    self.navigateView.allSearchDataArray = notification.object;
    self.needRefresh = YES;
    
}

- (void)navigateViewUpdate:(NSNotification *)notification
{
//    self.navigateView.dataArray = notification.object;
    self.navigateView.footerView.hidden = [[Platform Instance] isChainOrBranch];
    self.needRefresh = YES;
//    self.navigateView.titleLabel.text = [[Platform Instance] isChainOrBranch]?@"收银设置":NSLocalizedString(@"店家设置", nil);
}

//- (void)dealWithFunctionActionWith:(id)data
//{
//    NSMutableArray *functionKidnVoListArray = [NSMutableArray array];
//    NSArray *array = data[@"functionKindVoList"];
//    for (NSDictionary *dic in array) {
//        TDFFunctionKindVo *kindVo = [TDFFunctionKindVo yy_modelWithDictionary:dic];
//        [functionKidnVoListArray addObject:kindVo];
//    }
//    self.navigateView.dataArray = functionKidnVoListArray;
//}

#pragma mark --TDFNavigateViewDelegate

- (void)footerButtonClickWithIndex:(int)index
{
    switch (index) {
        case 20://功能大全
        {
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_tdfFunctionViewController];
            [self.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case 21://帮助
        {
            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_helpVideoViewController];
            [self.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)switchToViewController:(TDFFunctionVo *)functionVO
{
    if (functionVO.isLock) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil),functionVO.actionName]];
        return ;
    }
    [[TDFSwitchTool switchTool] pushViewControllerWithCode:functionVO.actionCode andObject:functionVO.lowestActionCode andObject:functionVO.childFunction withViewController:self];
}

- (void)navigateView:(TDFNavigateView *)navigateView didSearchWithKeyword:(NSString *)keyword
{
    @weakify(self);
    self.searchApi.keyword = keyword;
    [self.searchApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        NSArray *sectionList = response[@"data"];
        NSMutableArray<TDFFunctionKindVo *> *kindVoList = [NSMutableArray<TDFFunctionKindVo *> array];
        
        for (NSDictionary *cellModel in sectionList) {
            NSString *title = cellModel[@"title"];
            NSArray<TDFHomeGroupForwardChildCellModel *> *forwardModelList = [NSArray<TDFHomeGroupForwardChildCellModel *> yy_modelArrayWithClass:[TDFHomeGroupForwardChildCellModel class] json:cellModel[@"forwardCells"]];
            
            TDFFunctionKindVo *kindVo = [[TDFFunctionKindVo alloc] init];
            kindVo.name = title;
            kindVo.functionVoList = [self functionVoListWithForwardModelList:forwardModelList];
            
            [kindVoList addObject:kindVo];
        }
        
        self.navigateView.searchDataArray = kindVoList;
        [self.navigateView reloadData];

    }];
    [self.searchApi start];
}

- (void)pushViewControllerWithCode:(NSString *)actionCode
                         andObject:(NSArray *)codeArray
{
    NSDictionary *switchU = [Platform Instance].allFunctionSwitchDictionary[actionCode];
    if (switchU[@"mediatorMethod"]) {
        SEL action = NSSelectorFromString(switchU[@"mediatorMethod"]);
        if ([[TDFMediator sharedInstance] respondsToSelector:action]) {
            UIViewController *viewController = [[TDFMediator sharedInstance] performSelector:action withObject:codeArray];
            
            if (viewController) {
                [self.rootViewController pushViewController:viewController animated:YES];
            }
            
            return;
        }
    }
    if ([actionCode isEqualToString:TO_SUPPLY_MANAGE]/*供应链*/) {
        [self showSupolyManage];
    }else if ([actionCode isEqualToString:PAD_WEIXIN]/*电子收款明细,时间紧急，有时间看能把这个跳转也写成统一方式*/) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"switchToWeiXin" object:codeArray];
    }else if ([actionCode isEqualToString:@"PHONE_BRAND_CASH_SWITCH"] ||[actionCode isEqualToString:@"PHONE_CASH_SWITCH"])
    {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance]TDFMediator_nativeViewControllerForCashRegisterSwitchWithStoreType:[[Platform Instance] isChain]?TDFStoreTypeChain:TDFStoreTypeSingle] animated:YES];
    }else if ([actionCode isEqualToString:@"PHONE_BRAND_CASH_RRINT"] ||[actionCode isEqualToString:@"PAD_CASH_OUTPUT"])
    {
        [self.rootViewController pushViewController:[[TDFMediator sharedInstance]TDFMediator_nativeViewControllerForCashierPrinterWithStoreType:[[Platform Instance] isChain]?TDFStoreTypeChain:TDFStoreTypeSingle] animated:YES];
    }
}

///供应链
- (void)showSupolyManage {
    NSURL *url = [NSURL URLWithString:@"TDFSupplyChainApp://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else{
        
        BOOL showRestApp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
        
        if (!showRestApp) return;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请安装'二维火供应链'", nil)
                                                                                 message:NSLocalizedString(@"前往App Store下载二维火供应链", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = @"http://itunes.apple.com/us/app/id1124011735";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        
        [alertController addAction:confirmAction];
        
        UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    return;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (TDFHomePageDisplayAPI *)displayApi
{
    if (!_displayApi) {
        _displayApi = [[TDFHomePageDisplayAPI alloc] init];
        _displayApi.presenter = self.hudPresenter;
        _displayApi.pageCode = @"left";
    }
    
    return _displayApi;
}

- (TDFLeftMenuSearchAPI *)searchApi
{
    if (!_searchApi) {
        _searchApi = [[TDFLeftMenuSearchAPI alloc] init];
        _searchApi.presenter = self.hudPresenter;
    }
    
    return _searchApi;
}

- (TDFRetryHUDPresenter *)hudPresenter
{
    if (!_hudPresenter) {
        _hudPresenter = [TDFRetryHUDPresenter retryHUDWithContentView:self.navigateView hiddenView:self.navigateView.tableView];
    }
    
    return _hudPresenter;
}


@end
