//
//  UIViewController+HUD.m
//  RestApp
//
//  Created by Octree on 7/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@implementation UIViewController (HUD)

const void * kTDFHUDKey = "kTDFHUDKey";

- (void)showErrorMessage:(NSString *)message {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:message  preferredStyle:(UIAlertControllerStyleAlert)];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:avc animated:YES completion:nil];
}

- (void)showHUBWithText:(NSString *)text {
    
    self.messageHud.mode = MBProgressHUDModeIndeterminate;
    self.messageHud.labelText = text;
    [self.view addSubview:self.messageHud];
    [self.messageHud show:YES];
}

- (void)showSuccessMessage:(NSString *)message duration:(NSTimeInterval)duration {

    self.messageHud.mode = MBProgressHUDModeCustomView;
    self.messageHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    self.messageHud.labelText = message;
    [self.view addSubview:self.messageHud];
    [self.messageHud show:YES];
    [self.messageHud hide:YES afterDelay:duration];
}


- (void)dismissHUD {

    [self.messageHud hide:YES];
}

#pragma mark - Accessor

- (MBProgressHUD *)messageHud {

    MBProgressHUD *hud = objc_getAssociatedObject(self, kTDFHUDKey);
    if (!hud) {
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        objc_setAssociatedObject(self, kTDFHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return hud;
}

@end
