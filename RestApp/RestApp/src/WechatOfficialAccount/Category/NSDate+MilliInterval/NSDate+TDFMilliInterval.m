//
//  NSDate+TDFMilliInterval.m
//  RestApp
//
//  Created by Octree on 10/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSDate+TDFMilliInterval.h"

@implementation NSDate (TDFMilliInterval)

+ (instancetype)dateWithMilliIntervalSince1970:(TDFMilliTimeInterval)ms {

    return [[self class] dateWithTimeIntervalSince1970:ms / 1000.0];
}
- (TDFMilliTimeInterval)milliInterval {

    return (NSInteger)(self.timeIntervalSince1970 * 1000);
}

@end
