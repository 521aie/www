//
//  TDFAuditStatusView.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditStatusView.h"

@implementation TDFAuditStatusView


- (instancetype)initWithAuditModel:(TDFTraderAuditModel *)model {

    if (self = [super init]) {
        
        _model = model;
        self.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    
    return self;
}

- (void)configSubViews {

    
}

@end
