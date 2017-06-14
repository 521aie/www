//
//  TDFWXMemberCardModel.h
//  RestApp
//
//  Created by 黄河 on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TDFWXCardSyncStatusType) {
    TDFWXCardSyncStatusTypeNone = 0, //!< 未同步
    TDFWXCardSyncStatusTypeSynced, //!< 已同步
    TDFWXCardSyncStatusTypeSyncing, //!< 同步中
};


@interface TDFWXMemberCardModel : NSObject<NSCopying>
/**
 * 卡ID
 */
@property (nonatomic, strong)NSString *cardID;

/**
 * 卡名字
 */
@property (nonatomic, strong)NSString *name;

/**
 * 失败原因
 */
@property (nonatomic, strong)NSString *failReason;

/**
 * 关注时发卡是否开启
 */
@property (nonatomic, assign)int followStatus;

/**
 * 关注时发卡开始时间
 */
@property (nonatomic, strong)NSString *followStartTime;

/**
 * 关注时发卡结束时间
 */
@property (nonatomic, strong)NSString *followEndTime;

/**
 * 使用须知
 */
//@property (nonatomic, strong)NSString *memo;

/**
 * 支付时发卡是否开启
 */
@property (nonatomic, assign)int payStatus;

/**
 * 支付时发卡开始时间
 */
@property (nonatomic, strong)NSString *payStartTime;

/**
 * 支付时发卡结束时间
 */
@property (nonatomic, strong)NSString *payEndTime;

/**
 * 当前状态，0表示同步失败，1表示同步成功，2表示同步中，
 */
@property (nonatomic, assign)int status;

/**
 * 微信公众号 id
 */
@property (nonatomic, strong)NSString *wxId;

/**
 激活卡时发券是否开启 0 未开启，1开启
 */
@property (assign, nonatomic) NSInteger activeStatus;

/**
 结束时间
 */
@property (strong, nonatomic) NSString *activeEndTime;

/**
 优惠券id
 */
@property (strong, nonatomic) NSString *couponId;

/**
 优惠券名称
 */
@property (strong, nonatomic) NSString *couponName;

@end
