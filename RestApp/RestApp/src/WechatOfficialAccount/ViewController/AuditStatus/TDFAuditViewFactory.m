//
//  TDFAuditViewFactory.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditViewFactory.h"
#import "TDFAuditFailedView.h"
#import "TDFAuditingView.h"
#import "TDFTraderAuditModel.h"
#import "TDFWXPayTraderModel.h"
#import "TDFAuditFailedView.h"
#import "TDFAuditSuccessView.h"
#import "TDFWechatAuditingView.h"

@implementation TDFAuditViewFactory

- (TDFAuditStatusView *)statusViewWithModel:(TDFTraderAuditModel *)model {

    switch (model.status) {
        case TDFWXPayTraderAuditStatusAuditing:                         //  正在审核
            return [[TDFAuditingView alloc] initWithAuditModel:model];
            
        case TDFWXPayTraderAuditStatusWaiting:                          //  等待微信审核
            return [[TDFWechatAuditingView alloc] initWithAuditModel:model];
            
        case TDFWXPayTraderAuditStatusValidating:                       //  审核人员验证（微信完成审核后）
            return [[TDFAuditingView alloc] initWithAuditModel:model];
            
        case TDFWXPayTraderAuditStatuseSuccess:                         //  审核成功
            return [[TDFAuditSuccessView alloc] initWithAuditModel:model];
            
        case TDFWXPayTraderAuditStatusFailed:                           //  审核失败
            return [[TDFAuditFailedView alloc] initWithAuditModel:model];
    }
    
    NSAssert(NO, @"Should Not Be Called");
    return nil;
}

@end
