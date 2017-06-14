//
//  TDFShopSelectionItem.m
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopSelectionItem.h"

@implementation TDFShopSelectionItem

- (BOOL)isShowTip {

    if (!self.canSelected) {
        return NO;
    }
    
    return [self.preValue boolValue] != [self.requestValue boolValue];
}

@end
