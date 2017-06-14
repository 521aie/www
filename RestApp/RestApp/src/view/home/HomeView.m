 //
//  MainView.m
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import "ShopVO.h"
#import "AlertBox.h"
#import "MainUnit.h"
#import "ShopImg.h"
#import "UIHelper.h"
#import "Platform.h"
#import "HomeView.h"
#import "DateUtils.h"
#import "TDFOtherMenuViewController.h"
#import "FormatUtil.h"
#import "SystemEvent.h"
#import "KabawModule.h"
#import "ItemFactory.h"
#import "XHAnimalUtil.h"
#import "MarketModule.h"
#import "UIView+Sizes.h"
#import "ShopEditView.h"
#import "ShopCodeView.h"
#import "ActionConstants.h"
#import "BusinessSummaryVO.h"
#import "BusinessDetailView.h"
#import "SysNotificationView.h"
#import "FuctionActionData.h"
#import "ChainBusinessStatisticsDay.h"
#import "ShopReviewAlertController.h"
#import "ShopReviewCenter.h"
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>
#import "SystemUtil.h"
#import "TDFCustomerServiceButtonController.h"
#import "CompanyVo.h"
#import "YYModel.h"
#import "TDFMediator+ShopManagerModule.h"
#import "TDFMediator+KabawModule.h"
#import "TDFMediator+HomeModule.h"
#import "TDFSettingService.h"
#import "TDFChainService.h"
#import <TDFDataCenterKit/TDFDataCenter.h>
#import "TDFRightMenuController.h"
#import <Masonry.h>
@interface HomeView ()

@property (nonatomic, strong) TDFCustomerServiceButtonController *customerServiceController;
@property (nonatomic, strong) UINavigationController *rootController;
@end

@implementation HomeView

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(HomeModule *)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeModule = parent;
        service = [ServiceFactory Instance].businessService;
        userService = [ServiceFactory Instance].userService;
        setservice =[ServiceFactory Instance].settingService;
        envelopeService = [ServiceFactory Instance].envelopeService;
        chainservice = [ServiceFactory Instance].chainService;
//        self.systemNotePanel = [[SystemNotePanel alloc]initWithNibName:@"SystemNotePanel" bundle:nil homeView:self];
        self.menuGridPanel = [[MenuGridPanel alloc]initWithNibName:@"MenuGridPanel" bundle:nil homeView:self];
        self.bussinessPanel = [[BusinessDetailPanel alloc] initWithNibName:@"BusinessDetailPanel" bundle:nil homeView:self];
//        self.weixinPayPanel = [[WeixinPayPanel alloc]initWithNibName:@"WeixinPayPanel" bundle:nil homeView:self];
//        [SystemEvent registe:REFRESH_MAIN_VIEW target:self];
        [SystemEvent registe:REFRESH_SYS_NOTIFICAION target:self];
        self.IdsArr =[[NSMutableArray alloc]init];
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AccountCenter setUserChangeShopType:@"0"];
    [self initMainView];
    [self initScrollView];
    [self initNotifaction];
    [self initDataView];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:IsfirstLoadbusiness];
    [self addNotification];
    [self.customerServiceController addCustomerServiceButtonToView:self.view];
    
}

