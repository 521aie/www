//
//  Target_BranchCompanyModule.m
//  RestApp
//
//  Created by zishu on 16/8/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_BranchCompanyModule.h"
#import "TDFBranchCompanyListViewController.h"
#import "TDFBranchCompanyEditViewController.h"

@implementation Target_BranchCompanyModule

- (UIViewController *)Action_nativeBranchCompanyListViewController:(NSDictionary *)params
{
    TDFBranchCompanyListViewController *branchCompanyListViewController =[[TDFBranchCompanyListViewController alloc]init];
    branchCompanyListViewController.delegate = params[@"delegate"];
    branchCompanyListViewController.type = [params[@"type"] integerValue];
    branchCompanyListViewController.listCallBack = params[@"listAction"];
    branchCompanyListViewController.branchCompanyList = params[@"branchCompanyList"];
    branchCompanyListViewController.branchCompanyListArr = params[@"branchCompanyListArr"];
    branchCompanyListViewController.isFromBranchEditView = [params[@"isFromBranchEditView"] boolValue];
    
    return branchCompanyListViewController;
}

- (UIViewController *)Action_nativeBranchCompanyEditViewController:(NSDictionary *)params
{
    TDFBranchCompanyEditViewController *branchCompanyEditViewController =[[TDFBranchCompanyEditViewController alloc]init];
    branchCompanyEditViewController.vo1 = params[@"branchTreeVo"];
    branchCompanyEditViewController.action = [params[@"action"] intValue];
    branchCompanyEditViewController.editCallBack = params[@"editAction"];
    
    return branchCompanyEditViewController;
}

@end
