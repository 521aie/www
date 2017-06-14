//
//  Target_EmployeeModule.h
//  RestApp
//
//  Created by zishu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_EmployeeModule : NSObject

//单店/门店员工列表:zishu
- (UIViewController *)Action_nativeEmployeeListViewController:(NSDictionary *)params;

//火掌柜单店/门店员工密码修改页面:zishu
- (UIViewController *)Action_nativeEditPassViewController:(NSDictionary *)params;

//单店/门店员工职级详情:zishu
- (UIViewController *)Action_nativeRoleEditViewController:(NSDictionary *)params;

//单店/门店员工职级权限选择页面:zishu
- (UIViewController *)Action_nativeSelectBatchRoleViewController:(NSDictionary *)params;
@end
