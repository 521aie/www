//
//  TDFWXPayTrader.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFBaseModel.h"
#import "TDFAutoFollowModel.h"
#import "TDFRefundAuditModel.h"
#import "NSDate+TDFMilliInterval.h"

/**
 *  审核状态
 */
typedef NS_ENUM(NSInteger, TDFWXPayTraderAuditStatus) {
    TDFWXPayTraderAuditStatusNotApply       =       0,      //  尚未提交
    TDFWXPayTraderAuditStatusAuditing       =       1,      //  正在审核
    TDFWXPayTraderAuditStatusWaiting        =       2,      //  等待微信审核
    TDFWXPayTraderAuditStatusValidating     =       3,      //  审核人员验证（微信完成审核后）
    TDFWXPayTraderAuditStatuseSuccess       =       4,      //  审核成功
    TDFWXPayTraderAuditStatusFailed         =       5,      //  审核失败
};

/**
 *  商户类型
 */
typedef NS_ENUM(NSInteger, TDFTraderType) {
    
    TDFTraderTypeEnterprise     =   0,          //  企业
    TDFTraderTypeIndividual     =   1,          //  工商个体户
};

/**
 *  经营类型
 */
typedef NS_ENUM(NSInteger, TDFBusinessType) {
    
    TDFBusinessTypeCatering     =   0,          //  餐饮/食品
    TDFBusinessTypeRetail       =   1,          //  线下零售
};

/**
 *  经营子类型
 */
typedef NS_ENUM(NSInteger, TDFBusinessSubType) {
    
    /**
     *  食品
     */
    TDFBusinessSubTypeFood          =   0,
    /**
     *  餐饮
     */
    TDFBusinessSubTypeCatering      =   1,
    /**
     *  便利
     */
    TDFBusinessSubTypeStore         =   2,
    /**
     *  其他综合零售
     */
    TDFBusinessSubTypeOthers        =   3,
};

/**
 *  证件持有人类型
 */
typedef NS_ENUM(NSInteger, TDFCertificateHolderType) {

    TDFCertificateHolderTypeLegal       =   0,          //  法人
    TDFCertificateHolderTypeAgent       =   1,          //  经办人
};


/**
 *  账户类型
 */
typedef NS_ENUM(NSInteger, TDFAccountType) {
    
    TDFAccountTypeCorporate     =       0,          //  法人账户
    TDFAccountTypePublic        =       1,          //  对公账户
};

/**
 *  证件类型
 */
typedef NS_ENUM(NSInteger, TDFCredentialType) {

    TDFCredentialTypeIDCard     =   0,      //  身份证
    TDFCredentialTypePassport   =   1,      //  护照
};


@interface TDFWXPayTraderModel : TDFBaseModel

/**
 *  审核状态
 */
@property (nonatomic, assign) TDFWXPayTraderAuditStatus status;

/**
 *  审核未通过原因
 */
@property (nonatomic, copy) NSString *reason;
/**
 *  联系人姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  常用邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  公司名称
 */
@property (nonatomic, copy) NSString *company;
/**
 *  注册地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  商家简称
 */
@property (nonatomic, copy) NSString *abbreviation;
/**
 *  商家类目
 */
@property (nonatomic) TDFTraderType traderType;
/**
 *  经营类目
 */
@property (nonatomic) TDFBusinessType businessType;
/**
 *  经营子类目
 */
@property (nonatomic) TDFBusinessSubType businessSubType;
/**
 *  特殊资质证件图片的 URL
 */
@property (nonatomic, copy) NSString *specialCreditURL;
/**
 *  特殊资质证件图片的 URL
 */
@property (nonatomic, copy) NSArray *specialCreditURLs;
/**
 *  客服电话
 */
@property (nonatomic, copy) NSString *servicePhone;
/**
 *  营业执照编号
 */
@property (nonatomic, copy) NSString *businessLicenseNumber;
/**
 *  经营范围
 */
@property (nonatomic, copy) NSString *businessScope;
/**
 *  营业执照照片 URL
 */
@property (nonatomic, copy) NSString *businessLicenseURL;
/**
 *  证件持有人类型
 */
@property (nonatomic) TDFCertificateHolderType certificateHolderType;
/**
 *  证件持有人姓名
 */
@property (nonatomic, copy) NSString *certificateHolderName;
/**
 *  证件类型
 */
@property (nonatomic) TDFCredentialType credentialType;
/**
 *  身份证正面图片 URL
 */
@property (nonatomic, copy) NSString *idCardFrontImageURL;
/**
 *  身份证背面图片 URL
 */
@property (nonatomic, copy) NSString *idCardBackImageURL;
/**
 *   证件创建日期
 */
@property (nonatomic) NSInteger idCardCreationDate;
/**
 *  证件失效日期
 */
@property (nonatomic) NSInteger idCardExpiredDate;
/**
 *  证件号
 */
@property (nonatomic, copy) NSString *idCardNumber;
/**
 *  账户类型
 */
@property (nonatomic) TDFAccountType accountType;
/**
 *  账户名称
 */
@property (nonatomic, copy) NSString *accountName;
/**
 *  开户省份
 */
@property (nonatomic, copy) NSString *accountProvinceId;
/**
 *  开户省份 - name
 */
@property (nonatomic, copy) NSString *accountProvinceName;
/**
 *  开户城市 Id
 */
@property (nonatomic, copy) NSString *accountCityId;
/**
 *  开户城市 Name
 */
@property (nonatomic, copy) NSString *accountCityName;
/**
 *  开户支行 Id
 */
@property (nonatomic, copy) NSString *accountBranchId;
/**
 *  开户支行 Name
 */
@property (nonatomic, copy) NSString *accountBranchName;
/**
 *  开户银行 Id
 */
@property (nonatomic, copy) NSString *accountBankId;

/**
 *  开户银行 Name
 */
@property (nonatomic, copy) NSString *accountBankName;

/**
 *  银行帐号
 */
@property (nonatomic, copy) NSString *accountNumber;
/**
 *  信息更改时间
 */
@property (nonatomic) NSInteger updateDate;
/**
 *  申请提交时间
 */
@property (nonatomic) TDFMilliTimeInterval applyDate;

/**
 *  银行开户证明书
 */
@property (nonatomic, copy) NSString *accountPermitURL;

@end



@interface TDFTraderModel : TDFBaseModel

@property (copy, nonatomic) NSString *name;
@property (nonatomic) NSInteger count;                              //   绑定数量
@property (nonatomic) TDFWXPayTraderAuditStatus status;             //   特约商户审核状态
@property (nonatomic) TDFRefundAuditStatus refundStatus;           //   退款审核状态
@property (nonatomic) TDFAutoFollowAuditStatus autoFollowStatus;   //   自动关注状态
@property (copy, nonatomic) NSString *traderNumber;

@end
