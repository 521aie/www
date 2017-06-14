//
//  TDFFansAnalyzeModel.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFFansAnalyzeModel.h"

@implementation TDFFansAnalyzeItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             };
}

- (NSString *)pieDescription {
    
    return [NSString stringWithFormat:@"%.2f%%", self.ratio * 100];
}
- (NSString *)highlightDescription {
    
    return self.detail;
}
- (NSString *)commentTitle {
    
    return self.name;
}
- (NSString *)commentDescription {
    
    return [NSString stringWithFormat:@"共%@人", [self prettyReadingNumber: self.count]];
}
- (NSString *)commentRatioDescription {
    
    return [NSString stringWithFormat:@"占比%.2f%%", self.ratio * 100];
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

@implementation TDFFansAnalyzeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{ @"parts" : [TDFFansAnalyzeItemModel class] };
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
