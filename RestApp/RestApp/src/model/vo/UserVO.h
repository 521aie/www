//
//  UserVO.h
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "User.h"
#import "INameItem.h"
#import "INameValueItem.h"

@interface UserVO : User<INameValueItem,INameItem>

/**
 * <code>员工名称</code>.
 */
@property (nonatomic,retain) NSString *employeeName;
/**
 * 创建分公司生成的分公司编码
 */
@property (nonatomic,retain) NSString *branchCode;

@property (nonatomic,retain) NSString *userName;

@end
