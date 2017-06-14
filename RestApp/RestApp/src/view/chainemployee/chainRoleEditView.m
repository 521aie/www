//
//  chainRoleEditView.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "chainRoleEditView.h"
#import "MBProgressHUD.h"
#import "XHAnimalUtil.h"
#import "SelectBatchRoleView.h"
#import "ServiceFactory.h"
#import "EmployeeModuleEvent.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import <libextobjc/EXTScope.h>
#import "TDFChainService.h"
#import "TreeBuilder.h"
#import "TreeNode.h"
#import "TDFMediator+ChainEmployeeModule.h"
#import "YYModel.h"

@implementation chainRoleEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initMainView];
    [self hideView];
    #pragma notification 处理.

    [UIHelper initNotification:self.container event:Notification_UI_RoleEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_RoleEditView_Change object:nil];
    
    [self loadData:self.role action:self.action isContinue:self.isContinue entityId:self.entityId type:self.type];
}


#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
        return;
    }
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void)initMainView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container];
    [self.container addSubview:self.txtName];
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    [self.container addSubview:firstView];
    
    [self.container addSubview:self.titleRest];
    [self.container addSubview:self.restGrid];
    [self.container addSubview:self.chainView];
    
    [self.container addSubview:self.branchTitle];
    [self.container addSubview:self.branchTab];
    [self.container addSubview:self.branchView];
    
    [self.container addSubview:self.titleCash];
    [self.container addSubview:self.cashGrid];
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    [self.container addSubview:secondView];
    
    [self.container addSubview:self.titleCashShop];
    [self.container addSubview:self.cashShopGrid];
    [self.container addSubview:self.cashShopView];

    [self.container addSubview:self.delView];
    
    [self.txtName initLabel:NSLocalizedString(@"职级名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    
    self.delView.hidden = (self.action == ACTION_CONSTANTS_ADD);
}

- (UIView *) delView
{
    if (!_delView) {
        _delView = [[UIView alloc] initWithFrame:CGRectMake(0, 442, [UIScreen mainScreen].bounds.size.width, 40)];
        [_delView addSubview:self.btnDel];
    }
    return _delView;
}

//点击按钮table上的删除和添加 按钮
- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.isContinue=YES;
        self.continueEvent=event;
        [self save];
        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        if ([self hasChanged]) {
            self.isContinue=YES;
            self.continueEvent=event;
            [self save];
        } else {
            [self continueAdd:event];
        }
    }
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray *) items
{
    if (event == SELECT_BRAND_ACTION) {
        self.event = @"1";
    }else if (event == SELECT_BRANCH_ACTION)
    {
        self.event = @"2";
    }else if (event == SELECT_REST_ACTION) {
        self.event = @"3";
    }else if (event == SELECT_CASH_ACTION)
    {
        self.event = @"4";
    }
    [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"entity_id"] = self.entityId;
    param[@"role_id"] = self.role.id;
    param[@"action_id_list_json"] = [JsonHelper arrTransJson:items];
    param[@"type"] = self.event;
    @weakify(self);
    [[TDFChainService new] saveChainRoleActionWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self loadData:self.role action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue entityId:self.entityId type:self.type];
        [self loadChainActions];
        [self configNavigationBar:NO];
        self.isContinue=NO;
        [self.delView setHidden:NO];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)loadData:(Role *) roleTemp action:(int)action isContinue:(BOOL)isContinue entityId:(NSString *)entityId type:(NSString *)type
{
    self.type = type;
    self.titleRest.lblName.text = NSLocalizedString(@"权限设置-连锁", nil);
    self.branchTitle.lblName.text = NSLocalizedString(@"权限设置-分公司", nil);
    if ([self.type isEqualToString:@"ownshop"]) {
        self.titleCash.lblName.text = NSLocalizedString(@"权限设置-后台/掌柜", nil);
        self.titleCashShop.lblName.text = NSLocalizedString(@"权限设置-收银", nil);
    }else if ([self.type isEqualToString:@"brand"] || [self.type isEqualToString:@"shop"] ||[self.type isEqualToString:@"branch"] )
    {
        self.titleCash.lblName.text = NSLocalizedString(@"权限设置-门店掌柜", nil);
        self.titleCashShop.lblName.text = NSLocalizedString(@"权限设置-门店收银", nil);
    }
    self.entityId = entityId;
    self.role = roleTemp;
    self.action = action;
    self.isContinue = isContinue;
    if (action==ACTION_CONSTANTS_ADD) {
        self.title = NSLocalizedString(@"添加职级", nil);
        [self clearDo];
    } else if (action==ACTION_CONSTANTS_EDIT) {
        self.title=self.role.name;
        [self fillModel];
        [self loadChainActions];
    }
}

