//
//  Target_MemberLevelModule.h
//  RestApp
//
//  Created by chaiweiwei on 2016/10/31.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_MemberLevelModule : NSObject

- (UIViewController *)Action_nativeMemberLevelViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberChainLevelViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberLevelSettingViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberPrivilegeCardViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberPriviegeManagerCardViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberEditPrivilegeMemberCardViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberCustomPrivilegeListViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberCustomPrivilegeDetailViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeMemberShopLevelManagerViewController:(NSDictionary *)params;

@end
