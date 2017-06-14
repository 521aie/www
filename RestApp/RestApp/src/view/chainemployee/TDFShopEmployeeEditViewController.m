 //
//  TDFShopEmployeeEditViewController.m
//  RestApp
//
//  Created by 刘红琳 on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopEmployeeEditViewController.h"
#import "YYModel.h"
#import "AlertBox.h"
#import "TDFBaseEditView.h"
#import "TDFUserService.h"
@interface TDFShopEmployeeEditViewController ()
{
    BOOL commonRatioVisibal;
    BOOL forceRatioVisibal;
    BOOL printTimeVisibal;
    BOOL isZeroVisibal;
    BOOL idCardVisabal;
    NSString* isZeroStr;
    NSString *isMaxZeroStr;
    NSString* commonRatioVal;
    NSString* forceRatioVal;
    NSString* printTimeStr;
}
@property (nonatomic,strong) TDFPickerItem *allowRatioItem;
@property (nonatomic,strong) TDFPickerItem *noAllowRatioItem;
@property (nonatomic,strong) TDFPickerItem *lsPrinterTimeItem;
@property (nonatomic,strong) TDFLabelItem *deductPercentItem;
@property (nonatomic,strong) TDFTextfieldItem *idCardItem;
@property (nonatomic, strong) NSMutableDictionary* extraMap;
@end

@implementation TDFShopEmployeeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles) name:kTDFEditViewIsShowTipNotification object:nil];
    if (self.employeeType == TDFEmployeeAdd) {
        [self loadAllExtraActions];
    }else{
        [self loadEmployeeeData:self.employeeId];
    }
}

- (void) loadEmployeeeData:(NSString *)employeeId
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"employee_id"] = employeeId;
    [parma setObject:@"1" forKey:@"type"];
    
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
    
    if ([memberExtendDic isKindOfClass:[NSNull class]]) {
        memberExtendDic = @{};
    }
    
    self.memberExtend = [MemberExtend convertToMemberExtend:memberExtendDic];
    if (self.employee.userVo.isSupper != 1) {
        [self addBaseSettingSection];
        [self addAccountInfoSection];
        [self addIdentifierInfoSection];
        [self fillFormData:self.employee.extraActionVoList];
        self.tableView.tableFooterView = self.tableViewFooterView;
    }else{
        [self addAccountInfoSection];
        [self fillFormData:self.employee.extraActionVoList];
        self.tableView.tableFooterView = nil;
    }
    [self.manager reloadData];
}


#pragma 初始化额外权限
//添加时获得的所有额外权限.
- (void)loadAllExtraActions
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    
    @weakify(self);
    [[TDFChainService new] getExtraActionListWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        NSMutableArray *extraActions = [[NSArray yy_modelArrayWithClass:[ExtraActionVo class] json:data[@"data"]] mutableCopy];
        [self fillFormData:extraActions];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)fillFormData:(NSMutableArray*) extraActions
{
    self.extraMap=[NSMutableDictionary dictionary];
    for (ExtraActionVo* act in extraActions) {
        [self.extraMap setObject:act forKey:act.code];
    }
    ExtraActionVo* extra=[self.extraMap objectForKey:@"0001"];
    if (extra) {
    }
    extra=[self.extraMap objectForKey:@"0002"];
    if (extra) {
        commonRatioVal=@"100";
        if ([NSString isNotBlank:extra.value]) {
            commonRatioVal=extra.value;
        }
        commonRatioVisibal = ![@"100" isEqualToString:commonRatioVal];
    }
    
    extra=[self.extraMap objectForKey:@"0003"];
    if (extra) {
        forceRatioVal=@"100";
        if ([NSString isNotBlank:extra.value]) {
            forceRatioVal=extra.value;
        }
        forceRatioVisibal = ![@"100" isEqualToString:forceRatioVal];
    }
    
    extra=[self.extraMap objectForKey:@"0004"];
    if (extra) {
        printTimeStr=@"0";
        if ([NSString isNotBlank:extra.value]) {
            printTimeStr=extra.value;
        }
        int printTime=printTimeStr.intValue;
        printTimeVisibal=printTime>0;
    }
    
    extra=[self.extraMap objectForKey:@"0005"];
    if (extra) {
        isZeroStr=@"1";
        if ([NSString isNotBlank:extra.value]) {
            isZeroStr=extra.value;
        }
        isZeroVisibal = isZeroStr.boolValue;
    }
    
    extra=[self.extraMap objectForKey:@"0006"];
    if (extra) {
        isMaxZeroStr = extra.value;
    }
    
    [self addAdvancedSettingSection];
    [self.manager reloadData];
}

