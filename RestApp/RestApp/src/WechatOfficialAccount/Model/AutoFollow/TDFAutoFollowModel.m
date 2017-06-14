//
//  TDFAutoFollowModel.m
//  RestApp
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAutoFollowModel.h"
#import "TDFTraderAuditModel.h"
#import "TDFWXPayTraderModel.h"

@implementation TDFAutoFollowModel

/**
 *  YYModel
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

- (id)copyWithZone:(NSZone *)zone {
    
    TDFAutoFollowModel *model = [[TDFAutoFollowModel allocWithZone:zone] init];
    model.officialAccount = self.officialAccount;
    model.reason = self.reason;
    model.uploadTime = self.uploadTime;
    model.status = self.status;
    model.type = self.type;
    return model;
}


@end


@implementation TDFAutoFollowModel (Adapter)

- (TDFTraderAuditModel *)bridgeToTraderAuditModel {

    TDFTraderAuditModel *model = [[TDFTraderAuditModel alloc] init];
    model.applyTime = self.uploadTime;
    model.reason = self.reason;
    
    switch (self.status) {
            
        case TDFAutoFollowAuditStatusAuditing:
            
            model.title = NSLocalizedString(@"您的申请审核中", nil);
            model.detail = NSLocalizedString(@"您的申请资料已成功提交。由于申请的店家较多，微信官方审核出现延误，给您带来的不便深表歉意。我们已通知微信加急处理，请耐心等待。", nil);
            model.status = TDFWXPayTraderAuditStatusAuditing;
            break;
        case TDFAutoFollowAuditStatusFailed:
            
            model.title = [NSString stringWithFormat:NSLocalizedString(@"您的申请未通过，申请微信号为“%@”", nil), self.officialAccount.name];
            model.status = TDFWXPayTraderAuditStatusFailed;
            break;
        default:
            break;
    }
    
    return model;
}
@end
