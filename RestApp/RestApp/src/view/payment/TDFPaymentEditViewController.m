//
//  TDFPaymentEditViewController.m
//  RestApp
//
//  Created by 栀子花 on 2016/12/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPaymentEditViewController.h"
#import "DHTTableViewManager.h"
#import "TDFTextfieldItem.h"
#import "TDFPickerItem.h"
#import "TDFLabelItem.h"
#import "TDFTextfieldItem.h"
#import "TDFBaseEditView.h"
#import "NameItemVO.h"
#import "TDFPaymentService.h"
#import <YYModel/YYModel.h>
#import "TDFShowPickerStrategy.h"
#import "TDFCustomStrategy.h"
#import "SystemUtil.h"
#import "GlobalRender.h"
#import "UIHelper.h"
#import "TDFSettleAccountInfo.h"
#import "TDFBusinessFlowViewController.h"
#import "PaymentTypeView.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFMediator+PaymentModule.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UMMobClick/MobClick.h"
#import "SystemUtil.h"
#import "TDFBusinessFlowViewController.h"
#import "TDFEditViewHelper.h"
#import "TDFPaymentVO.h"
#import "TDFPickerActionStrategy.h"
#import "UMMobClick/MobClick.h"
#import "NSString+TDF_Empty.h"
#import "OptionSelectView.h"
#import "HelpDialog.h"
#import "TDFPaymentNoteViewController.h"
@interface TDFPaymentEditViewController ()<OptionSelectClient,FooterListEvent>

@property (nonatomic, strong) DHTTableViewManager            *manager;

@property (nonatomic, strong) UITableView                    *tableViewPayment;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) FooterListView *footView;
#pragma mark 账户信息
@property (nonatomic, strong) DHTTableViewSection *baseSettingSection;
/***账户类型**/
@property (nonatomic, strong) TDFPickerItem    *accountNameLst;
/***组织机构代码**/
@property (nonatomic, strong) TDFTextfieldItem   *orgCode;
/***开户银行**/
@property (nonatomic, strong) TDFPickerItem   *accountBankLst;
/***开户省份**/
@property (nonatomic, strong) TDFPickerItem   *accountProvinceLst;
/***开户城市**/
@property (nonatomic, strong) TDFPickerItem   *accountCityLst;
/***开户支行**/
@property (nonatomic, strong) TDFPickerItem   *accountBranchLst;
/***开户人姓名**/
@property (nonatomic, strong) TDFTextfieldItem   *accountNameTxt;
/***开户人证件类型**/
@property (nonatomic, strong) TDFPickerItem    *identityType;
/***开户人证件号码**/
@property (nonatomic, strong) TDFTextfieldItem   *identityNum;
/***开户人手机**/
@property (nonatomic, strong) TDFTextfieldItem   *mobile;
/***银行卡号**/
@property (nonatomic, strong) TDFLabelItem    *bankAccountLst;

#pragma mark --店铺信息
@property (nonatomic,strong) DHTTableViewSection *shopInfoSection;
/***所在省份**/
@property (nonatomic, strong) TDFPickerItem   *shopProvince;
/***所在城市**/
@property (nonatomic, strong) TDFPickerItem   *shopCity;
/***详细地址**/
@property (nonatomic, strong) TDFTextfieldItem *address;
/***负责人姓名**/
@property (nonatomic, strong) TDFTextfieldItem   *personName;
/***负责人手机**/
@property (nonatomic, strong) TDFTextfieldItem   *personMobile;

@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
@property(nonatomic,strong)TDFSettleAccountInfo *settleAccountInfo;
@property (nonatomic, strong) UIButton *readNoteBtn;
@property (nonatomic, strong) UILabel *headerTip;
@property (nonatomic, strong) NSString *bankName; //记录银行代码
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (weak, nonatomic) NSURLSessionDataTask *networkTask;
@end

@implementation TDFPaymentEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBackground];
    [self configureTableView];
    [self configureNavBar];
    [self configureManager];
    [self loadData];
    [self addBaseSettingSection];
    [self addShopInformationSection];
    self.footView =[[FooterListView alloc] init];
    [self.footView awakeFromNib];
    self.footView.frame =CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WIDTH, 120) ;
    [self.footView initDelegate:self btnArrs:nil];
    [self.footView showHelp:YES];
    [self.view addSubview:self.footView];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)configureBackground
{
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.7;
    [self.view insertSubview:alphaView atIndex:1];
}

- (void)configureTableView
{
    [self.view addSubview:self.tableViewPayment];
}

- (void)configureNavBar
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];
    [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    self.title = NSLocalizedString(@"收款账户", nil);
}

