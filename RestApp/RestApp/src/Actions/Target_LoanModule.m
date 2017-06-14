//
//  Target_LoanModule.m
//  RestApp
//
//  Created by zishu on 16/8/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_LoanModule.h"
#import "TDFXinhuoLoanViewController.h"
#import "TDFLoanWebViewController.h"
#import "TDFLoanNoteViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "Platform.h"
#import "RestConstants.h"
#import "AlertBox.h"

@implementation Target_LoanModule

- (UIViewController *)Action_nativeLoanListViewController:(NSDictionary *)params
{
    // 判断权限
    BOOL isSuperAdmin = [[[Platform Instance] getkey:USER_IS_SUPER] isEqualToString:@"1"];
    BOOL isHangzhouLocation = [[[Platform Instance] getkey:CITY_ID] isEqualToString:@"78"];
    
    if (!isSuperAdmin) {
//        UINavigationController *rootNavigationController = (UINavigationController *)TDF_ROOT_NAVIGATION_CONTROLLER;
//        [(TDFRootViewController *)(rootNavigationController.topViewController) showMessageWithTitle:NSLocalizedString(@"此功能目前仅限于超级管理员或管理员使用", nil) message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        [AlertBox show:NSLocalizedString(@"此功能目前仅限于超级管理员或管理员使用", nil)];
        return nil;
    }
    
    if (!isHangzhouLocation) {
//        UINavigationController *rootNavigationController = (UINavigationController *)TDF_ROOT_NAVIGATION_CONTROLLER;
//        [(TDFRootViewController *)(rootNavigationController.topViewController) showMessageWithTitle:NSLocalizedString(@"此功能目前仅限于杭州地区使用，请先去“顾客端设置-店家资料”中设置营业地址，审核通过后方可使用", nil) message:nil cancelTitle:NSLocalizedString(@"我知道了", nil)];
        [AlertBox show:NSLocalizedString(@"此功能目前仅限于杭州地区使用，请先去“店家资料”中设置营业地址，审核通过后方可使用", nil)];
        return nil;
    }
    
    TDFXinhuoLoanViewController *loanViewController = [[TDFXinhuoLoanViewController alloc] init];
    return loanViewController;
}

- (UIViewController *)Action_nativeLoanWebViewController:(NSDictionary *)params
{
    TDFLoanWebViewController *loanWebViewController = [[TDFLoanWebViewController alloc] init];
    loanWebViewController.h5Url = params[@"h5Url"];
    return loanWebViewController;
}

- (UIViewController *)Action_nativeLoanNoteViewController:(NSDictionary *)params
{
    TDFLoanNoteViewController *loanNoteViewController = [[TDFLoanNoteViewController alloc] init];
    loanNoteViewController.loanCompanyId = params[@"loanCompanyId"];
    loanNoteViewController.loanCompanyName = params[@"loanCompanyName"];
    loanNoteViewController.h5Url = params[@"h5Url"];
    return loanNoteViewController;
}
@end
