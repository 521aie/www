//
//  TDFHomeOldBusinessLogicManager.h
//  RestApp
//
//  Created by happyo on 2017/4/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDFHomeOldBusinessLogicAPI;
@class TDFCommonRequestAPI;

static NSString *kHealthCheckDate = @"HEALTH_CHECK_DATE";

@interface TDFHomeOldBusinessLogicManager : NSObject

@property (nonatomic, weak, readonly) UIView *view;

@property (nonatomic, strong) TDFHomeOldBusinessLogicAPI *logicApi;

@property (nonatomic, strong) NSDictionary *findNoticeResultVo;

/**
 用于弹框和跳转的vc，是UINavigationController
 */
@property (nonatomic, weak) UINavigationController *rootViewController;

@property (nonatomic, assign) BOOL hasOtherEntity;

@property (nonatomic, strong) void (^successApiBlock)(TDFHomeOldBusinessLogicManager *manager);

- (instancetype)initWithView:(UIView *)view;

- (void)configureApis;

- (void)showHomeView;

- (void)showEntryView;

@end