- (void)configureManager
{
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
    [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
    [self.manager registerCell:@"TDFSwitchCell" withItem:@"TDFSwitchItem"];
    [self.manager registerCell:@"TDFLabelCell" withItem:@"TDFLabelItem"];
    [self.manager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
    [self.manager registerCell:@"TDFImageManagerCell" withItem:@"TDFImageManagerItem"];
}


-(void)addBaseSettingSection
{
#pragma mark - 使用两个section防止section header移动
    DHTTableViewSection *baseSettingSectionHeader  = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"账户信息",nil)];
    self.baseSettingSection = [DHTTableViewSection section];
    
    __weak typeof(self) weakSelf = self;
    self.accountNameLst = [[TDFPickerItem alloc] init];
    self.accountNameLst.title = NSLocalizedString(@"账户类型", nil);
    self.accountNameLst.textValue = (self.shopInfoVO.accountType == 2)?NSLocalizedString(@"对公账户(公司或单位开设的账户)", nil) :NSLocalizedString(@"个人账户", nil);
    self.accountNameLst.preValue = self.accountNameLst.textValue;
    TDFShowPickerStrategy *accountTypeStrategy = [[TDFShowPickerStrategy alloc] init];
    accountTypeStrategy.pickerName = self.accountNameLst.title;
    accountTypeStrategy.pickerItemList = [self accountTypeList];
    self.accountNameLst.strategy = accountTypeStrategy;
    self.accountNameLst.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        [weakSelf shouldShowAccountTypeWithTextValue:requestValue];
        return YES;
    };
    
    self.orgCode = [[TDFTextfieldItem alloc] init];
    self.orgCode.title = NSLocalizedString(@"组织机构代码", nil);
    self.orgCode.shouldShow = NO;
    
    
    self.accountBankLst = [[TDFPickerItem alloc] init];
    self.accountBankLst.title = NSLocalizedString(@"开户银行", nil);
    TDFShowPickerStrategy *accountBankStrategy = [[TDFShowPickerStrategy alloc] init];
    accountBankStrategy.pickerName = self.accountBankLst.title;
    accountBankStrategy.pickerItemList = [self accountBankList];
    self.accountBankLst.strategy = accountBankStrategy;
    self.accountBankLst.filterBlock = ^ (NSString *textValue, NSString *requestValue){
        [weakSelf fetchProvinceWithBank:requestValue];
        weakSelf.accountProvinceLst.textValue=nil;
        weakSelf.accountCityLst.textValue = nil;
        weakSelf.accountBranchLst.textValue = nil;
        return YES;
    };
    
    
    self.accountProvinceLst = [[TDFPickerItem alloc] init];
    self.accountProvinceLst.title = NSLocalizedString(@"开户省份", nil);
    TDFCustomStrategy *pStrategy = [[TDFCustomStrategy alloc] init];
    pStrategy.btnClickedBlock = ^ (){
        if (![weakSelf.accountBankLst.textValue isNotEmpty]) {
            [AlertBox show:NSLocalizedString(@"开户银行不能为空", nil)];
        }else{
            [weakSelf fetchProvinceWithBank:self.shopInfoVO.bankName];
        }
    };
    self.accountProvinceLst.strategy =pStrategy;
    self.accountProvinceLst.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        [weakSelf fetchCityWithBankName:weakSelf.bankName WithProvince:requestValue];
        weakSelf.accountCityLst.textValue = nil;
        weakSelf.accountBranchLst.textValue = nil;
        return YES;
    };
    
    
    self.accountCityLst = [[TDFPickerItem alloc] init];
    self.accountCityLst.title = NSLocalizedString(@"开户城市", nil);
    TDFCustomStrategy *cStrategy = [[TDFCustomStrategy alloc] init];
    cStrategy.btnClickedBlock = ^ (){
        if (![weakSelf.accountProvinceLst.textValue isNotEmpty]) {
            [AlertBox show:NSLocalizedString(@"开户省份不能为空", nil)];
        }else{
            [weakSelf fetchCityWithBankName:self.shopInfoVO.bankName WithProvince:self.shopInfoVO.bankProvNo];
        }
    };
    self.accountCityLst.strategy =cStrategy;
    self.accountCityLst.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        return YES;
    };
    
