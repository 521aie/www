//
//  EmployeeListView.m
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Role.h"
#import "UIHelper.h"
#import "Platform.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "RemoteEvent.h"
#import "DHListPanel.h"
#import "RemoteResult.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "TableEditView.h"
#import "RestConstants.h"
#import "NavigateTitle.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "SelectRolePanel.h"
#import "TDFOptionPickerController.h"
#import "EmployeeListView.h"
#import "EmployeeListPanel.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "TDFMediator+EmployeeModule.h"
#import "TDFChainService.h"
#import "YYModel.h"
#import "NSString+Estimate.h"
#import "TDFRootViewController+FooterButton.h"


#import "TDFShopEmployeeEditViewController.h"

@interface EmployeeListView()
@property (nonatomic,assign) BOOL hasRankManagement;
@end

@implementation EmployeeListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].employeeService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //判断权限,暂时不做了
//    [self judgeLimitate];
    
    self.title = @"员工管理";
    [self initNotification];
    [self initMainView];
    [self loadEmployees];
    
    
    
    // 进来就需要刷新首页 和 左侧栏
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_HOMEPAGE_AND_LEFT_MENU object:nil];
}

#pragma mark - 职级权限 or 员工权限
- (void)judgeLimitate {
    self.hasRankManagement = [[Platform Instance] lockAct:@"actionCode"];
}

#pragma 通知相关.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:EmployeeModule_Data_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headChange:) name:EmployeeModule_Role_Change object:nil];
}

- (void)initMainView
{
    [self.view addSubview:self.dhListPanel];
    [self.dhListPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
    }];
    [self.dhListPanel initDelegate:self headChange:EmployeeModule_Role_Change detailChange:EmployeeModule_Data_Change];
    [self.dhListPanel setBackgroundColor:[UIColor clearColor]];
    
    self.managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.managerButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0 -35);
    self.managerButton.bounds = CGRectMake(0, 0, 40, 70);
    [self.managerButton setImage:[UIImage imageNamed:@"Ico_Kind_Menu.png"] forState:UIControlStateNormal];
    [self.managerButton setBackgroundImage:[UIImage imageNamed:@"Ico_Crile.png"] forState:UIControlStateNormal];
    [self.managerButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -12)];
    self.managerButton.imageEdgeInsets = UIEdgeInsetsMake(-14, 0, 0, -32);
    self.managerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.managerButton setTitle:NSLocalizedString(@"职级", nil) forState:UIControlStateNormal];
    [self.managerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.managerButton addTarget:self action:@selector(selectPanel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.managerButton];

    //右侧职级管理
    selectRolePanel = [[SelectRolePanel alloc]initWithNibName:@"SelectRolePanel" bundle:nil];
     [[UIApplication sharedApplication].keyWindow addSubview:selectRolePanel.view];
    selectRolePanel.view.frame = CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT);          selectRolePanel.btnSelect.hidden = NO;
//    if (self.hasRankManagement) {//职级管理权限
//        selectRolePanel.btnSelect.hidden = NO;
//    }else {//员工权限
//        selectRolePanel.btnSelect.hidden = YES;
//    }
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

- (void)selectPanel:(UIButton *)button
{
    self.isOpen = !self.isOpen;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    
    if (isOpen == YES) {
        [self showSelectRole];
        [self animationMoveIn:self.managerButton backround:self.btnBg];
    }else
    {
        [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
        [self animationMoveOut:self.managerButton backround:self.btnBg];
    }
}

-(void)animationMoveIn:(UIView *)view backround:(UIView *)background
{
    background.hidden = NO;
    [UIView beginAnimations:@"view moveIn" context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width - selectRolePanel.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.5;
    [UIView commitAnimations];
    
}

- (void)animationMoveOut:(UIView *)view backround:(UIView *)background
{
    [UIView beginAnimations:@"view moveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    view.frame = CGRectMake(SCREEN_WIDTH - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    background.alpha = 0.0;
    [UIView commitAnimations];
    background.hidden = YES;
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.managerButton backround:self.btnBg];
    selectRolePanel.view.hidden = YES;
    [selectRolePanel.view removeFromSuperview];
    [self.btnBg removeFromSuperview];
    [self.managerButton removeFromSuperview];
    [super leftNavigationButtonAction:sender];
}
#pragma 数据加载.
- (void)loadEmployees
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = [[Platform Instance] getkey:ENTITY_ID];
    @weakify(self);
    [[TDFChainService new] queryEmployeeListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        self.detailList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[Employee class] json:data[@"data"]]];
        self.detailMap=[[NSMutableDictionary alloc] init];
        NSMutableArray* arr=nil;
        NSLog(@"data : %@",data);
        
        
        if (self.detailList!=nil && self.detailList.count>0) {
            for (Employee* employee in self.detailList) {
                arr = [self.detailMap objectForKey:employee.roleId];
                if (!arr) {
                    arr = [NSMutableArray array];
                } else {
                    [self.detailMap removeObjectForKey:employee.roleId];
                }
                [arr addObject:employee];
                if ([NSString isNotBlank:employee.roleId]) {
                    [self.detailMap setObject:arr forKey:employee.roleId];
                }
            }
        }
        
        [self loadRoles];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) loadRoles
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = [[Platform Instance] getkey:ENTITY_ID];
    @weakify(self);
    [[TDFChainService new] queryRoleListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        NSArray *roleArrs = [data objectForKey:@"data"];
        self.headList = [JsonHelper transList:roleArrs objName:@"Role"];
        self.areaList = [JsonHelper transList:roleArrs objName:@"Role"];
        NSString *isSuper = [[Platform Instance] getkey:USER_IS_SUPER];
        if ([isSuper isEqualToString:@"1"]) {
            Role *role=[[Role alloc] init];
            role.name=NSLocalizedString(@"超级管理员", nil);
            role._id=@"0";
            [self.headList insertObject:role atIndex:0];
        }
        [self pushNotification];
        
        [selectRolePanel.mainGrid reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [AlertBox show:error.localizedDescription];
        [selectRolePanel.mainGrid reloadData];
    }];
}
#pragma 实现 FooterListEvent 协议
#pragma 添加员工.
- (void)footerAddButtonAction:(UIButton *)sender
{
    if ([ObjectUtil isNotEmpty:self.areaList]) {
        @weakify(self);
        TDFShopEmployeeEditViewController *viewController = [[TDFShopEmployeeEditViewController alloc] init];
        viewController.employeeId = nil;
        viewController.roleList = self.headList;
        viewController.employeeType = TDFEmployeeAdd;
        viewController.entityId = [[Platform Instance] getkey:ENTITY_ID];
         viewController.type = @"shop";
        viewController.employeeEditCallBack = ^(BOOL orRefresh){
            @strongify(self);
            if (orRefresh) {
                [self loadEmployees];
            }
        };
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [AlertBox show:NSLocalizedString(@"请先添加职级!", nil)];
    }
}

