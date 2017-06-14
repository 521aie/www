//
//  TDFWXConpousModel.h
//  RestApp
//
//  Created by 黄河 on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TDFWXCouponSyncStatusType) {
    TDFWXCouponSyncStatusTypeNone = 0, //!< 未同步
    TDFWXCouponSyncStatusTypeSynced, //!< 已同步
    TDFWXCouponSyncStatusTypeSyncing, //!< 同步中
};


@interface TDFWXConpousModel : NSObject<NSCopying>
/**
 * 卡ID
 */
@property (nonatomic, strong)NSString *conpousID;

/**
 * 卡名字
 */
@property (nonatomic, strong)NSString *name;

/**
 * 失败原因
 */
@property (nonatomic, strong)NSString *failReason;

/**
 * 开卡成功状态，0表示未开，1表示开启
 */
@property (nonatomic, assign)int openStatus;

/**
 * 开卡成功发卡开始时间
 */
//@property (nonatomic, strong)NSString *openStartTime;

/**
 * 开卡成功结束时间
 */
@property (nonatomic, strong)NSString *openEndTime;

/**
 * 推荐他人开卡状态，0表示未开启，1表示开启
 */
//@property (nonatomic, assign)int recommendStatus;/*产品说干掉*/

/**
 * 推荐他人开卡开始时间
 */
//@property (nonatomic, strong)NSString *recommendStartTime;/*产品说干掉*/

/**
 * 推荐他人开卡结束时间
 */
//@property (nonatomic, strong)NSString *recommendEndTime;/*产品说干掉*/

/**
 * 支付时发卡是否开启
 */
//@property (nonatomic, assign)int payStatus;

/**
 * 支付时发卡开始时间
 */
//@property (nonatomic, strong)NSString *payStartTime;

/**
 * 支付时发卡结束时间
 */
//@property (nonatomic, strong)NSString *payEndTime;

/**
 * 当前状态，0表示同步失败，1表示同步成功，2表示同步中，
 */
@property (nonatomic, assign)int status;

/**
 * 微信公众号 id
 */
@property (nonatomic, strong)NSString *wxId;

@end