#pragma mark -- 开户支行
    self.accountBranchLst = [[TDFPickerItem alloc] init];
    self.accountBranchLst.title = NSLocalizedString(@"开户支行", nil);
    TDFCustomStrategy *abStrategy = [[TDFCustomStrategy alloc] init];
    abStrategy.btnClickedBlock = ^ (){
        if (![weakSelf.accountCityLst.textValue isNotEmpty]) {
            [AlertBox show:NSLocalizedString(@"开户城市不能为空", nil)];
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            param[@"bank_name"] = self.accountBankLst.requestValue;
            param[@"city_no"] = self.accountCityLst.requestValue;
            
            [[[TDFPaymentService alloc] init] getSubBanksWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self.progressHud hide:YES];
                
                NSArray *array = data[@"data"];
                NSMutableArray<INameItem> *accountBranchList = [NSMutableArray<INameItem> array];
                
                for (NSMutableDictionary *dictionary in array) {
                    ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:dictionary];
                    NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
                    [accountBranchList addObject:nameItem];
                }
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:self.accountBranchLst.textValue andId:self.accountBranchLst.textId];
                [OptionSelectView show:NSLocalizedString(@"开户支行", nil) list:accountBranchList selectData:nameItem target:self editItem:self.accountBranchLst Placeholder:NSLocalizedString(@"输入支行关键字", nil) event:1 isPresentMode:YES];
                [self.manager reloadData];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            } ];
        }
    };
    self.accountBranchLst.strategy =abStrategy;
    self.accountBranchLst.filterBlock = ^(NSString *textValue, NSString *requestValue){
        return YES;
    };
    
    
    self.accountNameTxt = [[TDFTextfieldItem alloc] init];
    self.accountNameTxt.title = NSLocalizedString(@"开户人姓名", nil);
    
    self.identityType = [[TDFPickerItem alloc] init];
    self.identityType.title = NSLocalizedString(@"开户人证件类型", nil);
    self.identityType.textValue = (self.shopInfoVO.holderCardType == 2)?NSLocalizedString(@"护照", nil):NSLocalizedString(@"身份证", nil);
    self.identityType.preValue = self.identityType.textValue;
    TDFShowPickerStrategy *identityStrategy = [[TDFShowPickerStrategy alloc] init];
    identityStrategy.pickerName = self.identityType.title;
    identityStrategy.pickerItemList = [self identifyTypeList];
    self.identityType.strategy = identityStrategy;
    self.identityType.requestKey = @"identityType";
    self.identityType.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        if (![requestValue isEqualToString:weakSelf.identityType.requestKey]) {
            weakSelf.identityNum.textValue = nil;
        }
        return YES;
    };
    
    
    self.identityNum = [[TDFTextfieldItem alloc] init];
    self.identityNum.title = NSLocalizedString(@"开户人证件号码", nil);
    
    self.mobile = [[TDFTextfieldItem alloc] init];
    self.mobile.title = NSLocalizedString(@"开户人手机", nil);
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.bankAccountLst = [[TDFLabelItem alloc] init];
    self.bankAccountLst.title = NSLocalizedString(@"银行卡号", nil);
    
    [self.baseSettingSection addItem:self.accountNameLst];
    [self.baseSettingSection addItem:self.orgCode];
    [self.baseSettingSection addItem:self.accountBankLst];
    [self.baseSettingSection addItem:self.accountProvinceLst];
    [self.baseSettingSection addItem:self.accountCityLst];
    [self.baseSettingSection addItem:self.accountBranchLst];
    [self.baseSettingSection addItem:self.accountNameTxt];
    [self.baseSettingSection addItem:self.identityType];
    [self.baseSettingSection addItem:self.identityNum];
    [self.baseSettingSection addItem:self.mobile];
    [self.baseSettingSection addItem:self.bankAccountLst];
    
    [self.manager addSection:baseSettingSectionHeader];
    [self.manager addSection:self.baseSettingSection];
}

#pragma mark --协议
- (BOOL)selectOption:(id<INameItem>)data editItem:(id)editItem
{
    self.accountBranchLst.textValue = [data obtainItemName];
    self.accountBranchLst.requestValue = [data obtainItemId];
    //   self.accountBranchLst.preValue = self.accountBranchLst.textValue;
    [self.manager reloadData];
    return YES;
}

- (void)shouldShowAccountTypeWithTextValue:(NSString *)textValue
{
    if ([textValue isEqualToString:@"1"]) {
        self.accountNameLst.textValue = NSLocalizedString(@"个人账户", nil);
        self.accountNameTxt.title = NSLocalizedString(@"开户人姓名", nil) ;
        self.orgCode.shouldShow = NO;
        self.identityType.shouldShow = YES;
        self.identityNum.shouldShow = YES;
        self.identityType.textValue =NSLocalizedString(@"身份证", nil);
    } else {
        self.accountNameLst.textValue = NSLocalizedString(@"对公账户(公司或单位开设的账户)", nil);
        self.accountNameTxt.title = NSLocalizedString(@"对公账户名称", nil) ;
        
        self.orgCode.shouldShow = YES;
        self.identityType.shouldShow = NO;
        self.identityNum.shouldShow = NO;
    }
    [self.manager reloadData];
}


- (NSMutableArray<INameItem> *)accountTypeList
{
    NSMutableArray<INameItem> *accountTypeList = [NSMutableArray<INameItem> array];
    NameItemVO *valueVO = [[NameItemVO alloc] init];
    valueVO.itemId = @"1";
    valueVO.itemName = NSLocalizedString(@"个人账户", nil);
    valueVO.itemValue = @"1";
    
    NameItemVO *valueVOOne = [[NameItemVO alloc] init];
    valueVOOne.itemId = @"2";
    valueVOOne.itemName =  NSLocalizedString(@"对公账户(公司或单位开设的账户)", nil);
    valueVOOne.itemValue = @"2";
    
    [accountTypeList addObject:valueVO];
    [accountTypeList addObject:valueVOOne];
    
    return accountTypeList;
}

- (NSMutableArray<INameItem> *)accountBankList
{
    NSMutableArray<INameItem> *accountBankList = [NSMutableArray<INameItem> array];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[[TDFPaymentService alloc] init] getBanksWithParam:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        
        [self.progressHud hide:YES];
        NSArray *array = data[@"data"];
        for (NSMutableDictionary *dictionary in array) {
            ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:dictionary];
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.bankDisplayName andId:shopInfoVO.bankName];
            [accountBankList addObject:nameItem];
            self.bankName = nameItem.itemId;
        }
        [self.manager reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    return accountBankList;
}


