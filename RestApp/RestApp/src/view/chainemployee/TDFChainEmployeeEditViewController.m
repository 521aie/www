//
//  TDFChainEmployeeEditViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFChainEmployeeEditViewController.h"
#import "ObjectUtil.h"
#import "TDFUserService.h"
#import "TDFCustomStrategy.h"
#import "TDFEditViewHelper.h"
#import "RestConstants.h"
#import "BranchShopVo.h"
#import "TDFBaseEditView.h"
#import "ImageUtils.h"
#import "GlobalRender.h"

@interface TDFChainEmployeeEditViewController ()

{
    BOOL isNeedBack;
}
@property (nonatomic, strong) NSMutableArray *shopStrArry;
@property (nonatomic, strong) NSMutableArray *plateStrArry;
@property (nonatomic, strong) NSMutableArray *branchStrArry;
@property (nonatomic ,strong) NSMutableArray *managerShopArr;
@property (nonatomic ,strong) NSMutableArray *managerPlateArr;
@property (nonatomic ,strong) NSMutableArray *managerBrachArr;
@property (nonatomic ,strong) TDFPickerItem *manageSubShop;
@property (nonatomic ,strong) TDFPickerItem *manageSubPlate;
@property (nonatomic ,strong) TDFPickerItem *manageSubBranch;
@property (nonatomic ,strong) UIView *footView;

@property (nonatomic ,strong) TDFPickerItem *manageShop;
@property (nonatomic ,strong) TDFPickerItem *managePlate;
@property (nonatomic ,strong) TDFPickerItem *manageBranch;

@end

@implementation TDFChainEmployeeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles) name:kTDFEditViewIsShowTipNotification object:nil];
    self.shopStrArry =[[NSMutableArray alloc]init];
    self.plateStrArry = [[NSMutableArray alloc] init];
    self.branchStrArry = [[NSMutableArray alloc] init];
    if (self.employeeType == TDFEmployeeEdit) {
          [self loadEmployeeeData:self.employeeId];
    }else{
        [self addAdvancedSettingSection];
    }
}

- (void) loadEmployeeeData:(NSString *)employeeId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"employee_id"] = employeeId;
    [parma setObject:@"0" forKey:@"type"];
    
    @weakify(self);
    [[TDFChainService new] getEmployeeUserWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.employee = [[EmployeeUserVo alloc] initWithDictionary:dic];
        self.userTemp = self.employee.userVo;
        self.employeeVo = self.employee.employeeVo;
        self.userId =self.employee.userVo.id;
        self.title=self.employee.employeeVo.name;
        [self getCustomerRegister:self.employee.userVo.id];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

//获取员工二维火资料
- (void)getCustomerRegister:(NSString *)userId
{
    [[TDFUserService new]   getCustomerRegister:userId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self   getCustomerRegisterFinish:data];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}
- (void)getCustomerRegisterFinish:( id)result
{
    NSDictionary *memberExtendDic = [result objectForKey:@"data"];
     self.memberExtend = [MemberExtend convertToMemberExtend:memberExtendDic];
    if (self.employee.userVo.isSupper != 1) {
        [self addBaseSettingSection];
        [self addAccountInfoSection];
        [self addIdentifierInfoSection];
        [self addAdvancedSettingSection];
        self.tableView.tableFooterView = self.tableViewFooterView;
    }else{
        [self addAccountInfoSection];
         [self addAdvancedSettingSection];
        self.tableView.tableFooterView = nil;
    }
    [self.manager reloadData];
}

- (TDFPickerItem *) manageShop
{
    if (!_manageShop) {
        _manageShop = [[TDFPickerItem alloc] init];;
        _manageShop.title = NSLocalizedString(@"管理门店", nil);
        _manageShop.textValue = self.employee.userVo.isAllShop?NSLocalizedString(@"管理全部门店", nil):NSLocalizedString(@"管理部分门店", nil);
        _manageShop.preValue = self.employee.userVo.isAllShop?NSLocalizedString(@"管理全部门店", nil):NSLocalizedString(@"管理部分门店", nil);
        
        TDFShowPickerStrategy *manageShopStrategy = [[TDFShowPickerStrategy alloc] init];
        manageShopStrategy.pickerName = NSLocalizedString(@"管理门店", nil);
        manageShopStrategy.selectedItem = [[NameItemVO alloc] initWithVal:self.employee.userVo.isAllShop?NSLocalizedString(@"管理全部门店", nil):NSLocalizedString(@"管理部分门店", nil) andId:self.employee.userVo.isAllShop?@"1":@"2"];
        
        manageShopStrategy.pickerItemList = self.managerShopArr;
        _manageShop.strategy = manageShopStrategy;
        @weakify(self);
        _manageShop.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            self.userTemp.isAllShop = [textValue isEqualToString:NSLocalizedString(@"管理全部门店", nil)]? 1:0;
            self.manageSubShop.shouldShow = !self.userTemp.isAllShop;
            [self.manager reloadData];
            return YES;
        };
    }
    return _manageShop;
}

