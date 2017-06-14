//
//  Target_ChainEmployeeModule.m
//  RestApp
//
//  Created by zishu on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_ChainEmployeeModule.h"
#import "TDFChainMemberSearchViewController.h"
#import "chainEmployeeListView.h"
#import "chainRoleListView.h"
#import "chainSelectListView.h"
#import "chainEditPassView.h"
#import "chainRoleEditView.h"
#import "SelectBatchRoleView.h"
#import "SystemUtil.h"

@implementation Target_ChainEmployeeModule

- (UIViewController *)Action_nativeChainEmployeeListViewController:(NSDictionary *)params {
    chainEmployeeListView *chainEmployeeListViewController = [[chainEmployeeListView alloc] init];
    return chainEmployeeListViewController;
}


- (UIViewController *)Action_nativeChainMemberSearchViewController:(NSDictionary *)params {
    TDFChainMemberSearchViewController *chainMemberSearchViewController = [[TDFChainMemberSearchViewController alloc] init];
    chainMemberSearchViewController.memberItemSelectedCallBack = params[@"editAction"];
    return chainMemberSearchViewController;
}

- (UIViewController *)Action_nativeChainRoleListViewController:(NSDictionary *)params
{
    chainRoleListView *roleListView=[[chainRoleListView alloc] init];
    roleListView.entityId = params[@"entityId"];
    roleListView.type = params[@"type"];
    roleListView.roleEditCallBack = params[@"editAction"];
    return roleListView;
}

- (UIViewController *)Action_nativeChainSelectListViewController:(NSDictionary *)params
{
    chainSelectListView *chainSelectView=[[chainSelectListView alloc] init];
    chainSelectView.oldArrs = params[@"oldArrs"];
    chainSelectView.userId = params[@"userId"];
    chainSelectView.delegate = params[@"delegate"];
    chainSelectView.Istarget = [params[@"istarget"] integerValue];
    chainSelectView.currentAction = [params[@"currentAction"] integerValue];
    chainSelectView.headList = params[@"headList"];
    chainSelectView.employeeId = params[@"employeeId"];
    chainSelectView.detailMap = params[@"detailMap"];
    chainSelectView.entityId = params[@"entityId"];
    chainSelectView.employeeEditCallBack = params[@"editAction"];
    return chainSelectView;
}

- (UIViewController *)Action_nativeChainEditPassViewController:(NSDictionary *)params {
    chainEditPassView *editPassView = [[chainEditPassView alloc] initWithNibName:@"EditPassView" bundle:nil];
    editPassView.user = params[@"userVo"];
    editPassView.employee = params[@"employeeVo"];
    return editPassView;
}

- (UIViewController *)Action_nativeChainRoleEditViewController:(NSDictionary *)params
{
    chainRoleEditView *roleEditView = [[chainRoleEditView alloc] init];
    roleEditView.role = params[@"roleTemp"];
    roleEditView.action = [params[@"action"] intValue];
    roleEditView.isContinue = [params[@"isContinue"] boolValue];
    roleEditView.entityId = params[@"entityId"];
    roleEditView.type = params[@"type"];
    roleEditView.roleEditCallBack = params[@"editAction"];
    return roleEditView;
}

- (UIViewController *)Action_nativeChainSelectBatchRoleViewController:(NSDictionary *)params
{
    SelectBatchRoleView * selectBatchRoleView = [[SelectBatchRoleView alloc] init];
    selectBatchRoleView.event = [params[@"event"] integerValue];
    selectBatchRoleView.delegate = params[@"delegate"];
    selectBatchRoleView.title = params[@"titleName"];
    selectBatchRoleView.nodeList = params[@"nodeList"];
    return selectBatchRoleView;
}

@end
