//
//  AppDelegate.m
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>
#import "Platform.h"
#import "SystemUtil.h"
#import "SystemEvent.h"
#import "ItemFactory.h"
#import "AppDelegate.h"
#import "RestConstants.h"
#import "OperationMessage.h"
#import "UIImage+Resize.h"
#import "AliPayResultUtil.h"
#import "SysNotificationVO.h"
#import <AlipaySDK/AlipaySDK.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "BackgroundHelper.h"
#import <TDFAppInitConfigServiceKit/TDFAppInitConfigHelper.h>
#import <TDFNetworkActivityLogger/TDFNetworkHttpieLogger.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "JPUSHService.h"
#import <TDFNetworking/TDFHTTPClient.h>
#import "TDFMediator+HomeModule.h"
//#import <TDFHTTPDNSKit/TDFHTTPDNS.h>
#import "TDFMediator+UserAuth.h"
#import "TDFMediator+MainModule.h"
#import "AboutView.h"
#import "BigImageBox.h"
#import "CalendarBox.h"
#import "NetworkBox.h"
#import "SystemEvent.h"
#import "OptionSelectBox.h"
#import "ImageScrollBox.h"
#import "BackgroundView.h"
#import "OptionPickerBox.h"
#import "RatioPickerBox.h"
#import "MailInputBox.h"
#import "NumberInputBox.h"
#import "MemoInputBox.h"
#import "MailInputBox.h"
#import "FeedBackView.h"
#import "PairPickerBox.h"
#import "ImageBox.h"
#import "UserLoginData.h"
#import "WeixinLoginData.h"
#import "GlobeConstants.h"
#import "AlertBox.h"
#import "NetworkBox.h"
#import "TDFNetworkEnvironmentController.h"
#import <IQKeyboardManager.h>
#import <HBHybridKit/HBHybridKit.h>
#import "TDFLogger.h"
#import "AMapServices.h"
#import "TDFLoginService.h"
#import "TDFDataCenter.h"
#import "TDFInternationalRender.h"
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>
#import "RestAppConstants.h"
#import "TDFSobotChat.h"
#import "UIViewController+TopViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate()<CLLocationManagerDelegate, UINavigationControllerDelegate,UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    CLLocationManager *_locationmanager;
}

@end

@implementation AppDelegate

- (AppController *)appController {
    if (!_appController) {
        _appController = [AppController shareInstance];
    }
    
    return _appController;
}

- (void)configNavigationBar {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.translucent = NO;
    navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.00];
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.titleTextAttributes = @{
                                          NSForegroundColorAttributeName: [UIColor whiteColor]
                                          };
}

- (void)setupWindowRootViewControllerWithLoginUnit {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    @weakify(self);
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"version"] isEqualToString:version]) {
        //首次的启动页面
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_entryUnitViewControllerWithEditAction:^{
            @strongify(self);
            [self setupWindowRootViewControllerWithLoginUnit];
        }];
        
        UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [navigationViewController setNavigationBarHidden:YES];
        
        self.window.rootViewController = navigationViewController;
    }else {
        UserLoginData *userLoginData = [UserLoginData getLoginData];
        WeixinLoginData *weixinLoginData = [WeixinLoginData getLoginData];
        
        UIViewController *rootViewController;
        
        if (userLoginData!=nil) {
            rootViewController = [[TDFMediator sharedInstance] TDFMediator_AutoLoginViewControllerWithEditAction:^(BOOL isHomeView) {
                @strongify(self);
                [self setupRootViewControllerWithMainUnitWithIsHomeView:isHomeView];
            }];
            
        } else if (weixinLoginData!=nil) {
            rootViewController = [[TDFMediator sharedInstance] TDFMediator_AutoLoginViewControllerWithEditAction:^(BOOL isHomeView) {
                @strongify(self);
                [self setupRootViewControllerWithMainUnitWithIsHomeView:isHomeView];
            }];
            
        } else {
            rootViewController = [[TDFMediator sharedInstance] TDFMediator_IndexViewControllerWithEditAction:^(BOOL isHomeView) {
                @strongify(self);
                [self setupRootViewControllerWithMainUnitWithIsHomeView:isHomeView];
            }];
            
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        
        self.window.rootViewController = navigationController;
        
        [self initToolControls];
    }
}

