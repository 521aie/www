//
//  BaseKindPayDetail.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseKindPayDetail : BaseSyncShop
/**
 * <code>付款类型ID</code>.
 */
@property (nonatomic,retain) NSString *kindPayId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>额外信息名</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>额外信息录入方式</code>.
 */
@property short inputMode;

@end
