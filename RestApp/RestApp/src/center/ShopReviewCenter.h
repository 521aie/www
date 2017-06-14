//
//  ShopReviewCenter.h
//  RestApp
//
//  Created by Octree on 20/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopReviewInfo.h"

FOUNDATION_EXPORT NSString *const kShopReviewStateChangedNotification;

@interface ShopReviewCenter : NSObject

/**
 *  是否应该弹出审核提示的 VC
 */
@property (nonatomic, readonly) BOOL shouldAlertRemindView;

/**
 *  是否应该显示警示图标
 */
@property (nonatomic, readonly) BOOL shouldShowWarningBadge;

@property (nonatomic) ShopReviewState reviewState;

@property (nonatomic, getter=isRemindViewShown) BOOL remindViewShown;


+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

@end
