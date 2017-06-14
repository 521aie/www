//
//  DayOrderBillVO.h
//  RestApp
//
//  Created by zxh on 14-11-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"

@interface DayOrderBillVO : Jastor<INameValueItem>

/**
 * <code>订单ID</code>.
 */
@property (nonatomic,strong) NSString* orderId;

/**
 * <code>订单编号</code>.
 */
@property (nonatomic,strong) NSString* orderCode;

/**
 * <code>内单号(用于跟踪)</code>.
 */
@property (nonatomic,strong) NSString* innerCode;

/**
 * <code>开单时间</code>.
 */
@property long openTime;

/**
 * <code>短时间字符串</code>.
 */
@property (nonatomic,strong) NSString* openShortTime;

/**
 * <code>座位名称</code>.
 */
@property (nonatomic,strong) NSString* seatName;

/**
 * <code>账单Id</code>.
 */
@property (nonatomic,strong) NSString* totalPayId;

/**
 * <code>应收金额</code>.
 */
@property double resultAmount;

/**
 * <code>实收金额</code>.
 */
@property double recieveAmount;

/**
 * <code>TotalPay状态</code>.
 */
@property int status;

@end
