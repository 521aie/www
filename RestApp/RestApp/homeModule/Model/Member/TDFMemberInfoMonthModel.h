//
//  TDFMemberInfoMonthModel.h
//  Pods
//
//  Created by happyo on 2017/4/12.
//
//

#import <Foundation/Foundation.h>

@interface TDFMemberInfoMonthModel : NSObject

/**
 月期 格式：201612 到月
 */
@property (nonatomic, strong) NSString *month;

/**
 会员总数
 */
@property (nonatomic, assign) int customerNum;

/**
 昨月新增会员数
 */
@property (nonatomic, assign) int customerNumMonth;

/**
 昨月老会员数
 */
@property (nonatomic, assign) int customerOldNumMonth;

/**
 会员消费单数
 */
@property (nonatomic, assign) int customerPayNumMonth;

/**
 昨月会员消费
 */
@property (nonatomic, assign) double customerPayMoneyMonth;

/**
 昨月领卡数
 */
@property (nonatomic, assign) int receiveCardMonth;

/**
 昨月会员充值次数
 */
@property (nonatomic, assign) int memberChargeTimesMonth;

/**
 昨月会员充值金额
 */
@property (nonatomic, assign) double memberChargeAmountMonth;

/**
 会员卡消费数
 */
@property (nonatomic, assign) int cardPayNumMonth;

/**
 会员卡支付金额
 */
@property (nonatomic, assign) double cardPayMoneyMonth;

/**
 领卡总数
 */
@property (nonatomic, assign) int receiveCard;

/**
 截止昨月充值余额
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
 截止昨月会员充值总额
 */
@property (nonatomic, assign) double memberChargeAmount;

@end