- (TDFPickerItem *) managePlate
{
    if (!_managePlate) {
        _managePlate = [[TDFPickerItem alloc] init];;
        _managePlate.title = NSLocalizedString(@"管理品牌", nil);
        _managePlate.textValue = self.employee.userVo.isAllPlate?NSLocalizedString(@"管理全部品牌", nil):NSLocalizedString(@"管理部分品牌", nil);
        _managePlate.preValue = self.employee.userVo.isAllPlate?NSLocalizedString(@"管理全部品牌", nil):NSLocalizedString(@"管理部分品牌", nil);
        TDFShowPickerStrategy *managePlateStrategy = [[TDFShowPickerStrategy alloc] init];
        managePlateStrategy.pickerName = NSLocalizedString(@"管理品牌", nil);
        managePlateStrategy.selectedItem = [[NameItemVO alloc] initWithVal:self.employee.userVo.isAllPlate?NSLocalizedString(@"管理全部品牌", nil):NSLocalizedString(@"管理部分品牌", nil) andId:self.employee.userVo.isAllPlate?@"1":@"2"];
        
        managePlateStrategy.pickerItemList = self.managerPlateArr;
        _managePlate.strategy = managePlateStrategy;
         @weakify(self);
        _managePlate.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            self.userTemp.isAllPlate = [textValue isEqualToString:NSLocalizedString(@"管理全部品牌", nil)]? 1:0;
            self.manageSubPlate.shouldShow = !self.userTemp.isAllPlate;
            [self.manager reloadData];
            return YES;
        };
  
    }
    return _managePlate;
}

- (TDFPickerItem *) manageBranch
{
    if (!_manageBranch) {
        _manageBranch = [[TDFPickerItem alloc] init];;
        _manageBranch.title = NSLocalizedString(@"管理分公司", nil);
        _manageBranch.textValue = self.employee.userVo.isAllBranch?NSLocalizedString(@"管理全部分公司", nil):NSLocalizedString(@"管理部分分公司", nil);
        _manageBranch.preValue = self.employee.userVo.isAllBranch?NSLocalizedString(@"管理全部分公司", nil):NSLocalizedString(@"管理部分分公司", nil);
        
        TDFShowPickerStrategy *manageBranchStrategy = [[TDFShowPickerStrategy alloc] init];
        manageBranchStrategy.pickerName = NSLocalizedString(@"管理分公司", nil);
        manageBranchStrategy.selectedItem = [[NameItemVO alloc] initWithVal:self.employee.userVo.isAllBranch?NSLocalizedString(@"管理全部分公司", nil):NSLocalizedString(@"管理部分分公司", nil) andId:self.employee.userVo.isAllBranch?@"1":@"2"];
        
        manageBranchStrategy.pickerItemList = self.managerBrachArr;
        _manageBranch.strategy = manageBranchStrategy;
        @weakify(self);
        _manageBranch.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            @strongify(self);
            self.userTemp.isAllBranch = [textValue isEqualToString:NSLocalizedString(@"管理全部分公司", nil)]? 1:0;
            self.manageSubBranch.shouldShow = !self.userTemp.isAllBranch;
            [self.manager reloadData];
            return YES;
        };

    }
    return _manageBranch;
}

