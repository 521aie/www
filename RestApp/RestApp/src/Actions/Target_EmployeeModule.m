//
//  Target_EmployeeModule.m
//  RestApp
//
//  Created by zishu on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_EmployeeModule.h"
#import "SelectBatchRoleView.h"
#import "EmployeeListView.h"
#import "EditPassView.h"
#import "RoleEditView.h"
#import "SystemUtil.h"

@implementation Target_EmployeeModule

- (UIViewController *)Action_nativeEmployeeListViewController:(NSDictionary *)params {
    
    EmployeeListView *employeeListViewController = [[EmployeeListView alloc] init];
    return employeeListViewController;
    
}

- (UIViewController *)Action_nativeEditPassViewController:(NSDictionary *)params {
    EditPassView *editPassView = [[EditPassView alloc] initWithNibName:@"EditPassView" bundle:nil];
    editPassView.user = params[@"userVo"];
    editPassView.employee = params[@"employeeVo"];
    return editPassView;
}

- (UIViewController *)Action_nativeRoleEditViewController:(NSDictionary *)params{
    RoleEditView *roleEditView = [[RoleEditView alloc] init];
    roleEditView.role = params[@"roleTemp"];
    roleEditView.action = [params[@"action"] intValue];
    roleEditView.isContinue = [params[@"isContinue"] boolValue];
    roleEditView.roleEditCallBack = params[@"editAction"];
    return roleEditView;
}

- (UIViewController *)Action_nativeSelectBatchRoleViewController:(NSDictionary *)params
{
    SelectBatchRoleView * selectBatchRoleView = [[SelectBatchRoleView alloc] init];
    selectBatchRoleView.event = [params[@"event"] integerValue];
    selectBatchRoleView.delegate = params[@"delegate"];
    selectBatchRoleView.title = params[@"titleName"];
    selectBatchRoleView.nodeList = params[@"nodeList"];
    return selectBatchRoleView;
}

@end
