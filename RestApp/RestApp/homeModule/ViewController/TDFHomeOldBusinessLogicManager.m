//
//  TDFHomeOldBusinessLogicManager.m
//  RestApp
//
//  Created by happyo on 2017/4/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHomeOldBusinessLogicManager.h"
#import "EntryView.h"
#import "TDFCheckAlertView.h"
#import "MobClick.h"
#import "TDFWaveWithSideView.h"
#import "TDFHealthCheckHomePageModel.h"
#import "TDFHealthCheckSettingViewController.h"
#import "TDFHealthCheckViewController.h"
#import "TDFCustomerServiceButtonController.h"
#import "TDFPaymentModule.h"
#import "TDFMediator+PaymentModule.h"
#import "TDFPaymentTypeVo.h"
#import "TDFHomeOldBusinessLogicAPI.h"
#import "TDFSwitchTool.h"
#import "NSString+Estimate.h"
#import "ActionConstants.h"
#import "AccountCenter.h"
#import "ShopReviewAlertController.h"
#import "MessageBox.h"
#import "ShopReviewCenter.h"
#import "NetworkBox.h"
#import "TDFMediator+AccountRechargeModule.h"
#import "TDFLoginService.h"
#import "TDFAreaCodeModel.h"
#import "TDFInternationalRender.h"
#import "TDFAlertAPIHUDPresenter.h"
#import "TDFCommonRequestAPI.h"
#import "TDFSobotChat.h"

@interface TDFHomeOldBusinessLogicManager () <MessageBoxClient>

@property (nonatomic, weak, readwrite) UIView *view;

/**
 没有工作店家时候显示的
 */
@property (nonatomic, strong) EntryView *entryView;

/**
 体检弹框
 */
@property (nonatomic, strong) TDFCheckAlertView *attentionView;

/**
 体检球
 */
@property (nonatomic, strong) TDFWaveWithSideView *sideView;

/**
 体检的model
 */
@property (nonatomic, strong)TDFHealthCheckHomePageModel *checkModel;

/**
 在线客服
 */
@property (nonatomic, strong) TDFCustomerServiceButtonController *customerServiceController;

@property (nonatomic, strong) TDFAlertAPIHUDPresenter *hudPresenter;

@property (nonatomic, strong) TDFCommonRequestAPI *countryInitApi;

@property (nonatomic, strong) ShopStatusVo *shopInfo;

@property (nonatomic, strong) UIScrollView *scrollerView;


@end
@implementation TDFHomeOldBusinessLogicManager

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    
    if (self) {
        //
        self.view = view;
        [self configureView];
        [self initNotification];
    }
    
    return self;
}

- (void)configureView
{
    // 添加我工作的店家
    [self.view addSubview:self.entryView.view];
    [self.entryView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 体检视图
    @weakify(self);
    self.sideView.touchClick = ^{
        @strongify(self);
        [MobClick event:@"click_home_exam"];//埋点：体检图标
        if (self.checkModel.needUpdate) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新提示" message:self.checkModel.updateMessage.length > 0 ?self.checkModel.updateMessage:@"营业体检功能升级啦，请更新版本后使用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"体验一下", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:self.checkModel.updateUrl.length>0?self.checkModel.updateUrl:@"https://itunes.apple.com/cn/app/%E4%BA%8C%E7%BB%B4%E7%81%AB%E6%8E%8C%E6%9F%9C/id900873713?mt=8"];
                
                [[UIApplication sharedApplication] openURL:url];
            }];
            
            [alertController addAction:confirmAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"下次再说", nil) style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
            
            [viewController presentViewController:alertController animated:YES completion:nil];
            return ;
        }
        
        if (self.checkModel.isFirstTime) {
            TDFHealthCheckSettingViewController *settingVc = [[TDFHealthCheckSettingViewController alloc]init];
            settingVc.isFirstTime = self.checkModel.isFirstTime;
            settingVc.homePage = self.checkModel;
            [self.rootViewController pushViewController:settingVc animated:YES];
        }else{
            TDFHealthCheckViewController *healthCheck = [TDFHealthCheckViewController new];
            healthCheck.homePage = self.checkModel;
            [self.rootViewController pushViewController:healthCheck animated:YES];}
    };
    [self.view addSubview:self.sideView];
    [self.sideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@10);
        make.bottom.equalTo(self.view);
    }];
    
    // 体检弹框
    [self.view addSubview:self.attentionView];
    self.attentionView.closeClick = ^{
        @strongify(self);
        [MobClick event:@"click_home_exam_dialog_close"];//埋点：体检首页弹窗
        self.attentionView.hidden = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:kHealthCheckDate];
    };
    self.attentionView.hidden = YES;
    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-74);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    // 在线客服
    [self.customerServiceController addCustomerServiceButtonToView:self.view];

}

