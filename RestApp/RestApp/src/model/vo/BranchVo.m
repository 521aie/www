//
//  BranchVo.m
//  RestApp
//
//  Created by zishu on 16/7/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BranchVo.h"
#import "ObjectUtil.h"
@implementation BranchVo

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.parentName = [ObjectUtil getStringValue:dic key:@"parentName"];
        self.userName = [ObjectUtil getStringValue:dic key:@"userName"];
        self.startPwd = [ObjectUtil getStringValue:dic key:@"startPwd"];
        self.branchId = [ObjectUtil getStringValue:dic key:@"branchId"];
        self.branchCode = [ObjectUtil getStringValue:dic key:@"branchCode"];
        self.branchName = [ObjectUtil getStringValue:dic key:@"branchName"];
        self.parentEntityId = [ObjectUtil getStringValue:dic key:@"parentEntityId"];
        self.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        self.brandEntityId = [ObjectUtil getStringValue:dic key:@"brandEntityId"];
        self.tel = [ObjectUtil getStringValue:dic key:@"tel"];
        self.email = [ObjectUtil getStringValue:dic key:@"email"];
        self.address = [ObjectUtil getStringValue:dic key:@"address"];
        self.attributeExt = [ObjectUtil getStringValue:dic key:@"attributeExt"];
        self.contacts = [ObjectUtil getStringValue:dic key:@"contacts"];
    }
    return self;
}
@end
