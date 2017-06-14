//
//  TDFWXTextEditItem.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXTextEditItem.h"

@implementation TDFWXTextEditItem

- (instancetype)copyWithZone:(NSZone *)zone {

    TDFWXTextEditItem *item = [[[self class] allocWithZone:zone] init];
    
    item.requestValue = self.requestValue;
    item.title = self.title;
    item.clickBlock = self.clickBlock;
    item.shouldShow = self.shouldShow;
    item.isRequired = self.isRequired;
    
    return item;
}

@end
