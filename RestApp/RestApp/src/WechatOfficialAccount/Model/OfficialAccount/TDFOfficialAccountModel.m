//
//  TDFOfficialAccountModel.m
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOfficialAccountModel.h"


@implementation TDFOfficialAccountPermissionModel

/**
 *  YYModel
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}

@end

@implementation TDFOfficialAccountModel

- (instancetype)copyWithZone:(NSZone *)zone {
    
    TDFOfficialAccountModel *model = [[[self class] allocWithZone:zone] init];
    
    model.name = self.name;
    model.type = self.type;
    model.avatarUrl = self.avatarUrl;
    model.hasPermission = self.hasPermission;
    model.wxPermissions = self.wxPermissions;
    model.storeNum = self.storeNum;
    
    return model;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             @"detail" : @"description"
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"wxPermissions" : [TDFOfficialAccountPermissionModel class],
             };
}

- (NSString *)obtainItemId {
    
    return self._id;
}

- (NSString *)obtainItemName {
    
    return self.name;
}

- (NSString *)obtainOrignName {

    return self.name;
}

@end
