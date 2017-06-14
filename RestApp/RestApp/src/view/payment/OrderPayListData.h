//
//  OrderPayListData.h
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPayListData : NSObject
/**
 *  流水号
 */
@property (nonatomic, strong) NSString *innerCode;//
/**
 *  用户手机号
 */
@property (nonatomic, copy) NSString *mobile;//
/**
 *  桌号
 */
@property (nonatomic, copy) NSString *seatCode;//
/**
 *  桌位
 */
@property (nonatomic, strong) NSString *seatName;//
/**
 *  业务类型(消息类型)
 */
@property (nonatomic, copy) NSString *payMsgTag;
/**
 *  结账时间
 */
@property (nonatomic, assign) long long payTime;//
/**
 *  分账状态
 */
@property (nonatomic, assign) NSInteger shareBillStatus;//
/**
 *  分账状态msg
 */
@property (nonatomic, copy) NSString *shareBillStatusMsg;
/**
 *  微信昵称
 */
@property (nonatomic, copy) NSString *wechatNickName;//
/**
 *  支付类型
 */
@property (nonatomic, assign) NSInteger payType;//
/**
 * 支付状态
 */
@property (nonatomic, assign) NSInteger payStatus;
/**
 *  支付类型
 */
@property (nonatomic, assign) NSInteger type;//
/**
 *  订单号
 */
@property (nonatomic, copy) NSString *orderId;//
/**
 *  微信交易流水号
 */
@property (nonatomic, copy) NSString *transcationId;//
/**
 * 退款支付流水号
 */
@property (nonatomic, copy) NSString *refundTransactionId;//
/**
 *  微信实际支付金额
 */
@property (nonatomic, assign) CGFloat wxPay; //
/**
 *  会员卡
 */
@property (nonatomic, copy)NSString *kindCardName;//
/**
 *  卡号
 */
@property (nonatomic, copy)NSString *cardNo;//
/**
 * 注册会员ID
 */
@property (nonatomic, copy) NSString *customerRegisterId;


- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
