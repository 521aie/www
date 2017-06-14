//
//  BaseKindPayDetailOption.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseKindPayDetailOption : BaseSyncShop
/**
 * <code>付款方式名称</code>.
 */
@property (nonatomic,retain) NSString *kindPayId;
/**
 * <code>对应的额外信息ID</code>.
 */
@property (nonatomic,retain) NSString *kindPayDetailId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>选项名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;

@end