- (void) addAdvancedSettingSection
{
    DHTTableViewSection *addAdvancedSettingSection = [DHTTableViewSection sectionWithTitleHeader:NSLocalizedString(@"高级设置", nil)];
    DHTTableViewSection *section = [DHTTableViewSection section];
    
    TDFSwitchItem *switchRdoIsSaleItem = [[TDFSwitchItem alloc] init];
    switchRdoIsSaleItem.title = NSLocalizedString(@"此员工是售卡人", nil);
    switchRdoIsSaleItem.isOn = self.employee.userVo.isCardSeller;
    switchRdoIsSaleItem.preValue = @(self.employee.userVo.isCardSeller);
    switchRdoIsSaleItem.detail = NSLocalizedString(@"注:在会员管理的发卡和充值时可选择售卡人", nil);
    switchRdoIsSaleItem.filterBlock = ^(BOOL isOn) {
        self.userTemp.isCardSeller = isOn;
        return YES;
    };
    [section addItem:switchRdoIsSaleItem];
    
    TDFSwitchItem *switchRdoCommonRatioItem = [[TDFSwitchItem alloc] init];
    switchRdoCommonRatioItem.title = NSLocalizedString(@"允许对可打折的商品进行打折", nil);
    switchRdoCommonRatioItem.isOn = commonRatioVisibal?YES:NO;
    switchRdoCommonRatioItem.preValue = @(commonRatioVisibal?YES:NO);
    switchRdoCommonRatioItem.detail = nil;
    switchRdoCommonRatioItem.filterBlock = ^(BOOL isOn) {
        commonRatioVisibal = isOn ?1:0;;
        self.allowRatioItem.shouldShow = isOn;
        [self.manager reloadData];
        return YES;
    };
    [section addItem:switchRdoCommonRatioItem];
    [section addItem:self.allowRatioItem];
    
    TDFSwitchItem *switchRdoForceRatioItem = [[TDFSwitchItem alloc] init];
    switchRdoForceRatioItem.title = NSLocalizedString(@"允许对不可打折的商品进行打折", nil);
    switchRdoForceRatioItem.isOn = forceRatioVisibal?YES:NO;
    switchRdoForceRatioItem.preValue = @(forceRatioVisibal?YES:NO);
    switchRdoForceRatioItem.detail = nil;
    switchRdoForceRatioItem.filterBlock = ^(BOOL isOn) {
        forceRatioVisibal = isOn ?1:0;;
        self.noAllowRatioItem.shouldShow = isOn;
        [self.manager reloadData];
        return YES;
    };
    [section addItem:switchRdoForceRatioItem];
    [section addItem:self.noAllowRatioItem];
    
    TDFSwitchItem *switchRdoPrinterTimeItem = [[TDFSwitchItem alloc] init];
    switchRdoPrinterTimeItem.title = NSLocalizedString(@"财务联打印的次数限制", nil);
    switchRdoPrinterTimeItem.isOn = printTimeVisibal?YES:NO;
    switchRdoPrinterTimeItem.preValue = @(printTimeVisibal?YES:NO);
    switchRdoPrinterTimeItem.detail = nil;
    switchRdoPrinterTimeItem.filterBlock = ^(BOOL isOn) {
        printTimeVisibal = isOn ?1:0;;
        self.lsPrinterTimeItem.shouldShow = isOn;
        [self.manager reloadData];
        return YES;
    };
    [section addItem:switchRdoPrinterTimeItem];
    [section addItem:self.lsPrinterTimeItem];
    
    TDFSwitchItem *switchItem = [[TDFSwitchItem alloc] init];
    switchItem.title = NSLocalizedString(@"限制去零额度", nil);
    switchItem.isOn = isZeroVisibal;
    switchItem.preValue = @(isZeroVisibal);
    switchItem.detail = nil;
    switchItem.filterBlock = ^(BOOL isOn) {
        isZeroVisibal = isOn;
        self.deductPercentItem.shouldShow = isOn;
        [self.manager reloadData];
        return YES;
    };
    [section addItem:switchItem];
    [section addItem:self.deductPercentItem];
    
    TDFSwitchItem *switchIdCardItem = [[TDFSwitchItem alloc] init];
    switchIdCardItem.title = NSLocalizedString(@"使用ID卡登录", nil);
    idCardVisabal = [NSString isNotBlank:self.employee.userVo.cardNo]?YES:NO;
    switchIdCardItem.isOn = idCardVisabal;
    switchIdCardItem.preValue = @(idCardVisabal);
    switchIdCardItem.detail = nil;
    switchIdCardItem.filterBlock = ^(BOOL isOn) {
        idCardVisabal = isOn;
        self.idCardItem.shouldShow = isOn;
        [self.manager reloadData];
        return YES;
    };
    [section addItem:switchIdCardItem];
    [section addItem:self.idCardItem];
    
    [self.manager addSection:addAdvancedSettingSection];
    [self.manager addSection:section];
}