- (void)closeMultiView:(NSInteger)event
{
    [self configNavigationBar:NO];
    [self.delView setHidden:NO];
}

- (void) hideView
{
    if ([self.type isEqualToString:@"branch"]) {
        [self.chainView setHeight:0];
         [self.branchView setHeight:20];
        
        [self.titleRest setHidden:YES];
        [self.restGrid setHidden:YES];
        [self.chainView setHidden:YES];
        
        [self.branchView setHidden:NO];
        [self.branchTitle setHidden:NO];
        [self.branchTab setHidden:NO];
        
    }
    if ([self.type isEqualToString:@"shop"] || [self.type isEqualToString:@"ownshop"]) {
        [self.chainView setHeight:0];
        [self.branchView setHeight:0];
        [self.cashShopView setHeight:20];
        
        [self.chainView setHidden:YES];
        [self.titleRest setHidden:YES];
        [self.restGrid setHidden:YES];
        
        [self.branchView setHidden:YES];
        [self.branchTitle setHidden:YES];
        [self.branchTab setHidden:YES];
    }
    if ([self.type isEqualToString:@"brand"]) {
        [self.chainView setHeight:20];
        [self.branchView setHeight:20];
        [self.cashShopView setHeight:20];
        
        [self.titleRest setHidden:NO];
        [self.restGrid setHidden:NO];
        [self.chainView setHidden:NO];
        
        [self.branchTitle setHidden:NO];
        [self.branchTab setHidden:NO];
        [self.branchView setHidden:NO];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)loadChainActions
{
    NSString *roleId = (self.role==nil?@"":self.role.id);
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.entityId forKey:@"entity_id"];
    [param setObject:roleId forKey:@"role_id"];
    
    @weakify(self);
    [[TDFChainService new] queryChainRoleActionAllTypeWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSMutableDictionary *dic = data[@"data"];

        NSMutableArray *chainArr = [[NSArray yy_modelArrayWithClass:[Action class] json:dic[@"chainActionList"]] mutableCopy];
        
        NSMutableArray *branchArr = [[NSArray yy_modelArrayWithClass:[Action class] json:dic[@"branchActionList"]] mutableCopy];
        
        NSMutableArray *managerArr = [[NSArray yy_modelArrayWithClass:[Action class] json:dic[@"shopRestActionList"]] mutableCopy];
        NSMutableArray *cashArr = [[NSArray yy_modelArrayWithClass:[Action class] json:dic[@"shopCashActionList"]] mutableCopy];
        
        self.restNodes = [NSMutableArray array];
        self.restNodes = [TreeBuilder buildTree:chainArr];

        self.branchNodes = [NSMutableArray array];
        self.branchNodes = [TreeBuilder buildTree:branchArr];
        
        self.managerNodes1 = [NSMutableArray array];
        self.managerNodes1 = [TreeBuilder buildTree:managerArr];
        
        self.cashNodes = [NSMutableArray array];
        self.cashNodes = [TreeBuilder buildTree:cashArr];
        
        NSMutableArray *cashZhChildNodes = [NSMutableArray array];
        NSMutableArray *childNodes = [NSMutableArray array];

        for (TreeNode* node in self.cashNodes) {
            childNodes=node.children;
            if (childNodes==nil || childNodes.count==0 ) {
                [cashZhChildNodes addObject:node];
            }
        }
        if ([ObjectUtil isNotEmpty:cashZhChildNodes]) {
            Action *rootAction = [Action new];
            rootAction._id=@"-100";
            rootAction.name=NSLocalizedString(@"综合", nil);
            TreeNode *cashZhNode=[[TreeNode alloc] initWith:rootAction];
            cashZhNode.children=cashZhChildNodes;
            [self.cashNodes insertObject:cashZhNode atIndex:0];
            
            for (TreeNode* node in cashZhChildNodes) {
                if ([self.cashNodes containsObject:node]) {
                    [self.cashNodes removeObject:node];
                }
            }
        }
 
        [self processTreeNode:self.restNodes grid:self.restGrid];
        [self processTreeNode:self.branchNodes grid:self.branchTab];
        [self processTreeNode:self.managerNodes1 grid:self.cashGrid];
        [self processTreeNode:self.cashNodes grid:self.cashShopGrid];
        
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper clearColor:self.container];
        self.scrollView.contentOffset=CGPointZero;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void)continueAdd:(NSString *)event
{
    if ([event isEqualToString:REST_DETAIL_EVENT]) {
        self.event = @"1";
    }else if ([event isEqualToString:BRANCH_DETAIL_EVENT])
    {
        self.event = @"2";
    }else if ([event isEqualToString:CASH_DETAIL_EVENT]) {
        self.event = @"3";
    }else if ([event isEqualToString:CASH_SHOP_DETAIL_EVENT])
    {
        self.event = @"4";
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.entityId forKey:@"entity_id"];
    [param setObject:self.role.id forKey:@"role_id"];
    [param setObject:self.event forKey:@"type"];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    @weakify(self);
    [[TDFChainService new] queryChainRoleActionWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        NSArray *chainList = data[@"data"];
        
        NSMutableArray *chainArr = [JsonHelper transList:chainList objName:@"Action"];
        NSMutableArray *cashZhChildNodes = [NSMutableArray array];
        NSMutableArray *childNodes = [NSMutableArray array];
    
        self.restNodes = [NSMutableArray array];
        self.restNodes = [TreeBuilder buildTree:chainArr];
        
        if (self.event.intValue == 4 || self.event.intValue == 0) {
            Action *rootAction = [Action new];
            
            rootAction._id=@"-100";
            rootAction.name=NSLocalizedString(@"综合", nil);
            
            for (TreeNode* node in self.restNodes) {
                childNodes=node.children;
                if (childNodes==nil || childNodes.count==0) {
                        [cashZhChildNodes addObject:node];
                }
            }
            
            TreeNode *cashZhNode=[[TreeNode alloc] initWith:rootAction];
            cashZhNode.children=cashZhChildNodes;
            [self.restNodes insertObject:cashZhNode atIndex:0];
            
            for (TreeNode* node in cashZhChildNodes) {
                if ([self.restNodes containsObject:node]) {
                    [self.restNodes removeObject:node];
                }
            }
        }
        NSInteger indexTag = 0;
        NSString *titleName;
        switch (self.event.intValue) {
            case 1:
                indexTag = SELECT_BRAND_ACTION;
                titleName = NSLocalizedString(@"连锁权限", nil);
                break;
            case 2:
                indexTag = SELECT_BRANCH_ACTION;
                titleName = NSLocalizedString(@"分公司权限", nil);
                break;
            case 3:
                indexTag = SELECT_REST_ACTION;
                if ([self.type isEqualToString:@"shop"] || [self.type isEqualToString:@"brand"]) {
                      titleName = NSLocalizedString(@"门店掌柜权限", nil);
                }else if ([self.type isEqualToString:@"ownshop"])
                {
                  titleName = NSLocalizedString(@"后台/掌柜权限", nil);
                }
              
                break;
            case 4:
                indexTag = SELECT_CASH_ACTION;
                if ([self.type isEqualToString:@"shop"] || [self.type isEqualToString:@"brand"]) {
                     titleName = NSLocalizedString(@"门店收银权限", nil);
                }else if ([self.type isEqualToString:@"ownshop"])
                {
                     titleName = NSLocalizedString(@"收银权限", nil);
                }
            default:
                break;
        }
        [self.txtName.txtVal resignFirstResponder];
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *viewController = [mediator TDFMediator_chainSelectBatchRoleViewControllerWithUser:indexTag delegate:self title:titleName nodeList:self.restNodes];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud setHidden:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma save-data
- (BOOL)valid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"职级名称不能为空!", nil)];
        return NO;
    }
    !self.txtName.endEditingCallBack?:self.txtName.endEditingCallBack(self.txtName.txtVal.text);
    return YES;
}