//根据银行名字选择省份
- (void)fetchProvinceWithBank:(NSString *)bankName
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"bank_name"] = bankName;
    self.bankName = bankName;
    
    [[[TDFPaymentService alloc] init] getProvinceWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        NSArray *array = data[@"data"];
        NSMutableArray<INameItem> *accountProvinceList = [NSMutableArray<INameItem> array];
        for (NSMutableDictionary *dictionary in array) {
            ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:dictionary];
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.provinceName andId:shopInfoVO.provinceNo];
            [accountProvinceList addObject:nameItem];
        }
        TDFShowPickerStrategy *provinceStrategy = [[TDFShowPickerStrategy alloc] init];
        provinceStrategy.pickerName = self.accountProvinceLst.title;
        provinceStrategy.pickerItemList = accountProvinceList;
        self.accountProvinceLst.strategy = provinceStrategy;
        [self.manager reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

//根据银行和省份选择城市
-(void)fetchCityWithBankName:(NSString *)bankName WithProvince:(NSString *)province
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"bank_name"] =  bankName;
    param[@"province_no"] = province;
    
    [[[TDFPaymentService alloc] init] getCitiesWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        
        NSArray *array = data[@"data"];
        NSMutableArray<INameItem> *accountCityList = [NSMutableArray<INameItem> array];
        for (NSMutableDictionary *dictionary in array) {
            ShopInfoVO *shopInfoVO = [[ShopInfoVO alloc] initWithDictionary:dictionary];
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.cityName andId:shopInfoVO.cityNo];
            [accountCityList addObject:nameItem];
        }
        
        TDFShowPickerStrategy *cityStrategy = [[TDFShowPickerStrategy alloc] init];
        cityStrategy.pickerName = self.accountCityLst.title;
        cityStrategy.pickerItemList = accountCityList;
        self.accountCityLst.strategy = cityStrategy;
        
        [self.manager reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
}


- (NSMutableArray<INameItem> *)identifyTypeList
{
    NSMutableArray<INameItem> *identifyTypeList = [NSMutableArray<INameItem> array];
    NameItemVO *valueVO = [[NameItemVO alloc] init];
    valueVO.itemId = @"1";
    valueVO.itemName = NSLocalizedString(@"身份证", nil) ;
    valueVO.itemValue = @"1";
    
    NameItemVO *valueVOOne = [[NameItemVO alloc] init];
    valueVOOne.itemId = @"2";
    valueVOOne.itemName = NSLocalizedString(@"护照", nil) ;
    valueVOOne.itemValue = @"2";
    
    [identifyTypeList addObject:valueVO];
    [identifyTypeList addObject:valueVOOne];
    
    return identifyTypeList;
}


- (void)addShopInformationSection
{
    DHTTableViewSection *shopInfoSectionHeader  = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"店铺信息", nil) ];
    self.shopInfoSection = [DHTTableViewSection section];
    
    __weak typeof(self) weakSelf = self;
    self.shopProvince = [[TDFPickerItem alloc] init];
    self.shopProvince.title =NSLocalizedString(@"所在省份",nil);
    TDFShowPickerStrategy *shopProvinceStrategy = [[TDFShowPickerStrategy alloc] init];
    shopProvinceStrategy.pickerName = self.shopProvince.title;
    shopProvinceStrategy.pickerItemList = [self shopProvinceList];
    self.shopProvince.strategy = shopProvinceStrategy;
    self.shopProvince.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        [weakSelf fetchShopCityWithProvince:requestValue];
        weakSelf.shopCity.textValue = nil;
        weakSelf.address.textValue = nil;
        return YES;
    };
    
    self.shopCity = [[TDFPickerItem alloc] init];
    self.shopCity.title =NSLocalizedString( NSLocalizedString(@"所在城市", nil),nil);
    TDFCustomStrategy *scStrategy = [[TDFCustomStrategy alloc] init];
    scStrategy.btnClickedBlock = ^ (){
        if (![weakSelf.accountBankLst.textValue isNotEmpty]) {
            [AlertBox show:NSLocalizedString(@"所在省份不能为空",nil)];
        }else{
            [weakSelf fetchShopCityWithProvince:weakSelf.shopInfoVO.locusProvince];
        }
    };
    self.shopCity.strategy = scStrategy;
    self.shopCity.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
        [weakSelf fetchShopCityWithProvince:requestValue];
        weakSelf.address.textValue = nil;
        return YES;
    };
    
    self.address = [[TDFTextfieldItem alloc] init];
    self.address.title = NSLocalizedString(@"详细地址",nil);
    
    self.personName = [[TDFTextfieldItem alloc] init];
    self.personName.title =NSLocalizedString( NSLocalizedString(@"负责人姓名", nil),nil);
    
    self.personMobile = [[TDFTextfieldItem alloc] init];
    self.personMobile.title = NSLocalizedString(@"负责人手机",nil);
    self.personMobile.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.shopInfoSection addItem:self.shopProvince];
    [self.shopInfoSection addItem:self.shopCity];
    [self.shopInfoSection addItem:self.address];
    [self.shopInfoSection addItem:self.personName];
    [self.shopInfoSection addItem:self.personMobile];
    
    [self.manager addSection:shopInfoSectionHeader];
    [self.manager addSection:self.shopInfoSection];
}

