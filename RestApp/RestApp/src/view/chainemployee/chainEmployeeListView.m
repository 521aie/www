//
//  chainEmployeeListView.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "Role.h"
#import "Employee.h"
#import "UIHelper.h"
#import "Platform.h"
#import "AlertBox.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "TableEditView.h"
#import "RestConstants.h"

#import "ServiceFactory.h"

#import "SelectRolePanel.h"

#import "TDFOptionPickerController.h"
#import "EmployeeListPanel.h"
#import "chainEmployeeListView.h"
#import "FormatUtil.h"
#import <libextobjc/EXTScope.h>
#import "TDFChainService.h"
#import "NSString+Estimate.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "TDFRootViewController+FooterButton.h"

#import "TDFShopEmployeeEditViewController.h"
#import "TDFChainEmployeeEditViewController.h"
@implementation chainEmployeeListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    service = [ServiceFactory Instance].employeeService;
    self.select = NO;
    [self initNotification];
    [self initMainView];
    self.entityId = @"";
    self.name = @"";
    self.type = @"";
    [self loadRoles:NO];
    [self getType];
    
    // 进来就需要刷新首页 和 左侧栏
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_HOMEPAGE_AND_LEFT_MENU object:nil];
}

- (EmployeeListPanel *) dhListPanel
{
    if (!_dhListPanel) {
        _dhListPanel = [[EmployeeListPanel alloc] init];
        _dhListPanel.backgroundColor = [UIColor clearColor];
    }
    return _dhListPanel;
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

- (UIButton *) filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _filterBtn.backgroundColor = [UIColor clearColor];
        [_filterBtn addTarget:self action:@selector(filtBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setBackgroundImage:[UIImage imageNamed:@"ico_type_category.png"] forState:UIControlStateNormal];
        [_filterBtn setTitle:NSLocalizedString(@"职级", nil) forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _filterBtn.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT /2.0 - 35);
        _filterBtn.bounds = CGRectMake(0, 0, 40, 70);
        [_filterBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
        [_filterBtn setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, -25)];
    }
    return _filterBtn;
}


#pragma navigateBar

- (void)reSizeShopLbl
{
    self.title = [FormatUtil formatStringLength2:self.title length:8];
    self.titleLabel.text = self.title;
    CGRect titleBoxRect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, 31) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    CGRect icoFrame = self.selectShopBImg.frame;
    icoFrame.origin.y = self.titleLabel.origin.y + 4;
    icoFrame.origin.x = self.titleLabel.size.width/2 + titleBoxRect.size.width/2 + self.titleLabel.origin.x +3 ;
    self.selectShopBImg.frame = icoFrame;
    self.navigateView.frame = CGRectMake(0, 0, icoFrame.size.width + titleBoxRect.size.width, 64);
}

#pragma 通知相关.
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:EmployeeModule_Data_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headChange:) name:EmployeeModule_Role_Change object:nil];
}

- (void)initMainView
{
    self.navigateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, SCREEN_WIDTH - 200, 28)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigateView addSubview:self.titleLabel];
    
    UIButton *selectMemberBtn = [[UIButton alloc] initWithFrame:CGRectMake(79, 15, SCREEN_WIDTH - 200, 28)];
    [selectMemberBtn addTarget:self action:@selector(selectMember:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigateView addSubview:selectMemberBtn];
    
    self.selectShopBImg = [[UIImageView alloc] initWithFrame:CGRectMake(190, 27, 20, 20)];
    self.selectShopBImg.image = [UIImage imageNamed:@"ico_more_down.png"];
    [self.navigateView addSubview:self.selectShopBImg];

    self.navigationItem.titleView = self.navigateView;
    
    selectRolePanel = [[SelectRolePanel alloc]initWithNibName:@"SelectRolePanel" bundle:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:selectRolePanel.view];
    
   selectRolePanel.view.frame = CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT);

    [self.view addSubview:self.dhListPanel];
    [self.dhListPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
    }];
    [self.dhListPanel initDelegate:self headChange:EmployeeModule_Role_Change detailChange:EmployeeModule_Data_Change];
    [self.dhListPanel setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.filterBtn];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp | TDFFooterButtonTypeAdd];
}

