//
//  KindPayDayStatVO.h
//  RestApp
//
//  Created by zxh on 14-11-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface KindPayDayStatVO : Jastor

/**
 * <code>付款方式Id</code>.
 */
@property (nonatomic,strong) NSString*  kindPayId;
/**
 * <code>付款方式名称</code>.
 */
@property (nonatomic,strong) NSString*  name;
/**
 * <code>是否计入销售额</code>.
 */
@property short isInclude;

/**
 * <code>金额</code>.
 */
@property double fee;

/**
 * <code>消费流水</code>.
 */
@property (nonatomic,strong) NSString*  currDate;

@end