- (void)initMainView
{    self.scrollContainer.delegate = self;
//    [self.sysNoteContainer addSubview:self.systemNotePanel.view];
//    [self.systemNotePanel.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sysNoteContainer).with.offset(9);
//        make.leading.equalTo(self.sysNoteContainer);
//        make.trailing.equalTo(self.sysNoteContainer);
//        make.bottom.equalTo(self.sysNoteContainer);
//    }];

//    [self.weixinPayContainer addSubview:self.weixinPayPanel.view];
    [self.businessContainer addSubview:self.bussinessPanel.view];
    [self.shopInfoContainer addSubview:self.shopInfoPanel.view];
    [self.menuGridContainer addSubview:self.menuGridPanel.view];
    self.warningViewBox.hidden = YES;
    self.rightImg.hidden=NO;
    self.rightLbl.hidden=NO;
    self.setUpBtn.enabled=YES;
    
//    UIButton *barcodeBtn = [[UIButton alloc]init];
//    [barcodeBtn addTarget:self action:@selector(barcodeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//    [barcodeBtn setImage:[UIImage imageNamed:@"saoma.png"] forState:UIControlStateNormal];
//    [_naviView addSubview:barcodeBtn];
//    
//    [barcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.mas_equalTo(_tapMeBtn.mas_centerY);
//        make.height.mas_equalTo(_tapMeBtn.mas_height);
//        make.width.mas_equalTo(_tapMeBtn.mas_width);
//        //        make.left.mas_equalTo(_tapMeBtn.mas_left).with.offset(-_tapMeBtn.width-20);
//        make.right.mas_equalTo(_tapMeBtn.mas_left).offset(-15);
//        
//        //
//    }];
}

//#pragma mark - 点击扫描二维码按钮
//- (void)barcodeBtnDidClick {
//    
//    TDFBarcodeViewController *bvc = [[TDFBarcodeViewController alloc]init];
//    
//    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:bvc animated:YES];
//}

- (void)initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange:) name:Notification_Permission_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionChange:) name:@"kTDFMainViewReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNote) name:@"systemNoteRefresh" object:nil];
}

- (void)refreshNote
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

- (void)initDataView
{
    self.lblDay.text = [NSString stringWithFormat:NSLocalizedString(@"今天是%@", nil), [DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeChineseWithWeek]];
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString *userName = [[Platform Instance] getkey:REAL_NAME];
    
    if ([NSString isNotBlank:shopName]) {
        shopName = [FormatUtil formatStringLength2:shopName length:6];
        self.lblShop.text = shopName;
        [self reSizeShopLbl];
    }
    if ([NSString isNotBlank:userName]) {
        self.lblUser.text = userName;
    } else {
        self.lblDay.text = @"-";
    }
}


#pragma mark Notification

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reviewStatusDidChanged)
                                                 name:kShopReviewStateChangedNotification
                                               object:nil];
}