- (void)getType
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        self.type = @"brand";
    }else if ([[[Platform Instance] getkey:IS_BRANCH] isEqualToString:@"1"])
    {
        self.type = @"branch";
    }else{
        self.type = @"shop";
    }
}

#pragma 数据加载.
- (void)loadRoles:(BOOL)showSelectPanel
{
    self.dhListPanel.dhSearchBar.txtKey.text = @"";
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    if ([NSString isNotBlank:self.entityId]) {
         [parma setObject:self.entityId forKey:@"entity_id"];
    }else{
        self.entityId = [[Platform Instance] getkey:ENTITY_ID];
        [parma setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    }
    if ([NSString isNotBlank:self.name]) {
        self.title = self.name;
    }else{
        self.title = [[Platform Instance] getkey:SHOP_NAME];
    }
      [self reSizeShopLbl];
    [self.headList removeAllObjects];
    [self.areaList removeAllObjects];
    
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
            [selectRolePanel.mainGrid reloadData];
        [self queryEmployees:showSelectPanel];
       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

        [AlertBox show:error.localizedDescription];
         [selectRolePanel.mainGrid reloadData];
    }];
}

- (void)queryEmployees:(BOOL)isShowSelectPanel
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    if ([NSString isNotBlank:self.entityId]) {
        [parma setObject:self.entityId forKey:@"entity_id"];
    }else{
        self.entityId = [[Platform Instance] getkey:ENTITY_ID];
        [parma setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    }
    
    [self.detailList removeAllObjects];
    [self.detailMap removeAllObjects];
      [self.dhListPanel setHidden:NO];
    @weakify(self);
    [[TDFChainService new] queryEmployeeListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
 
        NSArray *employeeArrs = [data objectForKey:@"data"];
        self.detailList=[JsonHelper transList:employeeArrs objName:@"Employee"];
        self.detailMap=[[NSMutableDictionary alloc] init];
        NSMutableArray* arr=nil;
        
        if (self.detailList!=nil && self.detailList.count>0) {
            for (Employee* employee in self.detailList) {
                arr = [self.detailMap objectForKey:employee.roleId];
                if (!arr) {
                    arr = [NSMutableArray array];
                } else {
                    [self.detailMap removeObjectForKey:employee.roleId];
                }
               
                if ([NSString isNotBlank:employee.roleId]) {
                     [arr addObject:employee];
                    [self.detailMap setObject:arr forKey:employee.roleId];
                }
            }
        }
        if (isShowSelectPanel) {
            [self showSelectRole];
            
            
        }
        [self pushNotification];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
        [self.dhListPanel setHidden:YES];
    }];
        [self.dhListPanel.mainGrid reloadData];
}

