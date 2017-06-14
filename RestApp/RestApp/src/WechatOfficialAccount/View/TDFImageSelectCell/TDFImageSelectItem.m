//
//  TDFImageSelectItem.m
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFImageSelectItem.h"

@implementation TDFImageSelectItem

- (BOOL)isShowTip {
    
    NSParameterAssert(self.preValue == nil || [self.preValue isKindOfClass:[NSString class]]);
    if ([self.requestValue length] == 0 && [self.preValue length] == 0) {
        
        return NO;
    }
    return ![self.requestValue isEqualToString:self.preValue];
}

@end