- (void)initNotification
{
    ///从左侧栏跳转到电子收款明细（）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToWeiXin:) name:@"switchToWeiXin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatShopToChainImage) name:@"Notification_ShopToChain" object:nil];

}

- (void)configureApis
{
    if([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"1"] ||
       [[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"2"]) {
        self.logicApi.type = @"2";
    }else {
        self.logicApi.type = @"1";
    }
    
    self.logicApi.jsessionId = [Platform Instance].jsessionId;
    
    @weakify(self);
    [self.logicApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
        @strongify(self);
        if([self.logicApi.type integerValue] == 1) {
            [Platform Instance].memberExtend = [MemberExtend convertToMemberExtend:response[@"data"][@"memberExtend"]];
            
            TDFSobotUserInfoModel *userInfoModel = [TDFSobotChat shareInstance].chatUserInfoModel;
            userInfoModel.avatarUrl = [Platform Instance].memberExtend.url;
            userInfoModel.sex = [Platform Instance].memberExtend.sex;
            userInfoModel.phone = [Platform Instance].memberExtend.phone;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserInfo_Change object:nil];
        }
        [TDFSwitchTool switchTool].isHangzhouShop = [response[@"data"][@"isHangzhouShop"] intValue];
        
        BOOL isHaveKouBei = [response[@"data"][@"koubeiDiscountStatus"] boolValue];
        
        self.hasOtherEntity = [response[@"data"][@"hasOtherEntity"] boolValue];
        
        self.findNoticeResultVo = response[@"data"][@"findNoticeResultVo"];
        
        ShopStatusVo *shopStatus = [ShopStatusVo yy_modelWithDictionary:response[@"data"][@"shopStatusVo"]];
        [TDFSwitchTool switchTool].shopInfo = shopStatus;
        
        self.checkModel = [TDFHealthCheckHomePageModel yy_modelWithDictionary:response[@"data"][@"healthCheckHomePage"]];
        
        if (self.checkModel) {
            self.sideView.hidden = NO;
            [self loadHealthCheckAnimation];
        }else {
            self.attentionView.hidden = YES;
            self.sideView.hidden = YES;
        }
        [self dealWithShopStatus:shopStatus andIsHave:isHaveKouBei];

        if (![[Platform Instance] isBranch]) {
            NSString *message = response[@"data"][@"moduleChargeMessage"];
            if ([NSString isNotBlank:message]) {
                [MessageBox show:message btnName:NSLocalizedString(@"查看详情", nil) client:self];
            }
        }
        
        [self.countryInitApi setApiSuccessHandler:^(__kindof TDFBaseAPI *api, id response) {
            TDFAreaCodeModel *model = [TDFAreaCodeModel yy_modelWithJSON:response[@"data"][@"currentCountry"]];
            [TDFInternationalRender sharedInstance].currentAreaCodeModel = model;
        }];
        [self.countryInitApi start];
        
        if (self.successApiBlock) {
            self.successApiBlock(self);
        }
    }];
    
    
}

