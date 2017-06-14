//
//  TDFAutoFollowModel.h
//  RestApp
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFBaseModel.h"
#import "TDFOfficialAccountModel.h"
#import "INameItem.h"

typedef NS_ENUM(NSInteger, TDFAutoFollowAuditStatus) {

    TDFAutoFollowAuditStatusNerverApply     =       0,         //  未提交
    TDFAutoFollowAuditStatusAuditing        =       1,         //  审核中
    TDFAutoFollowAuditStatusSuccess         =       2,         //  成功
    TDFAutoFollowAuditStatusFailed          =       3,         //  失败
};

typedef NS_ENUM(NSInteger, TDFOfficialAccountAuthType) {

    TDFOfficialAccountAuthTypeAuthed    =   0,          //  已经授权的公众号
    TDFOfficialAccountAuthTypeCustom    =   1,          //  自定义的公众号
};

@interface TDFAutoFollowModel : TDFBaseModel <NSCopying>

@property (strong, nonatomic) TDFOfficialAccountModel *officialAccount;               //  公众号名称
@property (copy, nonatomic) NSString *reason;                                       //  失败原因
@property (nonatomic) NSInteger uploadTime;                                         //  审核时间
@property (nonatomic) TDFAutoFollowAuditStatus status;                      //  审核状态
@property (nonatomic) TDFOfficialAccountAuthType type;

@end

@class TDFTraderAuditModel;
@interface TDFAutoFollowModel (Adapter)

- (TDFTraderAuditModel *)bridgeToTraderAuditModel;

@end
