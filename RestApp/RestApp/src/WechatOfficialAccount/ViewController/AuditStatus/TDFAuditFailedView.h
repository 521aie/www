//
//  TDFAuditFailedView.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditStatusView.h"

/**
 *  审核失败
 */
@interface TDFAuditFailedView : TDFAuditStatusView

@property (strong, nonatomic) void (^retryBlock)();

@end
