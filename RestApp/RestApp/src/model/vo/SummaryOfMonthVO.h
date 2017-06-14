//
//  SummaryOfMonthVO.h
//  RestApp
//
//  Created by zxh on 14-8-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@class BusinessDayVO;
@interface SummaryOfMonthVO : Jastor


/**
 * <code>风格名称</code>.
 */
@property (nonatomic,retain) NSString *period;

/** 应收.  */
@property double sourceFee;

/** 折扣.  */
@property double discountFee;

/** 总营业额.  */
@property double fee;
/** 总人数. */
@property int peopleCount;
/** 账单数(单). */
@property int orderCount;
/** 损益金额. */
@property double profit;

-(BusinessDayVO*) convertVO;

@end
