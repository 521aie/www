//
//  TDFWXGroupModel.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXGroupModel.h"

@implementation TDFWXGroupModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             };
}

- (NSString *)obtainItemId {
    
    return self._id;
}

- (NSString *)obtainItemName {

    return [NSString stringWithFormat:@"%@(共%@人)", self.name, [self prettyReadingNumber:self.memberCount]];
}

- (NSString *)obtainOrignName {

    return nil;
}

- (NSString *)prettyReadingNumber:(NSInteger)num {
    
    if (num >= 100000) {
        
        CGFloat anum = num / 10000.0;
        return [NSString stringWithFormat:@"%.2f万", anum];
    } else {
        
        return [NSString stringWithFormat:@"%zd", num];
    }
}

@end