-(NSMutableArray<INameItem> *)shopProvinceList
{
    NSMutableArray<INameItem> *shopProvinceList = [NSMutableArray<INameItem> array];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    [[[TDFPaymentService alloc] init] getShopProvinceWithParam:nil sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        [self.progressHud hide:YES];
        NSArray *array = data[@"data"];
        for (NSDictionary *dictionary in array) {
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:dictionary[@"provinceName"] andId:dictionary[@"provinceNo"]];
            [shopProvinceList addObject:nameItem];
        }
        [self.manager reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    
    return shopProvinceList;
}

//根据店铺的省份选择城市
- (void)fetchShopCityWithProvince:(NSString *)shopProvince
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"province_no"] = shopProvince;
    
    [[[TDFPaymentService alloc] init] getShopCitiesWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        
        [self.progressHud hide:YES];
        NSArray *array = data[@"data"];
        NSMutableArray<INameItem> *shopCityList = [NSMutableArray<INameItem> array];
        for (NSMutableDictionary *dictionary in array) {
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:dictionary[@"cname"] andId:dictionary[@"cno"]];
            [shopCityList addObject:nameItem];
        }
        
        TDFShowPickerStrategy *shopCityStrategy = [[TDFShowPickerStrategy alloc] init];
        shopCityStrategy.pickerName = self.accountCityLst.title;
        shopCityStrategy.pickerItemList = shopCityList;
        self.shopCity.strategy = shopCityStrategy;
        [self.manager reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma mark --导航条事件
- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[self isAnyTipsShowed]];
    [self umengEvent:@"click_cancel_bank_account" attributes:nil number:@(1)];
}