- (void)showSortEvent
{
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"emplist"];
}

- (void)selectObj:(id<IImageDataItem>)item
{
    Employee* employee=(Employee*)item;
    @weakify(self);
    TDFShopEmployeeEditViewController *viewController = [[TDFShopEmployeeEditViewController alloc] init];
    viewController.employeeId = employee.id;
    viewController.roleList = self.headList;
    viewController.employeeType = TDFEmployeeEdit;
    viewController.entityId = [[Platform Instance] getkey:ENTITY_ID];
    viewController.type = @"shop";
    viewController.employeeEditCallBack = ^(BOOL orRefresh){
        @strongify(self);
        if (orRefresh) {
            [self loadEmployees];
        }
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSMutableArray *)transUserIds:(NSMutableArray *)ids
{
    NSMutableArray *idList = [NSMutableArray array];
    NSMutableArray *employees = [self.detailMap objectForKey:[self.currentHead obtainItemId]];
    if ([ObjectUtil isEmpty:employees]) {
        return idList;
    }
    
    for (Employee *obj in employees) {
        for (NSString *eid in ids) {
            if ([obj._id isEqualToString:eid]) {
                [idList addObject:obj.userId];
            }
        }
    }
    return idList;
}

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
}


- (void)pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [[NSNotificationCenter defaultCenter] postNotificationName:EmployeeModule_Data_Change object:dic] ;
}

#pragma sigleView
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    Role *role = (Role *)item;
    [self.dhListPanel scrocll:role];
    self.isOpen = NO;
}

- (void)closeSingleView:(NSInteger)event
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_chainRoleListViewController:[[Platform Instance] getkey:ENTITY_ID] type:@"ownshop" editCallBack:^(BOOL orRefresh) {
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x + SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
            //           self.btnBg.hidden = NO;
            
            selectRolePanel.view.frame = CGRectMake(selectRolePanel.view.frame.origin.x + SCREEN_WIDTH, selectRolePanel.view.frame.origin.y, selectRolePanel.view.bounds.size.width, selectRolePanel.view.bounds.size.height);
            self.managerButton.frame = CGRectMake(self.managerButton.frame.origin.x + SCREEN_WIDTH, self.managerButton.frame.origin.y, self.managerButton.bounds.size.width, self.managerButton.bounds.size.height);
        }];
        [self loadEmployees];
        [self showSelectRole];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBg.frame = CGRectMake(self.btnBg.frame.origin.x - SCREEN_WIDTH, self.btnBg.frame.origin.y, self.btnBg.bounds.size.width, self.btnBg.bounds.size.height);
        //           self.btnBg.hidden = NO;
        
        selectRolePanel.view.frame = CGRectMake(selectRolePanel.view.frame.origin.x - SCREEN_WIDTH, selectRolePanel.view.frame.origin.y, selectRolePanel.view.bounds.size.width, selectRolePanel.view.bounds.size.height);
        self.managerButton.frame = CGRectMake(self.managerButton.frame.origin.x - SCREEN_WIDTH, self.managerButton.frame.origin.y, self.managerButton.bounds.size.width, self.managerButton.bounds.size.height);
    }];
//    self.btnBg.hidden = YES;
//    selectRolePanel.view.hidden = YES;
//    self.managerButton.hidden = YES;
//    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
//    [self animationMoveOut:self.managerButton backround:self.btnBg];

}

#pragma 右侧职级列表，定位使用.
- (void)showSelectRole
{
    [self.view addSubview:self.btnBg];
    [selectRolePanel initDelegate:self event:11];
    [selectRolePanel loadData:self.headList];
    [XHAnimalUtil animationMoveIn:selectRolePanel.view backround:self.btnBg];
    [self animationMoveIn:self.managerButton backround:self.btnBg];
}

- (IBAction)btnBgClick:(id)sender
{
    self.isOpen = NO;
}

- (void)dataChange:(NSNotification *)notification
{
   
}

- (void)headChange:(NSNotification *)notification
{
    self.headList=notification.object;
}

- (UIButton *) btnBg
{
    if (!_btnBg) {
        _btnBg = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBg.frame = CGRectMake(0, 0, SCREEN_WIDTH - 250, SCREEN_HEIGHT);
        _btnBg.backgroundColor = [UIColor clearColor];
        [_btnBg addTarget:self action:@selector(btnBgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBg;
}

- (EmployeeListPanel *) dhListPanel
{
    if (!_dhListPanel) {
        _dhListPanel = [[EmployeeListPanel alloc] init];
        _dhListPanel.backgroundColor = [UIColor clearColor];
    }
    return _dhListPanel;
}

@end

