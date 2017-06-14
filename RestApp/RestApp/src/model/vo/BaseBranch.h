//
//  BaseBranch.h
//  RestApp
//
//  Created by zishu on 16/7/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Base.h"

@interface BaseBranch : Base
// 分公司ID
@property (nonatomic, strong) NSString *branchId;

// 分公司编码
@property (nonatomic, strong) NSString *branchCode;

// 分公司名称
@property (nonatomic, strong) NSString *branchName;

// 父级单位ID
@property (nonatomic, strong) NSString *parentEntityId;

// 实体ID
@property (nonatomic, strong) NSString *entityId;

// 所属连锁的实体ID
@property (nonatomic, strong) NSString *brandEntityId;

// 联系人
@property (nonatomic, strong) NSString *contacts;

// 联系电话
@property (nonatomic, strong) NSString *tel;

// 电子邮箱
@property (nonatomic, strong) NSString *email;

// 地址
@property (nonatomic, strong) NSString *address;

// 扩展属性(HashMap-JSON格式)
@property (nonatomic, strong) NSString *attributeExt;

@end
