//
//  TDFMarketingStore.h
//  RestApp
//
//  Created by Octree on 14/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFWXMarketingModel.h"
#import "TDFFunctionVo.h"

@interface TDFMarketingStore : NSObject

@property (nonatomic, strong) NSArray *codeArray;

@property (strong, nonatomic) TDFWXMarketingModel *marketingModel;
@property (copy, nonatomic) NSString *traderId;

/**
 *  微信菜单设置提示是否已经显示过了
 */
@property (nonatomic, getter=isMenuSettingPromptShown) BOOL menuSettingPromptShown;

/**
 *  微信菜单复制提示是否已经显示过了
 */
@property (nonatomic, getter=isMenuCopyPromptShown) BOOL menuCopyPromptShown;
/**
 *  是否有微信特约商户的权限
 */
@property (nonatomic, readonly) BOOL isWXPayTraderPermitted;
/**
 *  是否有微信公众号的权限
 */
@property (nonatomic, readonly) BOOL isOfficialAccountPermitted;
/**
 *  单店的 ShopId
 */
@property (copy, nonatomic) NSString *shopId;

///**
// *   是否拥有特约商户权限
// */
//@property (nonatomic, readonly) BOOL traderPermitted;
//
///**
// *  是否拥有微信公众号权限
// */
//@property (nonatomic, readonly) BOOL officialAccountPermitted;

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

/**
 *  是否已经开通微信公众帐号
 */
@property (nonatomic, readonly) BOOL alreadyEstablishTrader;

@end
