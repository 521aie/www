//
//  TDFWXMarketingMenuItem.m
//  RestApp
//
//  Created by Octree on 11/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXMarketingMenuItem.h"
#import "UIColor+Hex.h"

@implementation TDFWXMarketingMenuItem


+ (instancetype)itemWithTitle:(NSString *)title detail:(NSString *)detail badge:(NSString *)badge icon:(UIImage *)icon permitted:(BOOL)permitted {
    
    return [[[self class] alloc] initWithTitle:title detail:detail badge:badge icon:icon permitted:permitted];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail badge:(NSString *)badge icon:(UIImage *)icon permitted:(BOOL)permitted {
    
    if (self = [super init]) {
        
        _title = title;
        _detail = detail;
        _badge = badge;
        _icon = icon;
        _badgeColor = [UIColor colorWithHeX:0xCC0000];
        _permitted = permitted;
    }
    
    return self;
}


- (BOOL)badgeHidden {
    
    return self.badge == nil;
}

@end
