//
//  MarketModule.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "AlertBox.h"
#import "Platform.h"
#import "UserService.h"
#import "ReportModule.h"
#import "RestConstants.h"
#import "ServiceFactory.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSString+Estimate.h"
#import "Action.h"
#import "TDFChainService.h"
#import "Base64.h"
#import "TDFDataCenter.h"
#import <libextobjc/EXTScope.h>
#import "TDFLoginService.h"
#import "TDFCompositeLoginParam.h"
#import "TDFCompositeLoginResultVo.h"
#import <TDFDataCenter.h>
#import "RemoteEvent.h"
#import "TDFSSOService.h"

typedef NS_ENUM(NSInteger,TDFEntityChangeType) {
    TDFBrandToShop,
    TDFBrandToBranch,
    TDFBranchToShop,
    TDFBranchToBranch,
};

@implementation ReportModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MainModule *)parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainModule = parent;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma navigateTitle.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainView];
    [self initNotification];
    [self loadData];
}

#pragma mark --loadData
- (void)loadData {
    TDFSSOService *ssoService = [[TDFSSOService alloc] init];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载...", nil)];
    @weakify(self);
    
    NSDictionary *params = @{
                             @"device_id" : [Platform Instance].deviceId? : @"",
                             @"app_key" : APP_BOSS_API_KEY,
                             @"s_os" : @"iOS"
                             };
    
    [ssoService grantPandoraTicketWithParams:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        @strongify(self);
        
        if ([responseObject[@"code"] integerValue] ==1) {
                        [self loadReportDataWithToken:responseObject[@"data"]];
            
            [self.progressHud hideAnimated:YES];
        }else {
            [self showProgressHudWithText:NSLocalizedString(@"加载失败，请重试", nil)];
            [self.progressHud hideAnimated:YES afterDelay:1.2f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self showProgressHudWithText:NSLocalizedString(@"加载失败，请重试", nil)];
        [self.progressHud hideAnimated:YES afterDelay:1.2f];
    }];
    

}



- (void)initMainView
{
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.hidden = YES;
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportReloginFinish:) name:REMOTE_REPORT_RELOGIN object:nil];
}

