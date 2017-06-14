//
//  TDFMarketingStore.m
//  RestApp
//
//  Created by Octree on 14/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMarketingStore.h"
#import "TDFWXPayTraderModel.h"
#import "Platform.h"

NSString *const kTDFMenuCopyPromptShownKey = @"kMenuCopyPromptShownKey";
NSString *const kTDFMenuSettingPromptShownKey = @"kMenuCopyPromptShownKey";

//NSString *const kTDFWXPayTraderPermissionKey = @"PHONE_SPECIALLY_ENGAGED_MERCHANT";
//NSString *const kTDFOfficialAccountPermissionKey = @"PHONE_OFFICIAL_ACCOUNTS_OPERATION";
//
//
//NSString *const kTDFWXPayTraderBrandPermissionKey = @"PHONE_BRAND_SPECIALLY_ENGAGED_MERCHANT";
//NSString *const kTDFOfficialAccountBrandPermissionKey = @"PHONE_BRAND_OFFICIAL_ACCOUNTS_OPERATION";

@interface TDFMarketingStore ()

@end

@implementation TDFMarketingStore


+ (instancetype)sharedInstance {

    static TDFMarketingStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class] alloc] initPrivacy];
    });
    return instance;
}

- (instancetype)initPrivacy {

    if (self = [super init] ) {
        
    }
    
    return self;
}

- (BOOL)alreadyEstablishTrader {

    return self.marketingModel.wxpayTraderApplyStatus != TDFWXPayTraderAuditStatuseSuccess || self.marketingModel.wxpayTraderEstablishCount > 0;
}

- (void)setMenuCopyPromptShown:(BOOL)menuCopyPromptShown {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:menuCopyPromptShown forKey:kTDFMenuCopyPromptShownKey];
    [defaults synchronize];
}

- (BOOL)isMenuCopyPromptShown {

    return [[NSUserDefaults standardUserDefaults] boolForKey:kTDFMenuCopyPromptShownKey];
}

- (void)setMenuSettingPromptShown:(BOOL)menuSettingPromptShown {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:menuSettingPromptShown forKey:kTDFMenuSettingPromptShownKey];
    [defaults synchronize];
}

- (BOOL)isMenuSettingPromptShown {

    return [[NSUserDefaults standardUserDefaults] boolForKey:kTDFMenuSettingPromptShownKey];
}


//- (BOOL)isWXPayTraderPermitted {
//    return [self.codeArray containsObject:[Platform Instance].isChain?kTDFWXPayTraderBrandPermissionKey:kTDFWXPayTraderPermissionKey];
//}
//
//- (BOOL)isOfficialAccountPermitted {
//    return [self.codeArray containsObject:[Platform Instance].isChain?kTDFOfficialAccountBrandPermissionKey:kTDFOfficialAccountPermissionKey];
//}

@end
