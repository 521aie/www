//
//  EmployeeListView.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Role.h"
#import <UIKit/UIKit.h>
#import "TableIndexView.h"
#import "INavigateEvent.h"
#import "EmployeeService.h"
#import "SingleCheckHandle.h"
#import "DHListSelectHandle.h"
#import "OptionPickerClient.h"
#import "TDFRootViewController.h"

@class NavigateTitle, SelectRolePanel;
@class EmployeeListPanel, DHListPanel, MBProgressHUD;
@interface EmployeeListView : TDFRootViewController<INavigateEvent,SingleCheckHandle,DHListSelectHandle>
{
    EmployeeService *service;
    
    SelectRolePanel *selectRolePanel;
}


@property (nonatomic, strong) UIButton *managerButton;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) EmployeeListPanel *dhListPanel;
@property (nonatomic, strong) UIButton *btnBg;

@property (nonatomic, strong) NSMutableArray *areaList;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableDictionary *employeeMap;
@property (nonatomic, strong) id<INameValueItem> currentHead;
@property (nonatomic, assign) NSInteger action;

- (void)loadEmployees;

- (void)showSelectRole;

- (IBAction)btnBgClick:(id)sender;

@end
