//
//  BaseRoleAction.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"

@interface BaseRoleAction : EntityObject

/**
 * <code>权限ID</code>.
 */
@property (nonatomic,retain) NSString *actionId;
/**
 * <code>角色ID</code>.
 */
@property (nonatomic,retain) NSString *roleId;
/**
 * <code>系统分类</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;

@end
