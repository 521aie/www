//
//  BaseKindMenuStyleOption.h
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseKindMenuStyleOption : Base

/**
* <code>所属系统类型ID</code>.
*/
@property (nonatomic,retain) NSString *systemTypeId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>是否可使用</code>.
 */
@property short isUsed;
/**
 * <code>效果图</code>.
 */
@property (nonatomic,retain) NSString *attachmentId;
/**
 * <code>风格用途</code>.
 */
@property short usage;
/**
 * <code>风格名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>编码</code>.
 */
@property (nonatomic,retain) NSString *code;
/**
 * <code>每页显示条数(用来处理分页)</code>.
 */
@property int pageSize;

@end