- (void)reviewStatusDidChanged {
    
    if (self.shopInfo) {
        
        [self reload: self.shopInfo];
    }
}
//营业汇总
- (void)loadBusiness
{
    BOOL isfirstLoadbusiness = [[[NSUserDefaults standardUserDefaults] objectForKey:IsfirstLoadbusiness] boolValue];
    if(isfirstLoadbusiness) {
       self.menuGridPanel.view.hidden = YES;
    }
    
    [self updateViewSize];
    
    if ([self  isChainOrBranch]) {
        self.setUpBtn.enabled=NO;
        self.rightImg.hidden=YES;
        self.rightLbl.hidden=YES;
    }else{
        self.setUpBtn.enabled=YES;
        self.rightImg.hidden=NO;
        self.rightLbl.hidden=NO;
    }
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString *userName = [[Platform Instance] getkey:REAL_NAME];
    if ([NSString isNotBlank:shopName]) {
        shopName = [FormatUtil formatStringLength2:shopName length:8];
        self.lblShop.text = shopName;
        [self reSizeShopLbl];
    } else {
        self.lblShop.text = @"-";
        [self reSizeShopLbl];
    }
    if ([NSString isNotBlank:userName]) {
        self.lblUser.text = userName;
    }
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger week=[comps weekday];
    
    NSString *currDay=[NSString stringWithFormat:NSLocalizedString(@"今天是%ld年%ld月%ld日 %@", nil), (long)year, (long)month, (long)day, [DateUtils getWeeKName:week]];
    self.lblDay.text=currDay;
    
    if ([[[Platform Instance] getkey:USER_IS_CHANGESHOP] isEqualToString:@"1"]) {
        self.warningViewBox.hidden = YES;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    if([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"1"] ||
       [[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"2"]) {
        param[@"type"] = @"2";
    }else {
        param[@"type"] = @"1";
    }
    
    param[@"j_session_id"] = [Platform Instance].jsessionId;
    
    if(isfirstLoadbusiness) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    @weakify(self);
    [[[TDFChainService alloc] init] compositeHomepage: param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsfirstLoadbusiness];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self refreshCompleted];
        
        hud.hidden = YES;
        if([param[@"type"] integerValue] == 1) {
            [Platform Instance].memberExtend = [MemberExtend convertToMemberExtend:data[@"data"][@"memberExtend"]];
        }
        
        if([self isBranch]) {
            [self.systemNotePanel initWithData:nil count:0];
        }else {
            NSDictionary *findNoticeResultVo = data[@"data"][@"findNoticeResultVo"];
            [self dealWithFindNotice:findNoticeResultVo];
        }
        
        bool hasOtherEntity = [data[@"data"][@"hasOtherEntity"] boolValue];
        [self dealWithShopList:hasOtherEntity];
        
        NSMutableArray *actionList = [JsonHelper transList:data[@"data"][@"actionList"] objName:@"Action"];
        [self dealWithPowerList:actionList];
        
        ShopStatusVo *shopStatus = [ShopStatusVo yy_modelWithDictionary:data[@"data"][@"shopStatusVo"]];
        [self dealWithShopStatus:shopStatus];
        
        if([self isChainOrBranch]) {
            [self dealWithChainBusinessStatistics:data[@"data"][@"yesterdayVo"]];
        }else {
            [self dealWithFuctionAction:data[@"data"]];
            
            NSString *shopLoanStatus = [NSString stringWithFormat:@"%i",[data[@"data"][@"shopLoanStatus"] boolValue]];
            [[Platform Instance] saveKeyWithVal:@"loanStatus" withVal:shopLoanStatus];
            
            BOOL isRefresh = [[[Platform Instance] getkey:IS_REFRESH] isEqualToString:@"1"];
            if(isRefresh) {
                [self dealWithChainBusinessStatistics:data[@"data"][@"yesterdayVo"]];
            }else {
                NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
                if ([NSString isNotBlank:shopCode]) {
                    [self dealWithShopBusinessStatistics:data[@"data"][@"yesterdayVo"]];
                }
            }
        }
        self.menuGridPanel.view.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserInfo_Change object:nil];
        [self reload:shopStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserInfo_Change object:nil];
        [self updateViewSize];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsfirstLoadbusiness];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self refreshCompleted];
        [NetworkBox show:error.localizedDescription client:self];
    }];
    
}

- (void)dealWithChainBusinessStatistics:(NSDictionary *)yesterdayDic {
    
    ChainBusinessStatisticsDay *day =[ChainBusinessStatisticsDay convertShopDetail:yesterdayDic];
    
    //营业汇总模块是否显示
    if(day) {
        [self.hideline setHidden:YES];
        [self.businessContainer setHidden:NO];
    }else {
        [self.hideline setHidden:NO];
        [self.businessContainer setHidden:YES];
    }
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //昨天时间
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *yestodayStr = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:yesterday] intValue]];
    NSString *str = [DateUtils formatTimeWithDate:yesterday type:TDFFormatTimeTypeChineseWithoutYear];
    NSString *monthStr = [str substringWithRange:NSMakeRange(0,2)];
    NSString *dayStr = [str substringWithRange:NSMakeRange(3,2)];
    NSString *dateStr;
    dateStr = [NSString stringWithFormat:NSLocalizedString(@"昨日收益(%d月%d日)", nil),[monthStr intValue],[dayStr intValue]];
    [self.bussinessPanel loadChainData:dateStr summary:day date:yestodayStr];
    [UIHelper refreshTop:self.scrollContainer];
}

