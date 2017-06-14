//
//  TDFAuditViewFactory.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFAuditStatusView.h"

@interface TDFAuditViewFactory : NSObject

- (TDFAuditStatusView *)statusViewWithModel:(TDFTraderAuditModel *)model;

@end
