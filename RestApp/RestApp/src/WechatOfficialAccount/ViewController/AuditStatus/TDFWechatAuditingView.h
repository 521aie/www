//
//  TDFWechatAuditingView.h
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditStatusView.h"

@interface TDFWechatAuditingView : TDFAuditStatusView

@property (strong, nonatomic) void (^urgentBlock)();

@end