- (void)dealWithShopBusinessStatistics:(NSDictionary *)yestordayDic {
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //昨天时间
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *yestodayStr = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:yesterday] intValue]];
    NSString *str = [DateUtils formatTimeWithDate:yesterday type:TDFFormatTimeTypeChineseWithoutYear];
    NSString *monthStr = [str substringWithRange:NSMakeRange(0,2)];
    NSString *dayStr = [str substringWithRange:NSMakeRange(3,2)];

    NSString *dateStr = [NSString stringWithFormat:NSLocalizedString(@"昨日收益(%d月%d日)", nil),[monthStr intValue],[dayStr intValue]];
    
    ChainBusinessStatisticsDay *day =[ChainBusinessStatisticsDay convertShopDetail:yestordayDic];
    BusinessSummaryVO *yestoday;
    if(day) {
        yestoday = [[BusinessSummaryVO alloc] init];
        yestoday.sourceFee = day.sourceAmount;
        yestoday.discountAmount = day.discountAmount;
        yestoday.profitAmount = day.profitLossAmount;
        yestoday.billingNum = (int)day.orderCount;
        yestoday.totalNum = (int)day.mealsCount;
        yestoday.aveConsume = day.actualAmountAvg;
        yestoday.totalAmount = day.actualAmount;
    }
    
    //营业汇总模块是否显示
    if(yestoday&&![[Platform Instance] lockAct:PAD_SELF_TEST]) {
        [self.hideline setHidden:YES];
        [self.businessContainer setHidden:NO];
    }else {
        [self.hideline setHidden:NO];
        [self.businessContainer setHidden:YES];
    }
    
    [self.bussinessPanel loadData:dateStr summary:yestoday date:yestodayStr];
    
    [UIHelper refreshTop:self.scrollContainer];
}


- (void)dealWithShopList:(BOOL)hasOtherEntity {
    if (hasOtherEntity) {
        self.btnSelectShop.hidden = NO;
        self.icoSelectShop.hidden = NO;
    } else {
        self.btnSelectShop.hidden = YES;
        self.icoSelectShop.hidden = YES;
    }
}

- (void)dealWithPowerList:(NSMutableArray *)actionList {
    NSMutableDictionary *actionMap = [NSMutableDictionary dictionary];
    for (Action *action in actionList) {
        [actionMap setObject:action forKey:action.code];
    }
    [[Platform Instance] setActDic:actionMap];
}

- (void)dealWithFuctionAction:(NSDictionary *)map {
    [TDFDataCenter sharedInstance].allCodeItemArray =[[NSMutableArray alloc]init];
    for (NSDictionary *dic in map[@"sampleActionList"]) {
        FuctionActionData *data =[[FuctionActionData alloc]init];
        data.code =[NSString stringWithFormat:@"%@",dic[@"code"]];
        data.id =[NSString stringWithFormat:@"%@",dic[@"id"]];
        data.name =[NSString stringWithFormat:@"%@",dic[@"name"]];
        data.status =[NSString stringWithFormat:@"%@",dic[@"status"]].intValue;
        NSString *str =[NSString stringWithFormat:@"%@",dic[@"isUserHide"]];
        NSString *strhide =[NSString stringWithFormat:@"%@",dic[@"isHide"]];
        if (![strhide isEqualToString:@"<null>"]) {
            data.isHide =[NSString stringWithFormat:@"%@",dic[@"isHide"]].intValue;
        } else {
            data.isHide =3;
        }
        if (![str isEqualToString:@"<null>"]) {
            data.isUserHide =[NSString stringWithFormat:@"%@",dic[@"isUserHide"]].intValue;
        } else {
            data.isUserHide =3;
        }
        [[TDFDataCenter sharedInstance].allCodeItemArray addObject:data];
    }
    
    BOOL useBillHide = [map[@"useBillHide"] boolValue];
    
    if(![self isBranch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ALL_CODE_ACTION object:@{@"actionArr":[TDFDataCenter sharedInstance].allCodeItemArray,@"useBillHide":@(useBillHide)}];
    }
}

