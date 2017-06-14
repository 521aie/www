//
//  ShopReviewCenter.m
//  RestApp
//
//  Created by Octree on 20/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopReviewCenter.h"
#import "ServiceFactory.h"
#import "KabawService.h"
#import "Platform.h"
#import "ActionConstants.h"


NSString *const kShopReviwShowRemindOnceTokenKey = @"kShopReviwShowRemindOnceToken";
NSString *const kShopReviewStateChangedNotification = @"kShopReviewStateChangedNotification";

@implementation ShopReviewCenter

#pragma mark - Life Cycyle
+ (instancetype)sharedInstance {

    static ShopReviewCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[ShopReviewCenter alloc] initPrivate];
    });
    
    return instance;
}


- (instancetype)initPrivate {

    if (self = [super init]) {
    
    }
    
    return self;
}

#pragma mark - Private Methods




#pragma mark - Accessor

- (void)setRemindViewShown:(BOOL)remindViewShown {

    _remindViewShown = remindViewShown;
    if (remindViewShown) {
     
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:kShopReviwShowRemindOnceTokenKey];
        [defaults synchronize];
    }
}

- (BOOL)shouldAlertRemindView {

    return self.reviewState == ShopReviewStateNone;
}

- (BOOL)shouldShowWarningBadge {

    return self.reviewState == ShopReviewStateNone;
}

- (void)setReviewState:(ShopReviewState)reviewState {

    _reviewState = reviewState;
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopReviewStateChangedNotification object:nil];
}

@end
