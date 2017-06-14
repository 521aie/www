//
//  RoleEditView.h
//  RestApp
//
//  Created by zxh on 14-4-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "MultiCheckHandle.h"
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "RemoteResult.h"
#import "ActionDetailTable.h"
#import "ZmTableCell.h"
#import "TDFRootViewController.h"
#import "Role.h"
#import "Action.h"
#import "AlertBox.h"
#import "TreeNode.h"
#import "UIHelper.h"
#import "ItemTitle.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"
#import "TreeBuilder.h"
#import "ViewFactory.h"
#import "RemoteEvent.h"
#import "ActionRender.h"
#import "EditItemText.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "NavigateTitle.h"
#import "MBProgressHUD.h"
#import "RoleActionCell.h"
#import "RoleActionHead.h"
#import "FooterListView.h"
#import "NSString+Estimate.h"
#import "MultiHeadCheckView.h"
#import "EmployeeModuleEvent.h"
#import "SelectBatchRoleView.h"
#import "UIView+Sizes.h"
#import "Platform.h"
#import "RestConstants.h"
#import "TDFRootViewController+FooterButton.h"

@class EmployeeModule,EmployeeService,NavigateTitle2,EditItemText;
@class ItemTitle;
@class Role,TreeNode;
@interface RoleEditView : TDFRootViewController<MultiCheckHandle,UIActionSheetDelegate,ISampleListEvent>
{
    EmployeeModule *parent;
    
    EmployeeService *service;
}

@property (nonatomic,copy) void (^roleEditCallBack)(BOOL orRefresh);
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) EditItemText *txtName;
@property (nonatomic, strong) ItemTitle *titleRest;
@property (nonatomic, strong) ItemTitle *titleCash;
@property (nonatomic, strong) ItemTitle *branchTitle;
@property (nonatomic, strong) ItemTitle *titleCashShop;


@property (nonatomic, strong) ActionDetailTable* restGrid;
@property (nonatomic, strong) ActionDetailTable *branchTab;
@property (nonatomic, strong) ActionDetailTable* cashGrid;
@property (nonatomic, strong) ActionDetailTable *cashShopGrid;

@property (nonatomic, strong) UIView *branchView;
@property (nonatomic, strong) UIView *cashShopView;
@property (nonatomic, strong) UIView *chainView;

@property (nonatomic, strong) UIButton *btnDel;
@property (nonatomic, strong) NSMutableArray *actionList;
@property (nonatomic, strong) NSMutableArray *restNodes;
@property (nonatomic, strong) NSMutableArray *cashNodes;
@property (nonatomic, strong) NSMutableArray *branchNodes;
@property (nonatomic, strong) NSMutableArray *managerNodes1;
@property (nonatomic, strong) TreeNode* currTreeNode;
@property (nonatomic, strong) NSString* continueEvent;

@property (nonatomic, strong) Role* role;
@property (nonatomic) int action;
@property (nonatomic) bool isContinue;

- (void)save;

- (BOOL)hasChanged;
- (void)continueAdd:(NSString *)event;
- (void)fillModel;
- (void)reSetCheck:(NSMutableArray*)nodes items:(NSMutableArray*)items;
- (void)processTreeNode:(NSMutableArray *)nodes grid:(ActionDetailTable *)grid;
- (void)saveRelation;

- (void)loadActions;

- (void)clearDo;

@end