- (void)dealWithShopStatus:(ShopStatusVo *)shopStatus {
    if ([self isBranch]) {
        return;
    }
    self.shopInfo = shopStatus;
    
    if ([[[Platform Instance] getkey:USER_IS_CHANGESHOP] isEqualToString:@"0"]||
        [NSString isBlank:[[Platform Instance] getkey:USER_IS_CHANGESHOP]] ){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        if (shopStatus.displayWxPay || (shopStatus.displayAlipay&&shopStatus.alipayStatus) || shopStatus.displayFund) {
            
            BOOL payment = !shopStatus.hasCommit && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
            BOOL hasCoinTrade = shopStatus.hasCoinTrade && !shopStatus.hasCommit  && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
            if (payment) {
                [dict setObject:[NSNumber numberWithBool:payment] forKey:@"payment"];
            }
            if (hasCoinTrade) {
                [dict setObject:[NSNumber numberWithBool:payment] forKey:@"hasCoinTrade"];
            }
            
        }
        BOOL auditStatus = !shopStatus.auditStatus && (![[Platform Instance] lockAct:PAD_KABAW] &&![[Platform Instance] lockAct:PAD_CARD_SHOPINFO]);
        
        if (auditStatus) {
            [dict setObject:[NSNumber numberWithBool:auditStatus] forKey:@"auditStatus"];
        }

        
        if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"] && !shopStatus.hasPlate) {
        
            dict[@"hasPlate"] = [NSNumber numberWithBool:shopStatus.hasPlate];
        }
        
        BOOL isBrand = [[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"];
        BOOL valid = (![[Platform Instance] lockAct:PHONE_BRAND_PRIVILEGE] && isBrand)
        || (![[Platform Instance] lockAct:PHONE_PRIVILEGE] && !isBrand);
        if (!shopStatus.isCustomerPrivilegeSet && valid) {
        
            dict[@"isCustomerPrivilegeSet"] = [NSNumber numberWithBool:shopStatus.isCustomerPrivilegeSet];
        }
        
        if (dict.allKeys.count > 0 ) {
            [AccountCenter setUserChangeShopType:@"1"];
            ShopReviewAlertController *vc = [[ShopReviewAlertController alloc] init];
            vc.shopStatus = dict;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        }
        [ShopReviewCenter sharedInstance].reviewState = shopStatus.auditStatus;
    }
}

- (void)dealWithFindNotice:(NSDictionary *)findNoticeResultVo {
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
}

//是否是连锁或者分公司
- (BOOL)isChainOrBranch
{
    if ([self isChain] || [self isBranch]) {
        return YES;
    }
    return NO;
}

- (BOOL)isChain{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRAND]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isBranch{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRANCH]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isRefresh {
    BOOL isRefresh  = [[[Platform Instance] getkey:IS_REFRESH] boolValue];
    return isRefresh;
}

- (BOOL)refresh
{
    if (![super refresh]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsfirstLoadbusiness];
    [self loadBusiness];
    return YES;
}

- (IBAction)tiShiBtnClick:(id)sender
{
    [AccountCenter setUserChangeShopType:@"1"];
    if([[Platform Instance] lockAct:PAD_WEIXIN_SUM] && [[Platform Instance] lockAct:PAD_WEIXIN_DETAL]){
        [AlertBox show:NSLocalizedString(@"抱歉，您没有电子收款明细模块的权限。请提醒您的老板尽快绑定银行卡哦。", nil) client:self];
        
    }
    else{
        self.warningViewBox.hidden = YES;
        [self forwardWeixinPay];
    }
    
}

- (void)understand
{
    self.warningViewBox.hidden = YES;
}

- (void)renderSysNotification:(SysNotification *)notification
{
    if ([ObjectUtil isNotNull:notification]) {
        self.sysNoteContainer.hidden = NO;
    } else {
        self.sysNoteContainer.hidden = YES;
    }
}

- (void)refreshSysNotification:(NSUInteger)sysNotificationCount
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = (UINavigationController *)window.rootViewController;
    UIViewController *firstViewController = nav.viewControllers.firstObject;
    if([firstViewController isKindOfClass:[MainUnit class]]) {
        MainUnit *mainUnit = (MainUnit *)firstViewController;
        [mainUnit.otherMenu refreshSysStatus:sysNotificationCount];
    }
    
    self.icoSysNotification.hidden = (sysNotificationCount==0);
}