- (void)dealWithShopStatus:(ShopStatusVo *)shopStatus andIsHave:(BOOL )koubei{
    if ([[Platform Instance] isBranch]) {
        return;
    }
    self.shopInfo = shopStatus;
    
    if ([[[Platform Instance] getkey:USER_IS_CHANGESHOP] isEqualToString:@"0"]||
        [NSString isBlank:[[Platform Instance] getkey:USER_IS_CHANGESHOP]] ){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        if (shopStatus.displayWxPay || (shopStatus.displayAlipay&&shopStatus.alipayStatus) || shopStatus.displayFund) {
            
            BOOL payment = shopStatus.authStatus == 0 && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
            if (payment) {
                [dict setObject:[NSNumber numberWithBool:payment] forKey:@"payment"];
            }
            
            BOOL authStatus = shopStatus.authStatus == 2 && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
            if (authStatus) {
                [dict setObject:[NSNumber numberWithBool:authStatus] forKey:@"authStatus"];
            }
            
            BOOL hasCoinTrade = shopStatus.hasCoinTrade && !shopStatus.authStatus  && [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
            if (hasCoinTrade) {
                [dict setObject:[NSNumber numberWithBool:payment] forKey:@"hasCoinTrade"];
            }
            
            if (koubei) {
                
                [dict setObject:@"1" forKey:@"AliPayReputation"];
            }
            
            
        }
        BOOL auditStatus = !shopStatus.auditStatus && (![[Platform Instance] lockAct:PAD_KABAW] &&![[Platform Instance] lockAct:PAD_CARD_SHOPINFO]);
        
        if (auditStatus) {
            [dict setObject:[NSNumber numberWithBool:auditStatus] forKey:@"auditStatus"];
        }
        
        if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"] && !shopStatus.hasPlate && ![[Platform Instance] lockAct:PHONE_BRAND_PLATE]) {
            
            dict[@"hasPlate"] = [NSNumber numberWithBool:shopStatus.hasPlate];
        }
        
        BOOL isBrand = [[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"];
        //  && ![[Platform Instance] lockAct:@"PHONE_BRAND_DISCOUNT_COUPON"]
        BOOL valid = (![[Platform Instance] lockAct:PHONE_BRAND_PRIVILEGE] && isBrand)
        || (![[Platform Instance] lockAct:PHONE_PRIVILEGE] && !isBrand && ![[Platform Instance] lockAct:PHONE_COUPON]);
        
        if (!shopStatus.isCustomerPrivilegeSet && valid) {
            
            dict[@"isCustomerPrivilegeSet"] = [NSNumber numberWithBool:shopStatus.isCustomerPrivilegeSet];
        }
        if ([TDFSwitchTool switchTool].isHangzhouShop && ![[Platform Instance] isChainOrBranch] ) {
            NSMutableDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"MainNotificationShowDictionary"];
            if (dictionary[[[Platform Instance] getkey:ENTITY_ID]]) {
                BOOL isTap = [dictionary[[[Platform Instance] getkey:ENTITY_ID]] boolValue];
                if (!isTap) {
                    dict[@"MainNotification"] = @"1";
                }
            }else {
                dict[@"MainNotification"] = @"1";
            }
        }
        
        if (dict.allKeys.count > 0 ) {
            [AccountCenter setUserChangeShopType:@"1"];
            ShopReviewAlertController *vc = [[ShopReviewAlertController alloc] init];
            vc.shopStatus = dict;
            vc.menues =  [TDFPaymentModule menuActions:self.shopInfo];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        }
        [ShopReviewCenter sharedInstance].reviewState = shopStatus.auditStatus;
    }
}

#pragma mark -- MessageBoxClient --

- (void)confirm
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_TDFMainAccountRechgeViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- Public Methods --

- (void)showHomeView
{
    self.entryView.view.hidden = YES;
}

- (void)showEntryView
{
    self.sideView.hidden = YES;
    self.attentionView.hidden = YES;
    self.entryView.view.hidden = NO;
    [self.entryView loadShopData];
}

#pragma mark -- Notifications --

- (void)switchToWeiXin:(NSNotification *)notification {
    [self loadPaymentModuleWithCodeArray:notification.object];
}

///电子收款明细
- (void)loadPaymentModuleWithCodeArray:(NSArray *)codeArray
{
    NSArray *menus = [TDFPaymentModule menuActions:self.shopInfo];
    if (menus.count >1) {
        [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:[[TDFMediator sharedInstance] TDFMediator_paymentTypeViewControllerWithShopInfo:nil menus:menus codeArray:codeArray ] animated:YES];
    }else{
        TDFPaymentTypeVo *action = menus.lastObject;
        if (action) {
            [TDF_ROOT_NAVIGATION_CONTROLLER pushViewController:[[TDFMediator sharedInstance] TDFMediator_orderPayListViewControllerWithShopInfo:nil action:action isAccount:YES withCodeArray:codeArray] animated:YES];
        }
    }
}

-(void)loadHealthCheckAnimation{
    NSString *healthCheckDate = [[NSUserDefaults standardUserDefaults] objectForKey:kHealthCheckDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    BOOL todayShouldShow = NO;
    
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (healthCheckDate) {
        if ([healthCheckDate isEqualToString:todayString]) {
            todayShouldShow = NO;
        } else {
            todayShouldShow = YES;
        }
    } else {
        todayShouldShow = YES;
    }
    
    if (self.checkModel.message && self.checkModel.message.length > 0 && todayShouldShow) {
        self.attentionView.hidden = NO;
        self.attentionView.titleStr = self.checkModel.message;
    } else {
        self.attentionView.hidden = YES;
    }
    
    if (self.checkModel.isFirstTime) {
        self.sideView.isShowAttentionText = YES;
        self.sideView.attentionText = NSLocalizedString(@"营业体检", nil);
        self.sideView.isNoScore = YES;
    } else {
        self.sideView.colorRules = self.checkModel.colorRules;
        self.sideView.score = self.checkModel.score;
        self.sideView.isNoScore = NO;
        [self.sideView updateHeight:self.checkModel.waterLineHeight];
        [self.sideView updateColorWithType:self.checkModel.ballColor];
        self.sideView.attentionText = NSLocalizedString(@"上次体检分数", nil);
    }
}

- (void) creatShopToChainImage
{
    [self.view addSubview:self.scrollerView];
}

- (UIScrollView *) scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] init];
        _scrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _scrollerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 800)];
        imgView.image = [UIImage imageNamed:@"main_link_page"];
        [_scrollerView addSubview:imgView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 20, 20, 20);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollerView addSubview:closeBtn];
        
        UIButton *ikonwBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [ikonwBtn setBackgroundImage:[UIImage imageNamed:@"I know"] forState:UIControlStateNormal];
        ikonwBtn.frame = CGRectMake((SCREEN_WIDTH - 150)/2, 880, 150, 50);
        [ikonwBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollerView addSubview:ikonwBtn];
    }
    return _scrollerView;
}

