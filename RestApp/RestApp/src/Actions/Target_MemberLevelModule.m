//
//  Target_MemberLevelModule.m
//  RestApp
//
//  Created by chaiweiwei on 2016/10/31.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "Target_MemberLevelModule.h"
#import "TDFMemberLevelViewController.h"
#import "TDFMemberLevelSettingViewController.h"
#import "TDFMemberPrivilegeCardViewController.h"
#import "TDFMemberPriviegeManagerCardViewController.h"
#import "TDFMemberEditPrivilegeMemberCardViewController.h"
#import "TDFMemberCustomPrivilegeListViewController.h"
#import "TDFMemberCustomPrivilegeDetailViewController.h"
#import "TDFMemberChainLevelViewController.h"
#import "TDFMemberShopLevelManagerViewController.h"

@implementation Target_MemberLevelModule

- (UIViewController *)Action_nativeMemberLevelViewController:(NSDictionary *)params{
    TDFMemberLevelViewController *viewController = [[TDFMemberLevelViewController alloc] init];
    return viewController;
}

- (UIViewController *)Action_nativeMemberChainLevelViewController:(NSDictionary *)params {
    TDFMemberChainLevelViewController *viewController = [[TDFMemberChainLevelViewController alloc] init];
    return viewController;
}

- (UIViewController *)Action_nativeMemberLevelSettingViewController:(NSDictionary *)params {
    TDFMemberLevelSettingViewController *viewController = [[TDFMemberLevelSettingViewController alloc] init];
    viewController.levelList = params[@"levelList"];
    return viewController;
}

- (UIViewController *)Action_nativeMemberPrivilegeCardViewController:(NSDictionary *)params {
    TDFMemberPrivilegeCardViewController *VC = [[TDFMemberPrivilegeCardViewController alloc] init];
    VC.cardType = [params[@"cardType"] integerValue];
    VC.customerLevel = params[@"customerLevel"];
    VC.cardPrivilegeVo = params[@"cardPrivilegeVo"];
    
    return VC;
}

- (UIViewController *)Action_nativeMemberPriviegeManagerCardViewController:(NSDictionary *)params {
    TDFMemberPriviegeManagerCardViewController *VC = [[TDFMemberPriviegeManagerCardViewController alloc] init];
    return VC;
}

- (UIViewController *)Action_nativeMemberEditPrivilegeMemberCardViewController:(NSDictionary *)params {
    TDFMemberEditPrivilegeMemberCardViewController *VC = [[TDFMemberEditPrivilegeMemberCardViewController alloc] init];
    VC.cardType = [params[@"cardType"] integerValue];
    VC.cardPrivilegeModel = params[@"cardPrivilegeModel"];
    return VC;
}

- (UIViewController *)Action_nativeMemberCustomPrivilegeListViewController:(NSDictionary *)params {
    TDFMemberCustomPrivilegeListViewController *VC = [[TDFMemberCustomPrivilegeListViewController alloc] init];
    VC.level = [params[@"level"] integerValue];
    VC.customPrivilegeVo = params[@"customPrivilegeVo"];
    return VC;
}

- (UIViewController *)Action_nativeMemberCustomPrivilegeDetailViewController:(NSDictionary *)params {
    TDFMemberCustomPrivilegeDetailViewController *VC = [[TDFMemberCustomPrivilegeDetailViewController alloc] init];
    VC.model = params[@"model"];
    VC.lastVersion = params[@"lastVersion"];
    VC.customType = [params[@"customType"] integerValue];
    VC.customerRightId = params[@"customerRightId"];
    return VC;
}

- (UIViewController *)Action_nativeMemberShopLevelManagerViewController:(NSDictionary *)params {
    TDFMemberShopLevelManagerViewController *VC = [[TDFMemberShopLevelManagerViewController alloc] init];
    VC.branchPrivilegeList = params[@"branchPrivilegeList"];
    return VC;
}

@end
