//
//  BaseTailDeal.h
//  RestApp
//
//  Created by zxh on 14-4-21.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseTailDeal : EntityObject

/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>尾数值</code>.
 */
@property int val;
/**
 * <code>处理值</code>.
 */
@property int dealVal;

@end