- (void) closeClick
{
    [self.scrollerView removeFromSuperview];
}

#pragma mark -- Getters && Setters --

- (EntryView *)entryView
{
    if (!_entryView) {
        _entryView = [[EntryView alloc] init];
        _entryView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    return _entryView;
}

- (TDFWaveWithSideView *)sideView
{
    if (!_sideView) {
        _sideView = [[TDFWaveWithSideView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 10, CGRectGetWidth(self.view.frame), 10) withRadius:99 / 2.0];
        _sideView.isShowAttentionText = YES;
        _sideView.attentionText = NSLocalizedString(@"营业体检", nil);
        _sideView.isNoScore = YES;
        _sideView.hidden = YES;
    }
    
    return _sideView;
}

- (TDFCheckAlertView *)attentionView
{
    if (!_attentionView) {
        _attentionView = [[TDFCheckAlertView alloc] init];
    }
    
    return _attentionView;
}

- (TDFCustomerServiceButtonController *)customerServiceController {
    if (!_customerServiceController) {
        _customerServiceController = [[TDFCustomerServiceButtonController alloc] init];
    }
    return _customerServiceController;
}

- (TDFHomeOldBusinessLogicAPI *)logicApi
{
    if (!_logicApi) {
        _logicApi = [[TDFHomeOldBusinessLogicAPI alloc] init];
//        _logicApi.presenter = self.hudPresenter;
        _logicApi.appCode = @"APP_CATERERS";
        _logicApi.platformType = @"2";
    }
    
    return _logicApi;
}

- (TDFCommonRequestAPI *)countryInitApi
{
    if (!_countryInitApi) {
        _countryInitApi = [[TDFCommonRequestAPI alloc] init];
        _countryInitApi.serviceName = @"init/login/v1/get_init_data";
    }
    
    return _countryInitApi;
}

- (TDFAlertAPIHUDPresenter *)hudPresenter
{
    if (!_hudPresenter) {
        _hudPresenter = [TDFAlertAPIHUDPresenter HUDWithView:self.view];
    }
    
    return _hudPresenter;
}

@end
