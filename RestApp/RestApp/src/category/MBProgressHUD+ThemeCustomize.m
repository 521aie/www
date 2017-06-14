//
//  MBProgressHUD+ThemeCustomize.m
//  RestApp
//
//  Created by tripleCC on 3/27/17.
//  Copyright © 2017 杭州迪火科技有限公司. All rights reserved.
//
#import <objc/runtime.h>
#import "MBProgressHUD+ThemeCustomize.h"

@implementation MBProgressHUD (ThemeCustomize)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originSelector = NSSelectorFromString(@"initWithView:");
        SEL newSelector = NSSelectorFromString(@"tdf_initWithView:");
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        
        BOOL addMethodSuccess = class_addMethod(class, originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (addMethodSuccess) {
            class_replaceMethod(class, newSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, newMethod);
        }
    });
}

- (instancetype)tdf_initWithView:(UIView *)view {
    MBProgressHUD *hud = [self tdf_initWithView:view];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    return hud;
}
@end
