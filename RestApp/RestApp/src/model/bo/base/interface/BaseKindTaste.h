//
//  BaseKindTaste.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseKindTaste : EntityObject
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>口味</code>.
 */
@property (nonatomic,retain) NSString *name;
@end
