//
//  DataBarItem.m
//  RestApp
//
//  Created by Shaojianqing on 15/4/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DataBarItem.h"

@implementation DataBarItem

- (id)initWithData:(NSString *)label barColor:(UIColor *)color quantity:(NSInteger)quantity
{
    self = [super init];
    if (self) {
        self.label = label;
        self.barColor = color;
        self.quantity = quantity;
    }
    return self;
}

@end
