//
//  TDFTraderAuditModel.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTraderAuditModel.h"
#import "TDFWXPayTraderModel.h"

@implementation TDFTraderAuditModel

/**
 *  YYModel
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

- (NSString *)applyDateString {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = NSLocalizedString(@"YYYY年MM月dd日 HH:mm", nil);
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.applyTime / 1000.0]];
}

- (NSString *)detail {

    if (self.status == TDFWXPayTraderAuditStatusFailed) {
        
        return self.reason;
    }
    
    return _detail;
}

@end


@implementation TDFTraderAuditModel (WXPayTraderAuditInfo)

+ (instancetype)auditModelWithStatus:(NSInteger)status {

    TDFTraderAuditModel *model = [[TDFTraderAuditModel alloc] init];
    model.status = status;
    switch (status) {
        case TDFWXPayTraderAuditStatusAuditing:
            
            model.title = NSLocalizedString(@"您的申请审核中", nil);
            model.detail = NSLocalizedString(@"您的申请资料已成功提交。由于申请的店家较多，微信官方审核出现延误，给您带来的不便深表歉意。我们已通知微信加急处理，请耐心等待。", nil);
            break;
        case TDFWXPayTraderAuditStatusWaiting:
            model.title = NSLocalizedString(@"您的申请资料需进一步验证", nil);
            model.detail = @"";
            break;
        case TDFWXPayTraderAuditStatusValidating:
           
            model.title = NSLocalizedString(@"特约商户收款账户验证中", nil);
            model.detail = NSLocalizedString(@"您的验证申请已成功提交，由于申请的店家较多，微信官方审核出现延误，给您带来的不便深表歉意。我们已通知微信加急处理，请耐心等待。", nil);
            break;
        case TDFWXPayTraderAuditStatuseSuccess:
            model.title = NSLocalizedString(@"本店已开通微信支付特约商户", nil);
            model.detail = NSLocalizedString(@"注：特约商户开通后，您的微信支付收款将切换到此特约商户下，您可点击以下链接查看结算账户。特约商户信息无法修改，如结算方式需要变更，请联系二维火在线客服。", nil);
            break;
        case TDFWXPayTraderAuditStatusFailed:
            
            model.title = NSLocalizedString(@"申请资料未通过，请重新申请", nil);
            model.detail = nil;
        default:
            break;
    }
    return model;
}

@end
