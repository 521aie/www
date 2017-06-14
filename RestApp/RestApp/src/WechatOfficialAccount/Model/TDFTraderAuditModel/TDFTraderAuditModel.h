//
//  TDFTraderAuditModel.h
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFBaseModel.h"
#import "NSDate+TDFMilliInterval.h"

@interface TDFTraderAuditModel : TDFBaseModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *reason;
/**
 *  提交时间
 */
@property (nonatomic) TDFMilliTimeInterval applyTime;
/**
 *  审核状态
 */
@property (nonatomic) NSInteger status;
/**
 *  是否加急
 */
@property (nonatomic) BOOL isurgent;
/**
 *  特约商户号
 */
@property (copy, nonatomic) NSString *traderNumber;

/**
 *  是否是导入的信息
 */
@property (nonatomic) BOOL isImported;

@property (copy, nonatomic, readonly) NSString* applyDateString;


@end


@interface TDFTraderAuditModel (WXPayTraderAuditInfo)

+ (instancetype)auditModelWithStatus:(NSInteger)status;

@end
