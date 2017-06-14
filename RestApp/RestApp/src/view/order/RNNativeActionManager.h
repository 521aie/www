//
//  RNNativeActionManager.h
//  RestApp
//
//  Created by QiYa on 16/9/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const RNTransformLabelIdNotification  = @"RNTransformLabelIdNotification";
static NSString * const RNPushMajorMaterialNotification = @"RNPushMajorMaterialNotification";
static NSString * const RNPopVCNotification             = @"RNPopVCNotification";

static NSString * const RNHelpActionNotification = @"RNHelpActionNotification";
static NSString * const RNDidMountNotification = @"RNDidMountNotification";
static NSString * const RNAddImageNotification = @"RNAddImageNotification";
static NSString * const RNRemoveImageNotification = @"RNRemoveImageNotification";

@interface RNNativeActionManager : NSObject

@end
