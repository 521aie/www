//
//  KindPayDayStatMainVO.h
//  RestApp
//
//  Created by zxh on 14-11-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface KindPayDayStatMainVO : Jastor

/**
 * <code>付款日期</code>.
 */
@property (nonatomic,strong) NSString*  currDate;

/**
 * <code>支付流水</code>.
 */
@property (nonatomic,strong) NSMutableArray* payList;

+(id) payList_class;
@end
