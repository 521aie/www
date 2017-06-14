//
//  NSString+Sino.m
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSString+Sino.h"

@implementation NSString (Sino)

- (NSUInteger)tdf_sinoCharactorCount {

    NSUInteger a = self.length;
    NSUInteger b = strlen(self.UTF8String);
    return (b - a) / 2;
}


- (NSUInteger)tdf_asciiCharactorCount {

    NSUInteger a = self.length;
    NSUInteger b = strlen(self.UTF8String);
    return (3 * a - b) / 2;
}

- (NSUInteger)tdf_byteLength {

    return self.tdf_sinoCharactorCount * 2 + self.tdf_asciiCharactorCount;
}

- (NSString *)tdf_substringWithByteLength:(NSInteger)length {

    if (length <= 0) {
        return @"";
    }
    
    NSString *string = self;
    
    while (string.tdf_byteLength > length) {
        
        string = [string substringToIndex:string.length - 1];
    }
    return string;
}
@end
