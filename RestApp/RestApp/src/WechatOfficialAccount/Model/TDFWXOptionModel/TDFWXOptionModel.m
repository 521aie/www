//
//  TDFWXOptionModel.m
//  RestApp
//
//  Created by Octree on 15/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXOptionModel.h"

@implementation TDFWXOptionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             @"detail" : @"description"
             };
}

- (NSString *)obtainItemId {
    
    return self._id;
}

- (NSString *)obtainItemName {
    
    return self.name;
}

- (NSString *)obtainOrignName {
    
    return nil;
}


@end