- (void)loadReportDataWithToken:(NSString *)token {
    NSString *shopCode = [[Platform Instance] getkey:SHOP_CODE];
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString *sessionId = [Platform Instance].jsessionId;
    NSString *serverPath = [Platform Instance].serverPath;
    NSString *urlString = [NSString stringWithFormat:kTDFReportURL, sessionId, shopCode,
                           [shopName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], entityId,serverPath];
    
    if (token) {
        urlString = [NSString stringWithFormat:@"%@&st=%@", urlString, [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadReportData
{
    [self loadReportDataWithToken:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.hidden = NO;
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        context.exception = exception;
    };
    
    context[@"log"] = ^{
    };
    
    context[@"callBackIOS"] = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    context[@"sessionTimeOut"] = ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_REPORT_RELOGIN object:nil];
    };
}

- (void)entityChange:(TDFEntityChangeType)type {
    TDFDataCenter *dataCenter = [TDFDataCenter sharedInstance];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    param[@"platform_type"] = @"1";
    param[@"user_id"] = dataCenter.userID;
    param[@"entity_id"] = dataCenter.entityId;
    param[@"j_session_id"] = [Platform Instance].jsessionId;
    
    @weakify(self);
    [[[TDFLoginService alloc] init] compositeEntityChange:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        NSString *jsessionId = data[@"data"][@"jSessionId"];
        [Platform Instance].jsessionId = jsessionId;
        [TDFDataCenter sharedInstance].jsessionId = jsessionId;
        [self changeShopSuccess];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)reportReloginFinish:(NSNotification *)notification
{
    [hud hideAnimated:YES];
    __block RemoteResult *result = notification.object;
    if (!result.isSuccess) {
        return;
    }

    if ([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"1"]){
        //门店
        NSDictionary* map=[JsonHelper transMap:result.content];
        NSString *jssessionId = [map objectForKey:@"jssessionId"];
        [Platform Instance].jsessionId=jssessionId;
        [TDFDataCenter sharedInstance].jsessionId = jssessionId;
        
        [self entityChange:TDFBrandToShop];
    }else if([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"2"]) {
        [self entityChange:TDFBranchToShop];
    }else if([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"3"]) {
        [self entityChange:TDFBrandToBranch];
    }else if([[[Platform Instance] getkey:SHOP_CHANGE_TYPE] isEqualToString:@"4"]) {
        [self entityChange:TDFBranchToBranch];
    }else{
        
        NSDictionary* map=[JsonHelper transMap:result.content];
        NSString *jssessionId = [map objectForKey:@"jssessionId"];
        [Platform Instance].jsessionId=jssessionId;
        [TDFDataCenter sharedInstance].jsessionId = jssessionId;
        
        NSString *noNSNull;
        NSDictionary *shopDic;
        BOOL isbranch = NO;
        if ([[[Platform Instance]getkey:IS_BRAND] isEqualToString:@"1"]) {
            shopDic = [map objectForKey:@"brand"];
        }else if([[[Platform Instance]getkey:IS_BRANCH] isEqualToString:@"1"]){
            shopDic = [map objectForKey:@"branch"];
            isbranch = YES;
        }else {
            shopDic = [map objectForKey:@"shop"];
        }
        NSDictionary *userDic = [map objectForKey:@"user"];
        noNSNull = [map objectForKey:@"jssessionId"];
        noNSNull = [map objectForKey:@"postAttachmentUrl"];
        NSString *fileServer = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = isbranch ? shopDic[@"branchName"] : shopDic[@"name"];
        NSString *shopName = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = isbranch ? shopDic[@"branchId"] : shopDic[@"id"];
        NSString *shopId = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = [userDic objectForKey:@"username"];
        NSString *userName = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = [userDic objectForKey:@"name"];
        NSString *realName = [NSString isBlank:noNSNull]?nil:noNSNull;
        NSNumber *isSupperNum = [userDic objectForKey:@"isSupper"];
        NSString *isSupper = [NSString stringWithFormat:@"%ld", (long)isSupperNum.integerValue];
        
        noNSNull = isbranch ? shopDic[@"branchCode"] : shopDic[@"code"];
        NSString *shopCode = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = [shopDic objectForKey:@"entityId"];
        NSString *entityId = [NSString isBlank:noNSNull]?nil:noNSNull;
        noNSNull = [userDic objectForKey:@"id"];
        NSString *userId = [NSString isBlank:noNSNull]?nil:noNSNull;
        NSString *imageServerPath = [fileServer stringByReplacingOccurrencesOfString:@"zmfile" withString:@"upload_files"];
        NSString *sessionstr =[NSString stringWithFormat:@"%@%@%@",APP_API_KEY,entityId,userId];
        User *user = [JsonHelper dicTransObj:userDic obj:[User alloc]];
        [[Platform Instance] setUser:user];
        
        [[Platform Instance] setFileServerPath:fileServer];
        [[Platform Instance] setImageServerPath:imageServerPath];
        [[Platform Instance] saveKeyWithVal:ENTITY_ID withVal:entityId];
        if ([self isBranch]) {
            [[Platform Instance] saveKeyWithVal:BRANCH_ENTITY_ID withVal:entityId];
        }
        [[Platform Instance] saveKeyWithVal:SHOP_NAME withVal:shopName];
        [[Platform Instance] saveKeyWithVal:SHOP_CODE withVal:shopCode];
        [[Platform Instance] saveKeyWithVal:SHOP_ID withVal:shopId];
        [[Platform Instance] saveKeyWithVal:USER_IS_SUPER withVal:isSupper];
        [[Platform Instance] saveKeyWithVal:USER_NAME withVal:userName];
        [[Platform Instance] saveKeyWithVal:REAL_NAME withVal:realName];
        [[Platform Instance] saveKeyWithVal:USER_ID withVal:userId];
        [[Platform Instance] saveKeyWithVal:SESSION_KEY withVal:sessionstr];
        [self loadReportData];
    }
}

- (void)savePowerList:(NSArray *)list {
    NSMutableArray *actionList = [JsonHelper transList:list objName:@"Action"];
    NSMutableDictionary *actionMap = [NSMutableDictionary dictionary];
    for (Action *action in actionList) {
        [actionMap setObject:action forKey:action.code];
    }
    
    [[Platform Instance] setActDic:actionMap];
}

- (void)changeManagershopFinish:(RemoteResult *)result
{
    if (!result.isSuccess) {
        return;
    }
    [self entityChange:TDFBrandToShop];
}

- (void)changeManagerBranchShopFinish:(RemoteResult *)result
{
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    [self entityChange:TDFBranchToShop];
}

- (void)changeShopSuccess {
    [[Platform Instance] setIsLogined:YES];
    [self loadReportData];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [AlertBox show:NSLocalizedString(@"网络异常", nil)];
}

- (BOOL)isBranch{
    if ([@"1" isEqualToString:[[Platform Instance]getkey:IS_BRANCH]]) {
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
