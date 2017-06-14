//
//  BaseShopTag.h
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseShopTag : EntityObject
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>拼写</code>.
 */
@property (nonatomic,retain) NSString *spell;
/**
 * <code>标签类型</code>.
 */
@property (nonatomic,retain) NSString *code;
/**
 * <code>字典项Id</code>.
 */
@property (nonatomic,retain) NSString *dicSysItemId;
@end
