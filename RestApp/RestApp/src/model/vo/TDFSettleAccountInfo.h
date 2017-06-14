//
//  TDFSettleAccountInfo.h
//  RestApp
//
//  Created by 栀子花 on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFSettleAccountInfo : NSObject

/**
 * 商户entityId
 */
@property (nonatomic, copy) NSString *entityId;
/**
 * 账户状态：0，未进件；1，已进件；2，进件失败
 */
@property (nonatomic, assign)NSInteger  authStatus;
/**
 * 进件消息
 */
@property (nonatomic, copy)NSString  *authMessage;
/**
 * 审核状态；0；默认；1，审核中；2，审核通过；3，审核失败
 */
@property (nonatomic, assign) NSInteger auditStatus;
/**
 * 审核原因
 */
@property (nonatomic, copy)NSString  *auditMessage;
/**
 * 审核时间
 */
@property (nonatomic) long  auditTime;
/**
 * 绑定时间
 */
@property (nonatomic) long  opTime;
/**
 * 审核人
 */
@property (nonatomic, copy)NSString  *auditor;




@end
