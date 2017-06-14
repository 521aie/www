//
//  TDFMemberInfoDayModel.h
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import <Foundation/Foundation.h>

@interface TDFMemberInfoDayModel : NSObject

/**
 日期 格式：20161226
 */
@property (nonatomic, strong) NSString *date;

/**
 会员总数
 */
@property (nonatomic, assign) int customerNum;

/**
 昨日新增会员数
 */
@property (nonatomic, assign) int customerNumDay;

/**
 昨日老会员数
 */
@property (nonatomic, assign) int customerOldNumDay;

/**
 会员消费单数
 */
@property (nonatomic, assign) int customerPayNumDay;

/**
 昨日会员消费
 */
@property (nonatomic, assign) double customerPayMoneyDay;

/**
 昨日领卡数
 */
@property (nonatomic, assign) int receiveCardDay;

/**
 昨日会员充值次数
 */
@property (nonatomic, assign) int memberChargeTimesDay;

/**
 昨日会员充值金额
 */
@property (nonatomic, assign) double memberChargeAmountDay;

/**
 会员卡消费数
 */
@property (nonatomic, assign) int cardPayNumDay;

/**
 会员卡支付金额
 */
@property (nonatomic, assign) double cardPayMoneyDay;

/**
 领卡总数
 */
@property (nonatomic, assign) int receiveCard;

/**
 截止昨日充值余额
 */
@property (nonatomic, assign) double rechargeMoney;

/**
 会员消费单数占比
 */
@property (nonatomic, strong) NSString *customerPayNumPercent;

/**
 会员消费金额占比
 */
@property (nonatomic, strong) NSString *customerPayMoneyPercent;

/**
 截止昨日会员充值总额
 */
@property (nonatomic, assign) double memberChargeAmount;

@end