- (void)setupRootViewControllerWithMainUnitWithIsHomeView:(BOOL)isHomeview
{
    [[Platform Instance] setIsAccountLogined:YES];
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_mainUnitViewController:@{@"isHomeView":@(isHomeview)} editAction:^{
        @strongify(self);
        [self setupWindowRootViewControllerWithLoginUnit];
    }];
    
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [navigationViewController setNavigationBarHidden:YES];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    keyWindow.rootViewController = navigationViewController;
    
    [self initToolControls];
}


- (void)configUMengSocial {
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMANALYTICS_KEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_ID appSecret:WX_APP_SSECRET redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    /* 设置新浪的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    //
    //    /* 支付宝的appKey */
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

- (void)initToolControls{
    [SystemEvent registe:PROCESS_OPERATION_MESSAGE target:[AppController shareInstance]];
    [AlertBox initAlertBox];
    [MessageBox initMessageBox];
    [CalendarBox initCalendarBox:self.window.rootViewController];
    [MemoInputBox initMemoInputBox:self.window.rootViewController];
    [NumberInputBox initNumberInputBox:self.window.rootViewController];
    [PairPickerBox initOptionPickerBox:self.window.rootViewController];
    [RatioPickerBox initOptionPickerBox:self.window.rootViewController];
    [OptionSelectBox initOptionSelectBox:self.window.rootViewController];
    [MailInputBox initMailInputBox:self.window.rootViewController];
    [BigImageBox initImageBox:self.window.rootViewController];
    [ImageScrollBox initImageScrollBox:self.window.rootViewController];
    [ImageBox initImageBox:self.window.rootViewController];
    [NetworkBox initNetworkBox];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options
{
    
#if DEBUG
    TDFNetworkEnvironmentController *environmentController = [TDFNetworkEnvironmentController sharedInstance];
    [environmentController setup];
#endif
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:isNeedScanCodeViewController];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CanGoToScanCodeViewController];
    [self initAllFunctionSwitchDictionary];
    //#if PRERELEASE || RELEASE
    //    [NSURLProtocol registerClass:[TDFHTTPProtocol class]];
    //#endif
    [Fabric with:@[[Crashlytics class]]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self initPlatform];
    [self initSocialData];
    [self initAppAnalytics];
    [self initItemFactory];
    
    //[self setupMeiQiaStaff];
    [self registerPush:application];
    
    [self initSobotChatModule];
    
    [self initPushService:options];
    
    [self initTDFHttpClient];
    
    //配置用户Key
    [AMapServices sharedServices].apiKey = MAP_KEY;
    //    [MAMapServices sharedServices].apiKey = MAP_KEY;
    //    [AMapSearchServices sharedServices].apiKey = MAP_KEY;
    //    [AMapLocationServices sharedServices].apiKey = MAP_KEY;
    _locationmanager = [[CLLocationManager alloc] init];
    [_locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    _locationmanager.delegate = self;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self setupWindowRootViewControllerWithLoginUnit];
    
    [self configNavigationBar];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    TDFAppInitConfigHelper *initConfigHelper = [[TDFAppInitConfigHelper alloc] init];
    
    [initConfigHelper initAppConfigWithRootController:self.window.rootViewController appCode:@"APP_CATERERS" callback:^(NSDictionary *appConfigInfo, NSError *error) {
        
        BOOL showKouBeiIcon = [appConfigInfo[@"showRestappIcon"] boolValue];
        BOOL showKouBeiIconInUserDefaults = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kTDFShowRestApp"] boolValue];
        
        if (showKouBeiIcon != showKouBeiIconInUserDefaults) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@(showKouBeiIcon) forKey:@"kTDFShowRestApp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kTDFMainViewReload" object:nil];
        }
    }];
    
    [self initInternationalCountry];
    