- (void)permissionChange:(NSNotification *) notification
{
    [self reload:nil];
}

//加载后台主界面
- (void)reload:(ShopStatusVo *)shopInfoVO
{
    [self.menuGridPanel initDataView:shopInfoVO andalliteam:[TDFDataCenter sharedInstance].allCodeItemArray];
}

- (IBAction)btnShopName:(id)sender
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    UIViewController *viewController = [mediator TDFMediator_shopSelectViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)btnMoreClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_OTHER_SHOW_NOTIFICATION object:nil];
}

- (void)showChainBusinessDetailView {
    NSDate *date =[NSDate date];
    NSDate *demoDate = [DateModel dateByModifiyingDate:date withModifier:@"- 1 day"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSInteger year =[NSString stringWithFormat:@"%@",[formatter stringFromDate:demoDate]].integerValue;
    [formatter setDateFormat:@"MM"];
    NSInteger month =[NSString stringWithFormat:@"%@",[formatter stringFromDate:demoDate]].integerValue;
    [formatter setDateFormat:@"dd"];
    NSInteger day =[NSString stringWithFormat:@"%@",[formatter stringFromDate:demoDate]].integerValue;
    NSLog(@"%ld %ld %ld",year,month,day);
    UIViewController *chainBusinessDetailView = [[TDFMediator sharedInstance]TDFMediator_chainBusinessDetailViewControllerWithYear:year month:month day:day idArrays:self.IdsArr];
    [self.rootController pushViewController:chainBusinessDetailView animated:YES];
}

- (void)showShopBusinessDetailView {
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    
    UIViewController *shopEditView = [[TDFMediator sharedInstance]TDFMediator_businessDetailViewControllerWithYear:year month:month day:day];
    [self.rootController pushViewController:shopEditView animated:YES];
}

//跳转营业详情
- (void)showBusinessDetailEvent
{
    if ([self isChainOrBranch]) {
        if ([[[Platform Instance] getkey:USER_IS_SUPER]isEqualToString:@"0"]){
            if([self isChain] && [[Platform Instance] lockAct:PHONE_BRAND_DATA]) {
                [self.hideline setHidden:NO];
                [self.businessContainer setHidden:YES];
            }else if([self isBranch] && [[Platform Instance] lockAct:PHONE_BRANCH_DATA]) {
                [self.hideline setHidden:NO];
                [self.businessContainer setHidden:YES];
            }else{
                [self showChainBusinessDetailView];
            }
        }
        else {
            [self showChainBusinessDetailView];
        }
    }
    else
    {
        if ([[[Platform Instance] getkey:USER_IS_SUPER]isEqualToString:@"0"]){
            if ([[Platform Instance] lockAct:PAD_SELF_TEST]) {
                [self.hideline setHidden:NO];
                [self.businessContainer setHidden:YES];
            }else{
                [self showShopBusinessDetailView];
            }
        }else {
            [self showShopBusinessDetailView];
        }
    }
}

- (void)onEvent:(NSString *)eventType
{
//    if ([REFRESH_MAIN_VIEW isEqualToString:eventType]) {
//        [self loadBusiness];
//    }
}

- (void)onEvent:(NSString *)eventType object:(id)object
{
    if ([REFRESH_SYS_NOTIFICAION isEqualToString:eventType]) {
        [self loadBusiness];
    }
}

- (void)pinHeaderView
{
    [super pinHeaderView];
    [refreshDataHeader startAnimating];
}

- (void)unpinHeaderView
{
    [super unpinHeaderView];
    [refreshDataHeader stopAnimating];
}

- (void)forwardSysNotification
{
    if ([[Platform Instance] isNetworkOk]) {
        SysNotificationView *syst = [[SysNotificationView alloc]init];
        [syst initDataView];
        [homeModule.rootController pushViewController:syst animated:YES];
        //        [SysNotificationView showRight];
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}

- (IBAction)btnNavigateClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UI_NAVIGATE_SHOW_NOTIFICATION object:nil] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:LODATA object:nil];
    
    
}