- (TDFPickerItem *)allowRatioItem {
    if(!_allowRatioItem) {
        _allowRatioItem = [[TDFPickerItem alloc] init];
        _allowRatioItem.title = NSLocalizedString(@"▪︎ 最低打折额度(%)", nil);
        _allowRatioItem.textValue = commonRatioVal;
        _allowRatioItem.preValue = commonRatioVal;
        NameItemVO *item = [[self getRebateItemList] lastObject];
        if(self.employeeType == TDFEmployeeEdit) {
            for (NameItemVO *obj in [self getRebateItemList]) {
                if([[obj obtainItemName] isEqualToString:commonRatioVal]) {
                    item = obj;
                }
            }
        }
        _allowRatioItem.textValue = [item obtainItemName];
        _allowRatioItem.preValue = [item obtainItemName];
        TDFShowPickerStrategy *strategy = [[TDFShowPickerStrategy alloc] init];
        strategy.pickerName = NSLocalizedString(@"▪︎ 最低打折额度(%)", nil);
        strategy.selectedItem = item;
        strategy.pickerItemList = [self getRebateItemList];
        _allowRatioItem.strategy = strategy;
        //        @weakify(self);
        _allowRatioItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            //            @strongify(self);
            commonRatioVal = textValue;
            return YES;
        };
        _allowRatioItem.shouldShow = commonRatioVisibal;
    }
    return _allowRatioItem;
}

- (TDFPickerItem *)noAllowRatioItem {
    if(!_noAllowRatioItem) {
        _noAllowRatioItem = [[TDFPickerItem alloc] init];
        _noAllowRatioItem.title = NSLocalizedString(@"▪︎ 最低打折额度(%)", nil);
        _noAllowRatioItem.textValue = forceRatioVal;
        _noAllowRatioItem.preValue = forceRatioVal;
        NameItemVO *item = [[self getRebateItemList] lastObject];
        if(self.employeeType == TDFEmployeeEdit) {
            for (NameItemVO *obj in [self getRebateItemList]) {
                if([[obj obtainItemName] isEqualToString:forceRatioVal]) {
                    item = obj;
                }
            }
        }
        _noAllowRatioItem.textValue = [item obtainItemName];
        _noAllowRatioItem.preValue = [item obtainItemName];
        TDFShowPickerStrategy *strategy = [[TDFShowPickerStrategy alloc] init];
        strategy.pickerName = NSLocalizedString(@"▪︎ 最低打折额度(%)", nil);
        strategy.selectedItem = item;
        strategy.pickerItemList = [self getRebateItemList];
        _noAllowRatioItem.strategy = strategy;
        //        @weakify(self);
        _noAllowRatioItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            //            @strongify(self);
            forceRatioVal = textValue;
            return YES;
        };
        _noAllowRatioItem.shouldShow = forceRatioVisibal;
    }
    return _noAllowRatioItem;
}