#if !RELEASE
    TDFNetworkHttpieLogger *networkLogger = [TDFNetworkHttpieLogger sharedLogger];
    networkLogger.level = TDFLoggerLevelDebug;
    
    networkLogger.filterPredicate = [NSPredicate predicateWithBlock:^BOOL(NSURLRequest *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return YES;
    }];
    [networkLogger startLogging];
    
    //    [JPLoader runTestScriptInBundle];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationBarItemNeedChange:) name:Notification_UI_Edit_Data_Changed object:nil];
    
    [TDFLogger configureLogger];
    [HBWebEngine startEngine];
    [self configUMengSocial];
    
    return YES;
}

- (void)registerPush:(UIApplication *)application{
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound |
                                                 UNAuthorizationOptionAlert |
                                                 UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else{
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)initTDFHttpClient {
    TDFHTTPClient *httpClient = [TDFHTTPClient sharedInstance];
    httpClient.tdf_appKey = APP_API_KEY;
    httpClient.tdf_appSecret = APP_API_SECRET;
    httpClient.tdf_bossAppKey = APP_BOSS_API_KEY;
    httpClient.tdf_bossAppSecret = APP_BOSS_API_SIGNKEY;
}

- (void)initSobotChatModule {
    TDFSobotCustomerModel *customerModel = [[TDFSobotCustomerModel alloc] init];
    customerModel.skillSetName = @"餐饮";
    customerModel.skillSetId = @"a752c85aa01e456b9d7442eb26a36aec";
    
    [[TDFSobotChat shareInstance] initSobotChatWithAppKey:@"491b3c97fffc4b69a84fd2164089e802"];
    [TDFSobotChat shareInstance].chatCustomerModel = customerModel;
}

- (void)initInternationalCountry {
    [[[TDFLoginService alloc] init] loadListCountry:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        NSArray *countryList = [NSArray yy_modelArrayWithClass:[TDFAreaCodeModel class] json:data[@"data"]];
        [TDFInternationalRender sharedInstance].areaCodeSuppportList = countryList;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)navigationBarItemNeedChange:(NSNotification *)notification {
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if (nav.viewControllers.count > 1) {
        UIViewController *viewController = nav.topViewController;
        
        NSDictionary *info = notification.object;
        
        BOOL changed = [info[@"changed"] boolValue];
        NSString *leftImageName = info[@"leftImageName"];
        NSString *rightImageName = info[@"rightImageName"];
        NSString *leftTitle = info[@"leftTitle"];
        NSString *rightTitle = info[@"rightTitle"];
        NSInteger action = [info[@"action"] integerValue];
        
        UIButton *leftButton = viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightButton = viewController.navigationItem.rightBarButtonItem.customView;
        CGFloat rightButtonWidth = [self getWidthWithImageName:rightImageName buttonName:rightTitle];
        
        if (!rightButton) {
            rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0.0f, 0.0f, rightButtonWidth, 40.0f);
            [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ([viewController respondsToSelector:@selector(rightNavigationButtonAction:)]) {
                [rightButton addTarget:viewController action:@selector(rightNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        } else {
            CGRect frame = rightButton.frame;
            
            frame.size.width = rightButtonWidth;
            
            rightButton.frame = frame;
        }
        
        [leftButton setImage:[UIImage imageWithName:leftImageName width:22.0f] forState:UIControlStateNormal];
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        leftButton.hidden = NO;
        
        [rightButton setImage:[UIImage imageWithName:rightImageName width:22.0f] forState:UIControlStateNormal];
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        if (action == 1) {
            [rightButton setHidden:NO];
        } else {
            [rightButton setHidden:!changed];
        }
        
    }
}

- (CGFloat)getWidthWithImageName:(NSString *)imageName buttonName:(NSString *)buttonName
{
    CGFloat imageWidth = (imageName.length == 0) ? 0 : 22.0f;
    
    CGFloat buttonWidth = buttonName.length * 20.0f;
    
    return imageWidth + buttonWidth;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.window endEditing:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [JPUSHService resetBadge];
    [self cancelAllNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [JPUSHService resetBadge];
    [self cancelAllNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    TDFLogDebug(@"Userinfo %@",notification.request.content.userInfo);
    //功能：可设置是否在应用内弹出通知
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

//iOS 10  点击推送消息后回调 点击通知栏
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    TDFLogDebug(@"Userinfo %@",response.notification.request.content.userInfo);
    
    //点击通知 直接跳转到调天页面
    [TDFSobotChat shareInstance].startChatImmediately = YES;
    [self cancelAllNotifications];
}
//本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    [self jumpActionWithApplicationState:application.applicationState];
}
//ios7 远程推送消息的时候都会调用此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self jumpActionWithApplicationState:application.applicationState];
}

- (void)jumpActionWithApplicationState:(UIApplicationState)applicationState {
    [self cancelAllNotifications];
    if(applicationState == UIApplicationStateActive){
        //询问是否查看未读消息
    }else {
        //通过点击通知栏 直接跳转
        [TDFSobotChat shareInstance].startChatImmediately = YES;
    }
}

//ios10 以下
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

//注册成功回调方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    
    TDFLogDebug(@"---Token--%@", deviceToken);
    [[ZCLibClient getZCLibClient] setToken:deviceToken];
    
#if DEBUG
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", deviceToken];
#endif
}

- (void)cancelAllNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

//注册失败回调方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    TDFLogDebug(@"Regist fail%@",error);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [AliPayResultUtil payFinish:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [AliPayResultUtil payFinish:resultDic];
        }];
    }
    
    [[Platform Instance] setIsAccountLogined:YES];
    
    UIViewController *indexViewController;
    UIViewController *viewController = self.window.rootViewController;
    if([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        indexViewController = nav.viewControllers.firstObject;
    }else {
        indexViewController = viewController;
    }
    
    if ([TDFDataCenter sharedInstance].weChatShare) {
        
        return [WXApi handleOpenURL:url delegate:[TDFDataCenter sharedInstance].weChatShare];
    }
    
    return [WXApi handleOpenURL:url delegate:indexViewController];
}


- (void)initPlatform
{
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [Platform Instance].deviceId = deviceId;
}

- (void)initSocialData
{
    //    [UMSocialData setAppKey:UMANALYTICS_KEY];
    [WXApi registerApp:WX_APP_ID];
}

- (void)initAppAnalytics
{
    UMConfigInstance.appKey = UMANALYTICS_KEY;
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

- (void)initPushService:(NSDictionary *)options
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:options appKey:JPUSH_KEY channel:@"Publish channel" apsForProduction:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)initItemFactory
{
    [ItemFactory initFactory];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary *userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *operationDictionary = [JsonHelper transMap:content];
    
    NSDictionary *extras = userInfo[@"extras"];
    
    if (extras && extras.count == 0) {
        return;
    }
    
    NSInteger extrasType = [extras[@"type"] integerValue];
    
    if (extrasType == 22) {
        SysNotificationVO *sysNotificaionVo = [SysNotificationVO convertToSysNotificationVO:operationDictionary];
        [SystemEvent dispatch:REFRESH_SYS_NOTIFICAION object:sysNotificaionVo];
    } else if (extrasType == 23) {
        OperationMessage *operationMessage = [OperationMessage convertToOperationMessage:operationDictionary];
        [SystemEvent dispatch:PROCESS_OPERATION_MESSAGE object:operationMessage];
    }
}

///3dtouc回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    UserLoginData *userLoginData = [UserLoginData getLoginData];
    WeixinLoginData *weixinLoginData = [WeixinLoginData getLoginData];
    
    if (userLoginData!=nil || weixinLoginData!=nil) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:CanGoToScanCodeViewController]) {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:CanGoToScanCodeViewController] boolValue]) {
                [self goToScanCodeViewController];
            }
            return;
        }
        
        NSString *type = shortcutItem.type;
        if ([type isEqualToString:@"scanItem"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:isNeedScanCodeViewController];
        }
    } else {
        return;
    }
    
}
///3dtouch
- (void)goToScanCodeViewController
{
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_tdfBarcodeViewController];
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
}

- (void)initAllFunctionSwitchDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TDFFunctionSwitch" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    [Platform Instance].allFunctionSwitchDictionary = dic;
}
@end
