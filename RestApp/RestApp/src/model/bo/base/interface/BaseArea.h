//
//  BaseArea.h
//  RestApp
//
//  Created by zxh on 14-4-12.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseArea : EntityObject

/**
 * <code>区域名称</code>.
 */
@property (nonatomic,retain) NSString * name;
/**
 * <code>顺序</code>.
 */
@property int sortCode;
/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString * memo;
/**
 * <code>区域代码</code>.
 */
@property (nonatomic,retain) NSString * code;

@end
