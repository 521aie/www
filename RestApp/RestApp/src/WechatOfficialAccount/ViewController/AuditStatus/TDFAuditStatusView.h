//
//  TDFAuditStatusView.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFTraderAuditModel.h"
/**
 *  审核信息 View
 */

@interface TDFAuditStatusView : UIView

@property (strong, nonatomic) TDFTraderAuditModel *model;

- (instancetype)initWithAuditModel:(TDFTraderAuditModel *)model;

- (void)configSubViews;

@end