- (Role *)transMode
{
    Role *obj = [Role new];
    obj.name = [self.txtName getStrVal];
    obj.lastVer = self.role.lastVer;
    obj.entityId = self.role.entityId;
    obj.id = self.role.id;
    
    return obj;
}

- (void)save
{
    if (![self valid]) {
        return;
    }
    Role *roleTemp = [self transMode];
    NSString *tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@职级", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    
    if (self.action==ACTION_CONSTANTS_ADD) {
        [self showProgressHudWithText:tip];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[JsonHelper transJson:roleTemp] forKey:@"role_json"];
        [param setObject:self.entityId forKey:@"entity_id"];
        @weakify(self);
            [[TDFChainService new] createRoleWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [self.progressHud setHidden:YES];
                [self saveFinish:data];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
                 @strongify(self);
                [self.progressHud setHidden:YES];
                [AlertBox show:error.localizedDescription];
    }];

    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        [self showProgressHudWithText:tip];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[JsonHelper transJson:roleTemp] forKey:@"role_json"];
        [param setObject:self.entityId forKey:@"entity_id"];
        
        @weakify(self);
        [[TDFChainService new] saveRoleWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            [self saveFinish:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             @strongify(self);
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void) saveFinish:(NSMutableDictionary *)dic
{
    NSDictionary *roleDic = [dic objectForKey:@"data"];
    self.role = [JsonHelper dicTransObj:roleDic obj:[Role alloc]];
    self.title = self.role.name;
    [self fillModel];
    self.action =ACTION_CONSTANTS_EDIT;
    [self configNavigationBar:NO];
    if (self.isContinue) {
        [self continueAdd:self.continueEvent];
    } else {
        self.roleEditCallBack(YES);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clearDo
{
    [self.txtName initData:nil];
    [self processTreeNode:nil grid:self.restGrid];
    [self processTreeNode:nil grid:self.cashGrid];
    [self processTreeNode:nil grid:self.branchTab];
    [self processTreeNode:nil grid:self.cashShopGrid];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    self.scrollView.contentOffset=CGPointZero;
}

#pragma 删除事件.
- (void)delObjEvent:(NSString*)event obj:(id)obj
{
    if ([ObjectUtil isNotNull:obj]) {
        Action* act=(Action*)obj;
        [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
         NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:self.role.id forKey:@"role_id"];
        [param setObject:act.id forKey:@"action_id"];
        [param setObject:self.entityId forKey:@"entity_id"];
        @weakify(self);
        [[TDFChainService new] deleteChainRoleActionWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [self loadChainActions];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
            @strongify(self);
            [self.progressHud hideAnimated:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self showProgressHudWithText:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.role.name]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        Role *roleTemp = [self transMode];
        param[@"role_json"]= [roleTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFChainService new] deleteRoleWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud setHidden:YES];
            self.roleEditCallBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
            @strongify(self);
            [self.progressHud setHidden:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

@end
