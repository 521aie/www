//
//  BranchVo.h
//  RestApp
//
//  Created by zishu on 16/7/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseBranch.h"

@interface BranchVo : BaseBranch
/**
 * 父级单位名称
 */
@property (nonatomic, strong) NSString *parentName;
/**
 * 管理员用户名
 */
@property (nonatomic, strong) NSString *userName;
/**
 * 初始化密码，不变的密码
 */
@property (nonatomic, strong) NSString *startPwd;

- (id)initWithDictionary:(NSDictionary *)dic;
@end
