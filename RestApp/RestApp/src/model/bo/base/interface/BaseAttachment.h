//
//  BaseAttachment.h
//  RestApp
//
//  Created by zxh on 14-6-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseAttachment : Base

/**
 * <code>路径</code>.
 */
@property (nonatomic,retain) NSString *path;
/**
 * <code>验证码</code>.
 */
@property (nonatomic,retain) NSString *validateCode;
/**
 * <code>主表名</code>.
 */
@property (nonatomic,retain) NSString *tableName;
/**
 * <code>主表Id</code>.
 */
@property (nonatomic,retain) NSString *mainId;
/**
 * <code>所在服务器</code>.
 */
@property (nonatomic,retain) NSString *server;

@end
