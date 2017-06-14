//
//  BaseConfigItemOption.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseConfigItemOption : Base

/**
 * <code>参数项ID</code>.
 */
@property (nonatomic,retain) NSString *configItemId;
/**
 * <code>顺序码</code>.
 */
@property int sortCode;
/**
 * <code>说明</code>.
 */
@property (nonatomic,retain) NSString *memo;
/**
 * <code>选项值</code>.
 */
@property (nonatomic,retain) NSString *value;
/**
 * <code>所属系统类型ID</code>.
 */
@property (nonatomic,retain) NSString *systemTypeId;

@end