#pragma 实现 FooterListEvent 协议
#pragma 添加员工.
- (void)footerAddButtonAction:(UIButton *)sender
{
    if ([ObjectUtil isNotEmpty:self.areaList]) {
        if ([self.type isEqualToString:@"shop"]) {
            @weakify(self);
            TDFShopEmployeeEditViewController *viewController = [[TDFShopEmployeeEditViewController alloc] init];
            viewController.employeeId = nil;
            viewController.roleList = self.headList;
            viewController.employeeType = TDFEmployeeAdd;
            viewController.entityId = self.entityId;
            viewController.type = self.type;
            viewController.employeeEditCallBack = ^(BOOL orRefresh){
                @strongify(self);
                if (orRefresh) {
                    [self loadRoles:NO];
                }
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            TDFChainEmployeeEditViewController *viewController = [[TDFChainEmployeeEditViewController alloc] init];
            viewController.employeeId = nil;
            viewController.roleList = self.headList;
            viewController.employeeType = TDFEmployeeAdd;
            viewController.entityId = self.entityId;
            viewController.type = self.type;
             @weakify(self);
            viewController.employeeEditCallBack = ^(BOOL orRefresh){
                @strongify(self);
                if (orRefresh) {
                    [self loadRoles:NO];
                }
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        [AlertBox show:NSLocalizedString(@"请先添加职级!", nil)];
    }
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"chainemployee"];
}

- (void)selectObj:(id<IImageDataItem>)item
{
    Employee* employee=(Employee*)item;
    if ([self.type isEqualToString:@"shop"]) {
        @weakify(self);
        TDFShopEmployeeEditViewController *viewController = [[TDFShopEmployeeEditViewController alloc] init];
        viewController.employeeId = employee.id;
        viewController.roleList = self.headList;
        viewController.employeeType = TDFEmployeeEdit;
        viewController.entityId = self.entityId;
        viewController.type = self.type;
        viewController.employeeEditCallBack = ^(BOOL orRefresh){
            @strongify(self);
            if (orRefresh) {
                [self loadRoles:NO];
            }
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        TDFChainEmployeeEditViewController *viewController = [[TDFChainEmployeeEditViewController alloc] init];
        viewController.employeeId = employee.id;
        viewController.roleList = self.headList;
        viewController.employeeType = TDFEmployeeEdit;
        viewController.entityId = self.entityId;
        viewController.type = self.type;
        @weakify(self);
        viewController.employeeEditCallBack = ^(BOOL orRefresh){
            @strongify(self);
            if (orRefresh) {
                [self loadRoles:NO];
            }
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)filtBtnClick:(UIButton *)sender {
    self.select = !self.select;
    if (self.select) {
        [self showSelectRole];
    }else{
        [self.btnBg removeFromSuperview];
        [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
        [self animationMoveOut:self.filterBtn backround:self.btnBg];
    }
}

#pragma test event
#pragma edititemlist click event.

- (void)pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [[NSNotificationCenter defaultCenter] postNotificationName:EmployeeModule_Data_Change object:dic ];
    [selectRolePanel loadData:self.headList];
    [selectRolePanel.mainGrid reloadData];
}

#pragma sigleView
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    Role *role = (Role *)item;
    [self.dhListPanel scrocll:role];
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
    self.select = NO;
}

- (void)closeSingleView:(NSInteger)event
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *viewController = [mediator TDFMediator_chainRoleListViewController:self.entityId type:self.type editCallBack:^(BOOL orRefresh) {
        @strongify(self);
        [self loadRoles:YES];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
}

#pragma 右侧职级列表，定位使用.
- (void)showSelectRole
{
    [self.view addSubview:self.btnBg];
    [self.btnBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
    }];
    
    [selectRolePanel initDelegate:self event:11];
    [selectRolePanel loadData:self.headList];
    [XHAnimalUtil animationMoveIn:selectRolePanel.view backround:self.btnBg];
    [self animationMoveIn:self.filterBtn backround:self.btnBg];
}

- (void)btnBgClick:(UIButton *)sender
{
    self.select = NO;
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
}

- (void)dataChange:(NSNotification *)notification
{
}

- (void)headChange:(NSNotification *)notification
{
    self.headList=notification.object;
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

- (void)selectMember:(id)sender {
    
    @weakify(self);
    TDFMediator *mediator = [[TDFMediator alloc] init];
    UIViewController *viewController = [mediator TDFMediator_chainMemberSearchViewControllerWithEditCallBack:^(NSDictionary *dic) {
        //TODO:CallBack
        @strongify(self);
        self.entityId = dic[@"entityId"];
        self.name = dic[@"shopName"];
        self.type = dic[@"type"];
        [self loadRoles:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
    selectRolePanel.view.hidden = YES;
    [selectRolePanel.view removeFromSuperview];
    [self.btnBg removeFromSuperview];
    [self.filterBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [XHAnimalUtil animationMoveOut:selectRolePanel.view backround:self.btnBg];
    [self animationMoveOut:self.filterBtn backround:self.btnBg];
}

@end