#pragma mark --点击提交按钮
- (void)rightNavigationButtonAction:(id)sender
{
    [super rightNavigationButtonAction:sender];
    [self umengEvent:@"click_commit_bank_account" attributes:nil  number:@(1)];
    if ([self isValid]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"收款账户提交成功后,1个月只能变更1次,且变更可能需要较长的审核时间,确定要提交吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:NSLocalizedString(@"再检查下", nil), nil];
        alertView.tag=2;
        [alertView show];
    }else{
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            return;
        }else{
            [self showProgressHudWithText:NSLocalizedString(@"正在提交", nil)];
            [[[TDFPaymentService alloc] init] applyElectronicPaymentWithParam:[self promotionJson] sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
                [self.progressHud hide:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_TYPE_VIEW_CHANGE_NOTIFCATION" object:nil];
                //若是首次提交，直接显示提交成功，返回上一个页面
                if (self.settleAccountInfo.authStatus == 0 || self.settleAccountInfo.authStatus == 2) {
                    [SystemUtil showMessage:NSLocalizedString(@"  提交成功  ", nil)];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ( self.settleAccountInfo.authStatus == 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else{
                    // 若是进件过要变更，则跳转到变更等待页面
                    NSInteger auditStatus = 1;
                    [self.navigationController pushViewController:[[TDFMediator sharedInstance]TDFMediator_paymentStatusViewControllerWithStatus:auditStatus]animated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

- (void)loadData
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [[TDFPaymentService new] getElectronicPaymentWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.shopInfoVO = [ShopInfoVO yy_modelWithDictionary:data[@"data"]];
        self.settleAccountInfo  = [TDFSettleAccountInfo yy_modelWithDictionary:data[@"data"][@"settleAccountInfo"]];
        if(self.settleAccountInfo.authStatus == 1 &&self.settleAccountInfo.auditStatus == 3){
            if (self.settleAccountInfo.auditMessage.length == 0) {
                self.headerTip.text = NSLocalizedString(@"您提交的收款账户变更审核未通过，请及时修改", nil);}
            else{
                self.headerTip.text = [NSString stringWithFormat:NSLocalizedString(@"您提交的收款账户变更审核未通过，原因是%@，请及时修改", nil),self.settleAccountInfo.auditMessage];}
        }else if(self.settleAccountInfo.authStatus == 1 &&self.settleAccountInfo.auditStatus == 2){
            NSString *modiTime = [NSString stringWithFormat:@"%ld",self.settleAccountInfo.opTime];
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:([modiTime doubleValue] / 1000.0)];
            NSString* dateStr=[DateUtils formatTimeWithDate:date2 type:TDFFormatTimeTypeChineseWithoutDay];
            self.headerTip.text = [NSString stringWithFormat:NSLocalizedString(@"以下信息请仔细填写，提交成功后，1个月只能变更1次。上次变更时间是%@，如需紧急变更，请联系客服:4000288255。", nil),dateStr];
        }else if(self.settleAccountInfo.authStatus == 0 || self.settleAccountInfo.authStatus == 2 || (self.settleAccountInfo.authStatus == 1 &&self.settleAccountInfo.auditStatus == 0)){
            //未进件，进件失败状态
            self.headerTip.text = NSLocalizedString(@"以下信息请仔细填写，提交成功后，1个月只能变更1次。如需紧急变更，请联系客服:4000288255。", nil);
        }
        
        if (self.settleAccountInfo.authStatus == 1 || self.shopInfoVO.bankAccount .length > 0) {
            [self.readNoteBtn setBackgroundImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
            self.readNoteBtn.selected = YES;
            self.readNoteBtn.userInteractionEnabled = NO;
        } else {
            [self.readNoteBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
            self.readNoteBtn.selected = NO;
        }
        [self configureData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void)configureData
{
    //    NSInteger accountType = self.shopInfoVO.accountType;
    //    for (NameItemVO *nameVO in [self accountTypeList]) {
    //        if ([nameVO.itemId integerValue] ==accountType) {
    //            self.accountNameLst.textValue = nameVO.itemName;
    //            self.accountNameLst.requestValue = nameVO.itemId;
    //            self.accountNameLst.preValue = self.accountNameLst.textValue;
    //            ((TDFShowPickerStrategy *)self.accountNameLst.strategy).selectedItem = nameVO;
    //        }
    //    }
    if (self.shopInfoVO.accountType == 1) {
        self.accountNameLst.textValue = NSLocalizedString(@"个人账户", nil);
        self.accountNameTxt.title = NSLocalizedString(@"开户人姓名", nil) ;
        self.orgCode.shouldShow = NO;
        self.identityType.shouldShow = YES;
        self.identityNum.shouldShow = YES;
        self.identityType.textValue =NSLocalizedString(@"身份证", nil);
        self.accountNameLst.preValue = self.accountNameLst.textValue;
        [self.manager reloadData];
    }  if (self.shopInfoVO.accountType == 2)  {
        self.accountNameLst.textValue = NSLocalizedString(@"对公账户(公司或单位开设的账户)", nil);
        self.accountNameTxt.title = NSLocalizedString(@"对公账户名称", nil) ;
        self.accountNameLst.preValue = self.accountNameLst.textValue;
        self.orgCode.shouldShow = YES;
        self.identityType.shouldShow = NO;
        self.identityNum.shouldShow = NO;
        [self.manager reloadData];
    }
    
    
    self.orgCode.textValue = self.shopInfoVO.orgNo;
    self.orgCode.requestValue = self.shopInfoVO.orgNo;
    self.orgCode.preValue = self.orgCode.textValue;
    
    self.accountBankLst.textValue = self.shopInfoVO.bankDisplayName;
    self.accountBankLst.requestValue = self.shopInfoVO.bankName;
    self.accountBankLst.preValue = self.accountBankLst.textValue;
    
    self.accountProvinceLst.textValue = self.shopInfoVO.bankProvName;
    self.accountProvinceLst.requestValue = self.shopInfoVO.bankProvNo;
    self.accountProvinceLst.preValue = self.accountProvinceLst.textValue;
    
    self.accountCityLst.textValue = self.shopInfoVO.bankCityName;
    self.accountCityLst.requestValue = self.shopInfoVO.bankCityNo;
    self.accountCityLst.preValue = self.accountCityLst.textValue;
    
    self.accountBranchLst.textValue = self.shopInfoVO.bankSubName;
    self.accountBranchLst.requestValue = self.shopInfoVO.bankSubNo;
    self.accountBranchLst.preValue = self.accountBranchLst.textValue;
    
    self.accountNameTxt.textValue = self.shopInfoVO.bankAccount;
    self.accountNameTxt.requestValue = self.shopInfoVO.bankAccount;
    self.accountNameTxt.preValue = self.accountNameTxt.textValue;
    
    NSInteger identityType = self.shopInfoVO.holderCardType;
    for (NameItemVO *nameVO in [self identifyTypeList]) {
        if ([nameVO.itemId integerValue] ==identityType) {
            self.identityType.textValue = nameVO.itemName;
            self.identityType.requestValue = nameVO.itemId;
            self.identityType.preValue = self.identityType.textValue;
            ((TDFShowPickerStrategy *)self.identityType.strategy).selectedItem = nameVO;
        }
    }
    
    self.identityNum.textValue = self.shopInfoVO.holderCardNo;
    self.identityNum.requestValue = self.shopInfoVO.holderCardNo;
    self.identityNum.preValue = self.identityNum.textValue;
    
    self.mobile.textValue = self.shopInfoVO.holderPhone;
    self.mobile.requestValue = self.shopInfoVO.holderPhone;
    self.mobile.preValue = self.mobile.textValue;
    
    self.bankAccountLst.textValue = self.shopInfoVO.bankCardNumber;
    self.bankAccountLst.requestValue = self.shopInfoVO.bankCardNumber;
    self.bankAccountLst.preValue = self.bankAccountLst.textValue;
    
    //下面那个cell
    self.shopProvince.textValue = self.shopInfoVO.locusProvinceName;
    self.shopProvince.requestValue = self.shopInfoVO.locusProvince;
    self.shopProvince.preValue = self.shopProvince.textValue;
    
    self.shopCity.textValue = self.shopInfoVO.locusCityName;
    self.shopCity.requestValue = self.shopInfoVO.locusCity;
    self.shopCity.preValue = self.shopCity.textValue;
    
    self.address.textValue = self.shopInfoVO.detailAddress;
    self.address.requestValue = self.shopInfoVO.detailAddress;
    self.address.preValue = self.address.textValue;
    
    self.personName.textValue = self.shopInfoVO.ownerName;
    self.personName.requestValue = self.shopInfoVO.ownerName;
    self.personName.preValue = self.personName.textValue;
    
    self.personMobile.textValue = self.shopInfoVO.ownerPhone;
    self.personMobile.requestValue = self.shopInfoVO.ownerPhone;
    self.personMobile.preValue = self.personMobile.textValue;
    
    NSDate *curren = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:NSLocalizedString(@"yyyy年MM月", nil)];
    NSString * currentTime = [formatter stringFromDate:curren];
    
    NSString *modiTime = [NSString stringWithFormat:@"%ld",self.settleAccountInfo.opTime];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:([modiTime doubleValue] / 1000.0)];
    NSString* dateStr=[DateUtils formatTimeWithDate:date2 type:TDFFormatTimeTypeChineseWithoutDay];
    
    if (self.settleAccountInfo.authStatus == 1 && self.settleAccountInfo.auditStatus == 2 && [currentTime isEqualToString:dateStr] && self.shopInfoVO.hasCommit == 1) {
        //   已进件成功且审核通过，所有选项置灰不可点
        
        
        [self isGrayColor];
    }
    
}

-(void)isGrayColor
{
    for (DHTTableViewSection *section in self.manager.sections) {
        for (TDFBaseEditItem *item in section.items) {
            item.editStyle = TDFEditStyleUnEditable;
        }
    }
    [self.manager reloadData];
}

- (NSMutableDictionary *)promotionJson
{
    if (!_paymentDict) {
        _paymentDict = [[NSMutableDictionary  alloc] init];
    }
    _paymentDict[@"entityId"] = [[Platform Instance] getkey:ENTITY_ID];
    _paymentDict[@"shopId"] = [[Platform Instance] getkey:SHOP_ID];
    if ([self.accountNameLst.textValue isEqualToString:NSLocalizedString(@"个人账户", nil)]){
        _paymentDict[@"accountType"] = @"1";
        _paymentDict[@"holderCardNo"] = self.identityNum.requestValue;
    }else{
        _paymentDict[@"accountType"] = @"2";
        _paymentDict[@"orgNo"] = self.orgCode.requestValue;
    }
    if ([self.identityType.textValue isEqualToString:NSLocalizedString(@"身份证", nil)]){
        _paymentDict[@"holderCardType"] = @"1";
    }else{
        _paymentDict[@"holderCardType"] = @"2";
    }
    _paymentDict[@"holderPhone"] = self.mobile.requestValue;
    _paymentDict[@"bankName"] = self.accountBankLst.requestValue;
    _paymentDict[@"bankProvNo"] =  self.accountProvinceLst.requestValue;
    _paymentDict[@"bankCityNo"] = self.accountCityLst.requestValue;
    _paymentDict[@"bankSubNo"] = self.accountBranchLst.requestValue;
    _paymentDict[@"bankCardNumber"] = self.bankAccountLst.requestValue;
    _paymentDict[@"bankAccount"] = self.accountNameTxt.textValue;
    //新增
    _paymentDict[@"locusProvince"] = self.shopProvince.requestValue;
    _paymentDict[@"locusCity"] = self.shopCity.requestValue;
    _paymentDict[@"ownerName"] = self.personName.requestValue;
    _paymentDict[@"ownerPhone"] = self.personMobile.requestValue;
    _paymentDict[@"detailAddress"] = self.address.requestValue;
    
    return _paymentDict;
}


-(BOOL)isValid
{
    NSString *message = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.manager.sections withIgnoredCharator:@""];
    
    if (message) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:message cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    
    if ([self.bankAccountLst.textValue integerValue]<=5) {
        [self showMessageWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入正确的银行卡号", nil) cancelTitle:NSLocalizedString(@"我知道了", nil)];
        return NO;
    }
    if (self.mobile.textValue.length<11 || self.mobile.textValue.length>11 ) {
        [AlertBox show:NSLocalizedString(@"开户人手机填写有误，应为11位数字", nil)];
        return NO;
    }if (self.personMobile.textValue.length<11 ||self.personMobile.textValue.length>11 ) {
        [AlertBox show:NSLocalizedString(@"负责人手机填写有误，应为11位数字", nil)];
        return NO;
    }
    if (self.readNoteBtn.selected == NO) {
        [AlertBox show:NSLocalizedString(@"请您阅读并同意《电子支付代收代付协议》", nil)];
        return NO;
    }
    return YES;
}

#pragma mark -- Notification
- (void)shouldChangeNavTitles:(NSNotification *)notification
{
    if ([self isAnyTipsShowed]) {
        [self configRightNavigationBar:@"ico_ok" rightButtonName:NSLocalizedString(@"提交", nil)];
        [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"取消", nil)];
    } else {
        [self configRightNavigationBar:@"" rightButtonName:@""];
        [self configLeftNavigationBar:@"ico_back" leftButtonName:NSLocalizedString(@"返回", nil)];
    }
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- Setters && Getters --
- (UITableView *)tableViewPayment
{
    if (!_tableViewPayment) {
        _tableViewPayment = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableViewPayment.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _tableViewPayment.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewPayment.backgroundColor = [UIColor clearColor];
    }
    //headerView
    _tableViewPayment.tableHeaderView =self.tableHeaderView;
    _tableViewPayment.tableFooterView =self.tableFooterView;
    
    return _tableViewPayment;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        
        UIImageView *warnImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        warnImage.image = [UIImage imageNamed:@"ico_warning_r.png"];
        [_tableHeaderView addSubview:warnImage];
        
        [warnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            make.top.equalTo(_tableHeaderView.mas_top).with.offset(15);
            make.left.equalTo(_tableHeaderView.mas_left).with.offset(10);
        }];
        
        _headerTip =[[UILabel alloc]init];
        _headerTip.font = [UIFont systemFontOfSize:11];
        _headerTip.textColor = [ColorHelper getRedColor];
        _headerTip.numberOfLines = 0;
        
        [_tableHeaderView addSubview:_headerTip];
        [_headerTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableHeaderView.mas_top).with.offset(5);
            make.left.equalTo(_tableHeaderView.mas_left).with.offset(35);
            make.right.equalTo(_tableHeaderView.mas_right).with.offset(-10);
            make.height.mas_equalTo(45);
        }];
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        //footerView
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        
        _readNoteBtn= [[UIButton alloc]init];
        [_readNoteBtn addTarget:self action:@selector(clickPaymentNoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.readNoteBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
        [_tableFooterView addSubview:_readNoteBtn];
        
        [_readNoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableFooterView.mas_left).offset(10);
            make.top.equalTo(_tableFooterView.mas_top).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        
        UILabel *normalLabel =[[UILabel alloc] init];
        normalLabel.textColor = [ColorHelper getBlackColor];
        normalLabel.font = [UIFont systemFontOfSize:12];
        normalLabel.userInteractionEnabled = NO;
        normalLabel.text= NSLocalizedString(@"我已阅读并同意", nil);
        [_tableFooterView addSubview:normalLabel];
        
        [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.readNoteBtn.mas_right).offset(5);
//            make.top.equalTo(_tableFooterView.mas_top).offset(17);
            make.centerY.equalTo (self.readNoteBtn.mas_centerY).offset(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        UILabel *linkLabel = [[UILabel alloc] init];
        linkLabel.textColor = [ColorHelper getBlueColor];
        linkLabel.font = [UIFont systemFontOfSize:12];
        linkLabel.userInteractionEnabled = YES;
        linkLabel.numberOfLines = 0;
        NSString *text = NSLocalizedString(@"《兴业银行第三方移动支付商户服务协议（财付通版）》", nil);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, text.length)];
        linkLabel.attributedText = attributedString;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tap addTarget:self action:@selector(goToPaymentNote)];
        [linkLabel addGestureRecognizer:tap];
        [_tableFooterView addSubview:linkLabel];
        
        [linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(normalLabel.mas_right).offset(0);
            make.top.equalTo(_tableFooterView.mas_top).offset(17);
            make.height.mas_equalTo(40);
            make.right.equalTo(_tableFooterView.mas_right).offset(-10);
        }];
        
        UILabel *lblTiShiLabel = [[UILabel alloc] init];
        lblTiShiLabel.textColor = [ColorHelper getRedColor];
        lblTiShiLabel.font = [UIFont systemFontOfSize:11];
        lblTiShiLabel.text = [NSString stringWithFormat:NSLocalizedString(@" 提示：\n1.建议您绑定开户银行是主流银行的账户，比如工商银行、农业银行、中国银行、建设银行、招商银行、兴业银行、交通银行等，将会更加及时收到转账金额。\n2.请仔细核对以上信息，收款账户提交成功后，顾客使用电子支付的钱将会转到所填的银行账户。\n3.顾客使用电子支付付款成功后，这笔钱会在第2日中午12：00后自动转账到您所填的收款账户，按协议约定的费率收取服务费。\n4.变更账户后，顾客使用电子支付的钱将会在变更成功后的第2日中午12：00后自动转账到您所填的银行账户。",nil)];
        lblTiShiLabel.numberOfLines = 0;
        [_tableFooterView addSubview:lblTiShiLabel];
        
        [lblTiShiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableFooterView.mas_left).offset(10);
            make.top.equalTo(_tableFooterView.mas_top).offset(40);
            make.height.mas_equalTo(200);
            make.right.equalTo(_tableFooterView.mas_right).offset(-10);
        }];
    }
    return _tableFooterView;
}


- (void)clickPaymentNoteBtnClick
{
    self.readNoteBtn.selected = !self.readNoteBtn.selected;
    if (self.readNoteBtn.selected == YES) {
        [self.readNoteBtn setBackgroundImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
    } else {
        [self.readNoteBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    }
}

- (void)goToPaymentNote
{
    TDFPaymentNoteViewController *vc = [[TDFPaymentNoteViewController alloc] init];
    vc.accountNameTxt = self.shopInfoVO.bankAccount;//户名
    vc.accountBankLst = self.shopInfoVO.bankCardNumber;//银行账号
    vc.bankAccountLst = self.shopInfoVO.bankDisplayName;//银行名称  //查询银行
    
    vc.personMobile = self.shopInfoVO.ownerPhone;
    vc.address = self.shopInfoVO.detailAddress;
    vc.personName = self.shopInfoVO.ownerName;//负责人姓名
    [self.navigationController pushViewController:vc animated:YES];
}

- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableViewPayment];
    }
    
    return _manager;
}

- (TDFPaymentVO *)paymentVO
{
    if (!_paymentVO) {
        _paymentVO = [[TDFPaymentVO alloc] init];
    }
    
    return _paymentVO;
}


- (TDFSettleAccountInfo *)settleAccountInfo
{
    if (!_settleAccountInfo) {
        _settleAccountInfo = [[TDFSettleAccountInfo alloc] init];
    }
    
    return _settleAccountInfo;
}

- (ShopInfoVO *)shopInfoVO
{
    if (!_shopInfoVO) {
        _shopInfoVO = [[ShopInfoVO alloc] init];
    }
    
    return _shopInfoVO;
}

#pragma mark --设置埋点
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}

-(void) showHelpEvent
{
    [HelpDialog show:@"paymentInform"];
}
@end
