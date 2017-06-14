//
//  chainRoleListView.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "chainRoleListView.h"
#import "chainRoleEditView.h"
#import "TDFChainService.h"
#import "XHAnimalUtil.h"
#import "FooterListView.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "Role.h"
#import "TDFRootViewController+FooterButton.h"

@implementation chainRoleListView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.footView removeFromSuperview];
    [self initNotification];
    self.needHideOldNavigationBar = YES;
    self.title = NSLocalizedString(@"职级", nil);
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    [self initDelegate:self event:@"role" title:NSLocalizedString(@"职级", nil) foots:nil];

    [self loadChainOrBranchRoles:self.entityId type:self.type];

    [self.footView showHelp:NO];
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"关闭", nil)];
    if ([self.type isEqualToString:@"ownshop"]) {
        [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
    }else{
        [self generateFooterButtonWithTypes: TDFFooterButtonTypeAdd];
    }
}
#pragma 数据加载(连锁、分公司)
-(void)loadChainOrBranchRoles:(NSString *)entityId type:(NSString *)type
{
    self.type = type;
    self.entityId = entityId;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = entityId;
    
    @weakify(self);
    [[TDFChainService new] queryRoleListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSArray *list = [data objectForKey:@"data"];
        self.roleList=[JsonHelper transList:list objName:@"Role"];
        [self reload:self.roleList error:nil];
        NSMutableArray* allRoles=[NSMutableArray array];
        NSString* isSuper=[[Platform Instance] getkey:USER_IS_SUPER];
        if ([isSuper isEqualToString:@"1"]) {
            Role* role=[[Role alloc] init];
            role.name=NSLocalizedString(@"超级管理员", nil);
            role._id=@"0";
            [allRoles insertObject:role atIndex:0];
        }
        [allRoles addObjectsFromArray:self.roleList];
        [self reloadRoles:self.roleList];
        [[NSNotificationCenter defaultCenter] postNotificationName:EmployeeModule_Role_Change object:allRoles] ;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)reloadRoles:(NSMutableArray*)roles
{
    self.roleList=roles;
    [self.mainGrid reloadData];
}

- (void)leftNavigationButtonAction:(id)sender{
    self.roleEditCallBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    Role* editObj=(Role*)obj;
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_chainRoleEditViewController:editObj action:ACTION_CONSTANTS_EDIT isContinue:NO entityId:self.entityId type:self.type editCallBack:^(BOOL orFresh) {
        @strongify(self);
        if (orFresh) {
             [self loadChainOrBranchRoles:self.entityId type:self.type];
        }
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)footerAddButtonAction:(UIButton *)sender
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_chainRoleEditViewController:nil action:ACTION_CONSTANTS_ADD isContinue:NO entityId:self.entityId type:self.type editCallBack:^(BOOL orFresh) {
        @strongify(self);
        if (orFresh) {
            [self loadChainOrBranchRoles:self.entityId type:self.type];
        }
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma 消息处理部分.
-(void) initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:EmployeeModule_Data_Change object:nil];
}

-(void) dataChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.datas=[dic objectForKey:@"head_list"];
    [self.mainGrid reloadData];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"emprole"];
}

@end