- (TDFPickerItem *)lsPrinterTimeItem {
    if(!_lsPrinterTimeItem) {
        _lsPrinterTimeItem = [[TDFPickerItem alloc] init];
        _lsPrinterTimeItem.title = NSLocalizedString(@"▪︎ 最多打印次数", nil);
        _lsPrinterTimeItem.textValue = printTimeStr;
        _lsPrinterTimeItem.preValue = printTimeStr;
        NameItemVO *item = [[self getRebateItemList] firstObject];
        if(self.employeeType == TDFEmployeeEdit) {
            for (NameItemVO *obj in [self getRebateItemList]) {
                if([[obj obtainItemName] isEqualToString:printTimeStr]) {
                    item = obj;
                }
            }
        }
        _lsPrinterTimeItem.textValue = [item obtainItemName];
        _lsPrinterTimeItem.preValue = [item obtainItemName];
        TDFShowPickerStrategy *strategy = [[TDFShowPickerStrategy alloc] init];
        strategy.pickerName = NSLocalizedString(@"▪︎ 最多打印次数", nil);
        strategy.selectedItem = item;
        strategy.pickerItemList = [self getRebateItemList];
        _lsPrinterTimeItem.strategy = strategy;
        //        @weakify(self);
        _lsPrinterTimeItem.filterBlock = ^ (NSString *textValue, NSString *requestValue) {
            //            @strongify(self);
            printTimeStr = textValue;
            return YES;
        };
        _lsPrinterTimeItem.shouldShow = printTimeVisibal;
    }
    return _lsPrinterTimeItem;
}

- (TDFLabelItem *)deductPercentItem {
    if(!_deductPercentItem) {
        _deductPercentItem = [[TDFLabelItem alloc] init];
        _deductPercentItem.title = NSLocalizedString(@"▪︎ 最大可去零额度(元)", nil);
        _deductPercentItem.shouldClearWhenBeginEditing = YES;
        _deductPercentItem.preValue = _deductPercentItem.textValue = isMaxZeroStr;
        _deductPercentItem.keyboardType = TDFNumbericKeyboardTypeFloat;
        _deductPercentItem.filterBlock = ^(NSString *textValue){
            isMaxZeroStr = textValue;
            return YES;
        };
        _deductPercentItem.shouldShow = isZeroVisibal;
    }
    return _deductPercentItem;
}

- (NSMutableArray *)getRebateItemList{
    
    NSMutableArray<INameItem> *array = [NSMutableArray<INameItem> array];
    
    for (int i = 0; i <= 100; i++) {
        NameItemVO *value = [[NameItemVO alloc] init];
        value.itemId = [NSString stringWithFormat:@"%i",i];
        value.itemName = [NSString stringWithFormat:@"%i",i];
        value.itemValue = [NSString stringWithFormat:@"%i",i];
        [array addObject:value];
    }
    
    return array;
}


