//
//  BaseMake.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseMake : BaseSyncShop

/**
 * <code>烧法名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;
/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString *memo;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>编码</code>.
 */
@property (nonatomic,retain) NSString *code;

@end