- (void) addAdvancedSettingSection
{
    DHTTableViewSection *addAdvancedSettingSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"高级设置", nil)];
    DHTTableViewSection *section = [DHTTableViewSection section];

    [section addItem:self.manageShop];
    [section addItem:self.manageSubShop];
    
    [section addItem:self.managePlate];
    [section addItem:self.manageSubPlate];
    
    [section addItem:self.manageBranch];
    [self.manager addSection:addAdvancedSettingSection];
    [self.manager addSection:section];
    [section addItem:self.manageSubBranch];
    
    DHTTableViewSection *footerSection = [DHTTableViewSection section];
    footerSection.footerView = self.footView;
    footerSection.footerHeight = 100;
    [self.manager addSection:footerSection];
    
}

- (TDFPickerItem *) manageSubShop
{
    if (!_manageSubShop) {
        _manageSubShop = [[TDFPickerItem alloc] init];;
        _manageSubShop.title = NSLocalizedString(@"•可登录管理的门店", nil);
        for (ShopVO *shop in self.employee.userShopVoList) {
            [self.shopStrArry addObject:shop.name];
        }
        _manageSubShop.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userShopVoList.count];
        _manageSubShop.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userShopVoList.count];
        _manageSubShop.detail = [ObjectUtil array2String:self.shopStrArry];
        
        TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        notIncludeStrategy.btnClickedBlock = ^ () {
            @strongify(self);
            if ([self isAnyTipsShowed]) {
                    self.index = 2;
                    [self save];
            }else
            {
                if (self.employeeType == TDFEmployeeAdd) {
                    if (![self isValid]) {
                         return;
                    }
                }
                self.tableView.tableFooterView = nil;
                [self queryShopList];
            }
        };
        _manageSubShop.strategy = notIncludeStrategy;
        _manageSubShop.shouldShow = !self.employee.userVo.isAllShop;
    }
    return _manageSubShop;
}

- (TDFPickerItem *) manageSubPlate
{
    if (!_manageSubPlate) {
        _manageSubPlate = [[TDFPickerItem alloc] init];;
        _manageSubPlate.title = NSLocalizedString(@"•管理的品牌", nil);
        _manageSubPlate.detail = NSLocalizedString(@"(不包括品牌下的门店)", nil);
        for (Plate *plate in self.employee.userPlateVoList) {
            [self.plateStrArry addObject:plate.name];
        }
        _manageSubPlate.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil),(unsigned long)self.employee.userPlateVoList.count];
        _manageSubPlate.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil),(unsigned long)self.employee.userPlateVoList.count];
        _manageSubPlate.complement = [ObjectUtil array2String:self.plateStrArry];
        
        TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        notIncludeStrategy.btnClickedBlock = ^ () {
            @strongify(self);
            if ([self isAnyTipsShowed]) {
                self.index = 3;
                [self save];
            }else
            {
                if (![self isValid]) {
                    return;
                }
                self.tableView.tableFooterView = nil;
                [self qureyPlateList];
            }
        };
        _manageSubPlate.strategy = notIncludeStrategy;
        _manageSubPlate.shouldShow = !self.employee.userVo.isAllPlate;
    }
    return _manageSubPlate;
}

- (TDFPickerItem *) manageSubBranch
{
    if (!_manageSubBranch) {
        _manageSubBranch = [[TDFPickerItem alloc] init];;
        _manageSubBranch.title = NSLocalizedString(@"•可登录管理的分公司", nil);
        _manageSubBranch.detail = NSLocalizedString(@"(不包括分公司的门店)", nil);
        for (BranchVo *branchVo in self.employee.userBranchVoList) {
            [self.branchStrArry addObject:branchVo.branchName];
        }
        _manageSubBranch.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userBranchVoList.count];
        _manageSubBranch.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userBranchVoList.count];
        _manageSubBranch.complement = [ObjectUtil array2String:self.branchStrArry];
        
        TDFCustomStrategy *notIncludeStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        notIncludeStrategy.btnClickedBlock = ^ () {
            @strongify(self);
            if ([self isAnyTipsShowed]) {
                self.index = 4;
                [self save];
            }else
            {
                if (![self isValid]) {
                    return;
                }
                self.tableView.tableFooterView = nil;
                [self queryBranchList];
            }
        };
        _manageSubBranch.strategy = notIncludeStrategy;
        _manageSubBranch.shouldShow = !self.employee.userVo.isAllBranch;
    }
    return _manageSubBranch;
}

