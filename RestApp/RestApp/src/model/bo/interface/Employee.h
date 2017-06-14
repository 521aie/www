//
//  Employee.h
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseEmployee.h"
#import "IImageDataItem.h"

@interface Employee : BaseEmployee<IImageDataItem>

/** 用户ID. */
@property (nonatomic,retain) NSString *userId;

/** 用户名 **/
@property (nonatomic,retain) NSString *userName;

/** 职级名称 **/
@property (nonatomic,retain) NSString *roleName;

/** 职级ID **/
@property (nonatomic,retain) NSString *roleId;

/** 服务器 **/
@property (nonatomic,retain) NSString *server;

/** 本地路径 **/
@property (nonatomic,retain) NSString *path;


/** 身份证正面服务器 **/
@property (nonatomic,retain) NSString *frontServer;

/** 身份证正面本地路径 **/
@property (nonatomic,retain) NSString *frontPath;


/** 身份证背面服务器 **/
@property (nonatomic,retain) NSString *backServer;

/** 身份证背面本地路径 **/
@property (nonatomic,retain) NSString *backPath;
@end
