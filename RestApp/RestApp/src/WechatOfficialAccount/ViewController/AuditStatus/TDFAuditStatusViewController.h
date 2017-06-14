//
//  TDFAuditStatusViewController.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFTraderAuditModel.h"
#import "TDFAsync.h"
/**
 *  Default : Fetch Data From Server
 *  Custom  : + customViewWithModel
 */

@interface TDFAuditStatusViewController : UIViewController

/**
 *  Default : 1
 */
@property (nonatomic) NSUInteger popDepth;

/**
 *  重新申请回调
 */
@property (strong, nonatomic) void (^reapplyBlock)();

@property (strong, nonatomic) NSString *traderId;

/**
 *  TDFAsync
 *
 *  @param async 网络请求  TDFAsync<TDFTraderAuditModel *>
 *
 *  @return viewcontroller
 */
+ (instancetype)statusViewWithAsync:(TDFAsync *)async title:(NSString *)title viewProfileBlock:(void(^)(void))block;


@end
