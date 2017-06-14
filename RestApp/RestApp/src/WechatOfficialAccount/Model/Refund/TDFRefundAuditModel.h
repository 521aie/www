//
//  TDFRefundAuditModel.h
//  RestApp
//
//  Created by Octree on 14/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseModel.h"
#import "TDFTraderAuditModel.h"
#import "NSDate+TDFMilliInterval.h"

typedef NS_ENUM(NSInteger, TDFRefundAuditStatus) {

    TDFRefundAuditStatusNerverApply     =       0,         //  未提交
    TDFRefundAuditStatusAuditing        =       4,         //  审核中
    TDFRefundAuditStatusInvited         =       5,         //  已经邀请
    TDFRefundAuditStatusAccept          =       6,         //  已经接受邀请
    TDFRefundAuditStatusSuccess         =       7,         //  成功
};

@interface TDFRefundAuditModel : TDFBaseModel

@property (copy, nonatomic) NSString *reason;
@property (copy, nonatomic) NSString *submittedPicUrl;
@property (nonatomic) TDFMilliTimeInterval uploadTime;
@property (nonatomic) TDFRefundAuditStatus status;

@end


@interface TDFRefundAuditModel (Transform)

- (TDFTraderAuditModel *)transformToTraderModel;

@end