- (void)forwardMenuDegree
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance] lockAct:PAD_RESERVER_MENU]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), NSLocalizedString(@"火小二菜单", nil)]];
        } else {
            [homeModule forwardToModule:PAD_RESERVER_MENU];
        }
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}

//我的微店.
- (void)forwardShopDegree
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance] lockAct:PAD_CARD_SHOPINFO]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), NSLocalizedString(@"店家资料", nil)]];
        } else {
            //            [homeModule forwardToModule:PAD_CARD_SHOPINFO];
            //            [MainModule sharedInstance].kabawModule.shopEditView.backIndex = INDEX_MAIN_VIEW;
//            UIViewController *shopEditView = [[TDFMediator sharedInstance]TDFMediator_shopEditViewControllerHideOldNavigationBar:YES];
//            [self.rootController pushViewController:shopEditView animated:YES];
        }
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}

//微店营销.
- (void)forwardShopCode
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance] lockAct:PAD_SHOP_QRCODE]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), NSLocalizedString(@"店铺二维码", nil)]];
        } else {
            //            UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_shopCodeViewControllerHideOldNavigationBar:NO];
            //            [self.rootController pushViewController:viewController animated:YES];
            [homeModule forwardToModule:PAD_SHOP_QRCODE];
            //            [[MainModule sharedInstance].kabawModule.shopCodeView loadDataView];
            //            [MainModule sharedInstance].kabawModule.shopCodeView.backIndex = INDEX_MAIN_VIEW;
        }
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}

//微信支付页
- (void)forwardWeixinPay
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance]lockAct:PAD_WEIXIN_DETAL]&&[[Platform Instance]lockAct:PAD_WEIXIN_SUM]&&[[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
            [AlertBox show:NSLocalizedString(@"抱歉，您没有微信支付模块的权限。请提醒您的老板尽快绑定银行卡哦。", nil) client:self];
            return;
        } else {
            self.warningViewBox.hidden = YES;
            [homeModule forwardToModule:PAD_PAYMENT];
        }
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}

//会员
- (void)forwardMemberModule
{
    if ([[Platform Instance] isNetworkOk]) {
        if ([[Platform Instance] lockAct:PAD_MEMBER]) {
            [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"您没有[%@]的权限", nil), NSLocalizedString(@"会员", nil)]];
        } else {
            [homeModule forwardToModule:PAD_MEMBER];
        }
    } else {
        [NetworkBox show:NSLocalizedString(@"网络不给力，请稍后再试!", nil) client:self];
    }
}
- (void)reSizeShopLbl
{
    [self.lblShop sizeToFit];
    CGRect frame = self.lblShop.frame;
    frame.origin.x = (320-frame.size.width)/2-8;
    self.lblShop.frame = frame;
    CGRect icoFrame = self.icoSelectShop.frame;
    icoFrame.origin.y = frame.origin.y+2;
    icoFrame.origin.x = frame.origin.x + frame.size.width+4;
    self.icoSelectShop.frame = icoFrame;
}

- (void)reTry
{
    [self loadBusiness];
}
- (void)updateViewSize
{
    NSArray *viewList = self.mainViewContainer.subviews;
    CGFloat height = 0;
    for (UIView *view in viewList) {
        if (view.hidden==NO) {
//            [view setTop:height];
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mainViewContainer).with.offset(height);
            }];
            height += view.height;
        }
    }
//    [self.mainViewContainer setHeight:height+88];
    CGSize contentSize = self.scrollContainer.contentSize;
    contentSize.height = height+88;
    self.scrollContainer.contentSize = contentSize;
}

- (TDFCustomerServiceButtonController *)customerServiceController {
    if (!_customerServiceController) {
        _customerServiceController = [[TDFCustomerServiceButtonController alloc] init];
    }
    return _customerServiceController;
}
@end