- (NSMutableArray*)transExtraActions{
    NSMutableArray *list = [NSMutableArray array];
    ExtraActionVo* act=[self.extraMap objectForKey:@"0001"];
    NSString* val=@"";
    if (act) {
        act.value = nil;
        [list addObject:act];
    }
    
    act=[self.extraMap objectForKey:@"0002"];
    if (act) {
        val=[NSString isBlank:commonRatioVal]?@"100":commonRatioVal;
        act.value = commonRatioVisibal?val:@"100";
        [list addObject:act];
    }
    
    act=[self.extraMap objectForKey:@"0003"];
    if (act) {
        val=[NSString isBlank:forceRatioVal]?@"100":forceRatioVal;
        act.value = forceRatioVisibal?val:@"100";
        [list addObject:act];
    }
    
    act=[self.extraMap objectForKey:@"0004"];
    if (act) {
        act.value = printTimeVisibal?printTimeStr:@"0";
        [list addObject:act];
    }
    
    act=[self.extraMap objectForKey:@"0005"];
    if (act) {
        act.value =[NSString stringWithFormat:@"%d",isZeroVisibal];
        [list addObject:act];
    }
    
    act=[self.extraMap objectForKey:@"0006"];
    if (act) {
        act.value = isMaxZeroStr?isMaxZeroStr:@"10";
        [list addObject:act];
    }
    
    return list;
}
- (TDFTextfieldItem *) idCardItem
{
    if (!_idCardItem) {
        _idCardItem = [[TDFTextfieldItem alloc] init];
        _idCardItem.title = NSLocalizedString(@"▪︎ ID卡号", nil);
        _idCardItem.detail = NSLocalizedString(@"提示：请输入ID卡上印刷的ID号，此号码是出厂时的卡片ID号，不是您自己对卡片的编号。如果卡片上没有印刷ID号或者您无法确定号码是否正确，可以将刷卡器连接到安卓收银设备，在任意有录入框的地方（登录界面除外），点击录入框并刷卡，即可得到此卡片的ID号。", nil);
        _idCardItem.textValue = [NSString isBlank:self.employee.userVo.cardNo]?@"":self.employee.userVo.cardNo;
        _idCardItem.preValue = [NSString isBlank:self.employee.userVo.cardNo]?@"":self.employee.userVo.cardNo;
        _idCardItem.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self);
        _idCardItem.filterBlock = ^(NSString *textValue) {
            @strongify(self);
            self.userTemp.cardNo = textValue;
            return YES;
        };
        _idCardItem.shouldShow = idCardVisabal;
    }
    return _idCardItem;
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

- (void)save
{
    if (![self isValidShop]) {
        return;
    }
    if (![super isValid]) {
        return ;
    }
    //处理普通员工更新.
    EmployeeUserVo *objTemp = [EmployeeUserVo new];
    objTemp.employeeVo = self.employeeVo;
    objTemp.userVo = self.userTemp;
    objTemp.userVo.username = self.userTemp.userName;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ExtraActionVo *vo in [self transExtraActions]) {
        [arr addObject:[JsonHelper getObjectData:vo]];
    }
    objTemp.extraActionVoList = arr;
    
    [[Platform Instance] saveKeyWithVal:DEFAULT_ROLE withVal:objTemp.userVo.roleId];
    
    NSString *tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.employeeType == TDFEmployeeAdd?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[JsonHelper getObjectData:objTemp.employeeVo] forKey:@"employeeVo"];
    [dic setObject:[JsonHelper getObjectData:objTemp.userVo] forKey:@"userVo"];
    [dic setObject:objTemp.extraActionVoList forKey:@"extraActionVoList"];
    
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"entity_id"] = self.entityId;
    parma[@"employee_user_json"] = [JsonHelper dictionaryToJson:dic];
    [parma setObject:@"1" forKey:@"type"];
    
    
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
            [self.navigationController popViewControllerAnimated:YES];
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
            self.employeeEditCallBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (BOOL)isValidShop
{
    if (idCardVisabal && [NSString isBlank:self.userTemp.cardNo]) {
        [AlertBox show:NSLocalizedString(@"ID卡号不能为空!", nil)];
        return NO;
    }
    
    if(isZeroVisibal && [NSString isBlank:isMaxZeroStr]){
        [AlertBox show:NSLocalizedString(@"最大可去零额度(元)不能为空!", nil)];
        return NO;
    }
    return YES;
}

- (BOOL)isAnyTipsShowed
{
    return [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
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

@end
