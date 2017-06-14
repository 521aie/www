//
//  ShopVO+YYModel.m
//  RestApp
//
//  Created by Octree on 10/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopVO+YYModel.h"

@implementation ShopVO (YYModel)

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}


@end


@implementation BranchShopVo (YYModel)

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"shopVoList" : [ShopVO class],
             };
}


@end