- (NSMutableArray *)managerShopArr {
    if(!_managerShopArr) {
        _managerShopArr = [NSMutableArray array];
        NameItemVO *item;
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理全部门店", nil) andId:@"1"];
        [_managerShopArr addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理部分门店", nil) andId:@"2"];
        [_managerShopArr addObject:item];
    }
    return _managerShopArr;
}

- (NSMutableArray *)managerPlateArr
{
    if(!_managerPlateArr) {
        _managerPlateArr = [NSMutableArray array];
        NameItemVO *item;
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理全部品牌", nil) andId:@"1"];
        [_managerPlateArr addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理部分品牌", nil) andId:@"2"];
        [_managerPlateArr addObject:item];
    }
    return _managerPlateArr;
}

- (NSMutableArray *)managerBrachArr
{
    if(!_managerBrachArr) {
        _managerBrachArr = [NSMutableArray array];
        NameItemVO *item;
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理全部分公司", nil) andId:@"1"];
        [_managerBrachArr addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"管理部分分公司", nil) andId:@"2"];
        [_managerBrachArr addObject:item];
    }
    return _managerBrachArr;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    
    //处理普通员工更新.
    EmployeeUserVo *objTemp = [EmployeeUserVo new];
    objTemp.employeeVo = self.employeeVo;
    objTemp.userVo = self.userTemp;
    objTemp.userVo.username = self.userTemp.userName;
    [[Platform Instance] saveKeyWithVal:DEFAULT_ROLE withVal:self.userTemp.roleId];
    
    NSString *tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.employeeType == TDFEmployeeAdd?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[JsonHelper getObjectData:objTemp.employeeVo] forKey:@"employeeVo"];
    [dic setObject:[JsonHelper getObjectData:objTemp.userVo] forKey:@"userVo"];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"employee_user_json"] = [JsonHelper dictionaryToJson:dic];
    [parma setObject:@"0" forKey:@"type"];
    
    
    [self showProgressHudWithText:tip];
    if (self.employeeType == TDFEmployeeAdd) {
        @weakify(self);
        [[TDFChainService new] createEmployeeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.employee = [[EmployeeUserVo alloc] initWithDictionary:data[@"data"]];
            self.userId = self.employee.userVo.id;
            self.employeeId = self.employee.employeeVo.id;
            self.employeeEditCallBack(YES);
            for (DHTTableViewSection *section in self.manager.sections) {
                for (DHTTableViewItem *item in section.items) {
                    if ([item isKindOfClass:[TDFBaseEditItem class]]) {
                        TDFBaseEditItem *baseItem = (TDFBaseEditItem *)item;
                        baseItem.isShowTip = NO;
                    }
                    
                }
            }

            if (self.index == 1) {
                self.employeeEditCallBack(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }else if (self.index == 2){
                [self queryShopList];
            }else if (self.index == 3){
                [self qureyPlateList];
            }
            else if (self.index == 4){
                [self queryBranchList];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
        
    } else {
        @weakify(self);
        [[TDFChainService new] saveEmployeeWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            
            self.employee = [[EmployeeUserVo alloc] initWithDictionary:data[@"data"]];
            self.employeeEditCallBack(YES);
            self.userId = self.employee.userVo.id;
            self.employeeId = self.employee.employeeVo.id;
            for (DHTTableViewSection *section in self.manager.sections) {
                for (DHTTableViewItem *item in section.items) {
                    if ([item isKindOfClass:[TDFBaseEditItem class]]) {
                        TDFBaseEditItem *baseItem = (TDFBaseEditItem *)item;
                        baseItem.isShowTip = NO;
                    }
                    
                }
            }
            if (self.index == 1) {
                self.employeeEditCallBack(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }else if (self.index == 2){
                [self queryShopList];
            }else if (self.index == 3){
                [self qureyPlateList];
            }
            else if (self.index == 4){
                [self queryBranchList];
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void) queryShopList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"user_id"] = self.employee.userVo._id;
    parma[@"page_index"] = @"1";
    
    @weakify(self);
    [[[TDFChainService alloc] init] queryEmployeeShopListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        NSMutableArray *headList = [[NSMutableArray alloc]init];
        NSMutableDictionary *detailMap = [[NSMutableDictionary alloc] init];
        for (NSMutableDictionary *dic in data[@"data"]) {
            BranchShopVo *branchShopVo = [[BranchShopVo alloc] initWithDictionary:dic];
            if ([NSString isBlank:branchShopVo.branchId]) {
                branchShopVo.branchId = @"1";
            }
            if ([ObjectUtil isNotEmpty:[dic objectForKey:@"shopVoList"]]) {
                NSMutableArray *shopList = [ShopVO convertToShopVoListByArr:[dic objectForKey:@"shopVoList"]];
                [headList addObject:branchShopVo];
                [detailMap setObject:shopList forKey:[branchShopVo obtainItemId]];
            }
        }
        
        TDFMediator *mediator = [[TDFMediator alloc] init];
        @weakify(self);
        UIViewController *viewController = [mediator TDFMediator_chainSelectListViewControllerWithOldArrs:nil userId:self.userId delegate:self istarget:EMPLOYEE_COMMON_RATIO currentAction:self.employeeType headList:headList employeeId:self.employeeId detailMap:detailMap entityId:self.entityId editCallBack:^(BOOL orRefresh) {
            @strongify(self);
             self.employeeType = TDFEmployeeEdit;
            [self celarArry];
            [self loadEmployeeeDataBackSubView:self.employeeId];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void)celarArry
{
    [self.shopStrArry removeAllObjects];
    [self.plateStrArry removeAllObjects];
    [self.branchStrArry removeAllObjects];
}
- (void)qureyPlateList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"user_id"] = self.employee.userVo._id;
    
    @weakify(self);
    [[TDFChainService new] queryPlateListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableArray *arr = [JsonHelper transList:data[@"data"] objName:@"chainEmployeeData"];
        
        TDFMediator *mediator = [[TDFMediator alloc] init];
        @weakify(self);
        UIViewController *viewController = [mediator TDFMediator_chainSelectListViewControllerWithOldArrs:arr userId:self.userId delegate:self istarget:EMPLOYEE_FORCE_RATIO currentAction:self.employeeType headList:nil employeeId:self.employeeId detailMap:nil entityId:self.entityId editCallBack:^(BOOL orRefresh) {
            @strongify(self);
            self.employeeType = TDFEmployeeEdit;
            [self celarArry];
            [self loadEmployeeeDataBackSubView:self.employeeId];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void) queryBranchList
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"user_id"] = self.employee.userVo._id;
    
    @weakify(self);
    [[TDFChainService new] queryGlobalManageBranchListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableArray *arr = [JsonHelper transList:data[@"data"] objName:@"BranchTreeVo"];
        
        TDFMediator *mediator = [[TDFMediator alloc] init];
        @weakify(self);
        UIViewController *viewController = [mediator TDFMediator_chainSelectListViewControllerWithOldArrs:arr userId:self.userId delegate:self istarget:EMPLOYEE_BRANCHCOMPANY currentAction:self.employeeType headList:nil employeeId:self.employeeId detailMap:nil entityId:self.entityId editCallBack:^(BOOL orRefresh) {
            @strongify(self);
            self.employeeType = TDFEmployeeEdit;
            [self celarArry];
            [self loadEmployeeeDataBackSubView:self.employeeId];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (UIView *)footView {
    if(!_footView) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 80);
        label.text = NSLocalizedString(@"注：此处管理的门店、分公司，表示该员工账号有权限登录管理的门店和分公司首页。但是，具体的职级权限操作（如管理员工职级权限），则需要去职级管理中的权限设置里设定相应权限。管理的品牌，则意味着该员工账号可设置品牌相关的内容，例如商品、促销等。", nil);
        [_footView addSubview:label];
    }
    return _footView;
}

- (void)shouldChangeNavTitles {
    if ([self isAnyTipsShowed] || self.employeeType == TDFEmployeeAdd) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    } else {
        [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
        [self configRightNavigationBar:nil rightButtonName:nil];
    }
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (void)leftNavigationButtonAction:(id)sender {
    if ([self isAnyTipsShowed]) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"内容有变更尚未保存，确定要退出吗？", nil) cancelBlock:^{
            
        } enterBlock:^{
            [super leftNavigationButtonAction:sender];
        }];
    }else {
        [super leftNavigationButtonAction:sender];
    }
}

- (void) fillModel
{
    NSString* sexStr=[NSString stringWithFormat:@"%d",self.employee.employeeVo.sex==0?1:self.employee.employeeVo.sex];
    NSString* imgPath=nil;
    if([sexStr isEqualToString:@"1"]){
        imgPath=@"img_stuff_male.png";
    } else {
        imgPath=@"img_stuff_female.png";
    }
    if (self.employee.employeeVo.path == nil) {
        self.nameImageItem.defaultFileName = imgPath;
        self.nameImageItem.preValue = @"";
        self.nameImageItem.filePath = @"";
    }else{
        self.nameImageItem.filePath = [ImageUtils getImageUrl:self.employee.employeeVo.server path:self.employee.employeeVo.path];;
        self.nameImageItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.server path:self.employee.employeeVo.path];;
    }

    Role *role = [[Role alloc] init];

    if (self.employee.userVo.isSupper == 1) {
        role.name = NSLocalizedString(@"超级管理员", nil);
        role._id = @"0";
    } else {
        NSString* roleName=[GlobalRender obtainObjName:self.roleList itemId:self.employee.employeeVo.roleId];
        self.userTemp.roleId = self.employee.employeeVo.roleId;
        role.name = roleName;
        role._id = self.employee.employeeVo.roleId;
    }
    self.roleItem.textValue = role.name;
    self.roleItem.preValue = role.name;

    self.nameItemText.textValue = self.employee.employeeVo.name;
    self.nameItemText.preValue = self.employee.employeeVo.name;
    
    NameItemVO * item = [[NameItemVO alloc] initWithVal:[GlobalRender obtainItem:[GlobalRender listSexs] itemId:sexStr] andId:sexStr];

    self.sexItem.textValue = item.itemName;
    self.sexItem.preValue = item.itemName;
    
    self.phoneItem.textValue = self.employee.employeeVo.mobile;
    self.phoneItem.preValue = self.employee.employeeVo.mobile;
    
    if ([self.employee.userVo.roleId isEqualToString:@"0"]) {
        self.nameItem.textValue = NSLocalizedString(@"超级管理员", nil);
        self.nameItem.preValue = NSLocalizedString(@"超级管理员", nil);
        self.nameItem.editStyle = TDFEditStyleUnEditable;
    }else{
        self.nameItem.textValue = self.employee.userVo.userName;
        self.nameItem.preValue = self.employee.userVo.userName;
        self.nameItem.editStyle = TDFEditStyleEditable;
    }

    self.identifierItem.textValue = self.employee.employeeVo.idCard;
    self.identifierItem.preValue = self.employee.employeeVo.idCard;
    
    if ([NSString isBlank:self.employee.employeeVo.frontPath] || [self.employee.employeeVo.frontPath isEqualToString:
                                                                  @"-1"]) {
        self.frontItem.preValue = @"";
        self.frontItem.cardImagePath = @"";
    }else{
        self.frontItem.cardImagePath = [ImageUtils getImageUrl:self.employee.employeeVo.frontServer path:self.employee.employeeVo.frontPath];
        self.frontItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.frontServer path:self.employee.employeeVo.frontPath];
    }

    if ([NSString isBlank:self.employee.employeeVo.backPath] ||  [self.employee.employeeVo.backPath isEqualToString:
                                                                  @"-1"]) {
        self.backItem.preValue = @"";
        self.backItem.cardImagePath = @"";
    }else{
        self.backItem.cardImagePath = [ImageUtils getImageUrl:self.employee.employeeVo.backServer path:self.employee.employeeVo.backPath];
        self.backItem.preValue = [ImageUtils getImageUrl:self.employee.employeeVo.backServer path:self.employee.employeeVo.backPath];
    }
    
    self.manageSubShop.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userShopVoList.count];
    self.manageSubShop.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userShopVoList.count];
    self.manageSubShop.detail = [ObjectUtil array2String:self.shopStrArry];
    
    self.manageShop.textValue = self.employee.userVo.isAllShop?NSLocalizedString(@"管理全部门店", nil):NSLocalizedString(@"管理部分门店", nil);
    self.manageShop.preValue = self.employee.userVo.isAllShop?NSLocalizedString(@"管理全部门店", nil):NSLocalizedString(@"管理部分门店", nil);
    
    self.managePlate.textValue = self.employee.userVo.isAllPlate?NSLocalizedString(@"管理全部品牌", nil):NSLocalizedString(@"管理部分品牌", nil);
    self.managePlate.preValue = self.employee.userVo.isAllPlate?NSLocalizedString(@"管理全部品牌", nil):NSLocalizedString(@"管理部分品牌", nil);

    self.manageSubPlate.detail = NSLocalizedString(@"(不包括品牌下的门店)", nil);
    for (Plate *plate in self.employee.userPlateVoList) {
        [self.plateStrArry addObject:plate.name];
    }
    self.manageSubPlate.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil),(unsigned long)self.employee.userPlateVoList.count];
    self.manageSubPlate.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu个", nil),(unsigned long)self.employee.userPlateVoList.count];
    self.manageSubPlate.complement = [ObjectUtil array2String:self.plateStrArry];

    self.manageBranch.textValue = self.employee.userVo.isAllBranch?NSLocalizedString(@"管理全部分公司", nil):NSLocalizedString(@"管理部分分公司", nil);
    self.manageBranch.preValue = self.employee.userVo.isAllBranch?NSLocalizedString(@"管理全部分公司", nil):NSLocalizedString(@"管理部分分公司", nil);

    self.manageSubBranch.detail = NSLocalizedString(@"(不包括分公司的门店)", nil);
    for (BranchVo *branchVo in self.employee.userBranchVoList) {
        [self.branchStrArry addObject:branchVo.branchName];
    }
    self.manageSubBranch.textValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userBranchVoList.count];
    self.manageSubBranch.preValue = [NSString stringWithFormat:NSLocalizedString(@"%lu家", nil),(unsigned long)self.employee.userBranchVoList.count];
    self.manageSubBranch.complement = [ObjectUtil array2String:self.branchStrArry];
    
     [self.manager reloadData];
}

- (void) rightNavigationButtonAction:(id)sender
{
    self.index = 1;
    [self save];
}

- (void) loadEmployeeeDataBackSubView:(NSString *)employeeId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"employee_id"] = employeeId;
    [parma setObject:@"0" forKey:@"type"];
    
    @weakify(self);
    [[TDFChainService new] getEmployeeUserWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.employee = [[EmployeeUserVo alloc] initWithDictionary:dic];
        self.userTemp = self.employee.userVo;
        self.employeeVo = self.employee.employeeVo;
        self.userId =self.employee.userVo.id;
        self.title=self.employee.employeeVo.name;
        [self.manager removeAllSections];
        self.employeeType = TDFEmployeeEdit;
        [self getCustomerRegister:self.employee.userVo.id];
        [self fillModel];
        [self.manager reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


@end
