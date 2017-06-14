//
//  BaseTimeArrange.h
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseTimeArrange : BaseSyncShop
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString * name;
/**
 * <code>开始时间</code>.
 */
@property int beginTime;
/**
 * <code>结束时间</code>.
 */
@property int endTime;

@end
