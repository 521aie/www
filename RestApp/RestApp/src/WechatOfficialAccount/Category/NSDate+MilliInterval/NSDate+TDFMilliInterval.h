//
//  NSDate+TDFMilliInterval.h
//  RestApp
//
//  Created by Octree on 10/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UInt64 TDFMilliTimeInterval;

@interface NSDate (TDFMilliInterval)

+ (instancetype)dateWithMilliIntervalSince1970:(TDFMilliTimeInterval)ms;
- (TDFMilliTimeInterval)milliInterval;

@end
