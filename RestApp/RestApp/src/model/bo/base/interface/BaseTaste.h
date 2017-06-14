//
//  BaseTaste.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSyncShop.h"

@interface BaseTaste : BaseSyncShop

/**
 * <code>顺序码</code>.
 */
@property int sortCode;

@property (nonatomic,retain) NSString *kindTasteId;
/**
 * <code>口味</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;

@end
