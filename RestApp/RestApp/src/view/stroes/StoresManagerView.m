//
//  StoresManagerView.m
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "StoresManagerView.h"
#import "NavigateTitle.h"
#import "EditItemText.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "NavigateTitle2.h"
#import "ItemEndNote.h"
#import "RemoteResult.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "NameItemVO.h"
#import "TDFOptionPickerController.h"
#import "ActionConstants.h"
#import "TDFMediator+BrandModule.h"

@implementation StoresManagerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changed=NO;
    self.needHideOldNavigationBar = YES;
    
    [self initNotifaction];
    [self initMainView];
    [self initNavigate];
    [self loadData:self.shopId];
}

#pragma navigateTitle.

- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"门店详情", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_StoresManagerView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_StoresManagerView_Change object:nil];
}

-(void) loadData:(NSString *)shopId
{
    [self clearDo];
    
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
     NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"shop_id"] = shopId;
    
     @weakify(self);
    [[TDFChainService new] queryShopInfoWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         @strongify(self);
        [self.progressHud hide:YES];
        self.shopVo = [[ShopVO alloc]initWithDictionary:data[@"data"]];
        if (self.shopVo == nil) {
            [self clearDo];
        }else{
            [self fillModel];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)initMainView
{
    [self.lblShopCode initLabel:NSLocalizedString(@"门店编码", nil)  withHit:nil];
    [self.txtShopName initLabel:NSLocalizedString(@"店名", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault wordNum:20 wordStr:NSLocalizedString(@"店名", nil)];
     [self.superCompanyRadio initLabel:NSLocalizedString(@"此门店有上级公司", nil) withHit:nil delegate:self];
    [self.superCompanyRadio initData:@"0"];
    [self.superCompany initLabel:NSLocalizedString(@"•上级公司", nil) withHit:nil isrequest:NO delegate:self];
     [self.listShopBrand initLabel:NSLocalizedString(@"所属品牌", nil) withHit:nil isrequest:YES delegate:self];
    [self.listJoinMode initLabel:NSLocalizedString(@"经营类型", nil)  withHit:nil delegate:self];
    [self.txtEmail initLabel:NSLocalizedString(@"邮箱", nil) withHit:nil isrequest:NO type:UIKeyboardTypeEmailAddress];
    [self.txtEmail initLabel:NSLocalizedString(@"邮箱", nil) withHit:nil isrequest:NO type:UIKeyboardTypeEmailAddress];
    [self.txtLinker initLabel:NSLocalizedString(@"联系人", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault wordNum:20 wordStr:NSLocalizedString(@"联系人", nil)];
    [self.txtMobile initLabel:NSLocalizedString(@"联系电话", nil) withHit:nil isrequest:NO type:UIKeyboardTypePhonePad];
    [self.txtAddress initLabel:NSLocalizedString(@"地址", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container setBackgroundColor:[UIColor clearColor]];
    
    self.listShopBrand.tag = BRAND_LIST;
    self.superCompany.tag = BRANCH_COMPANY;
    self.listJoinMode.tag = JOIN_MODE_LIST;
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)fillModel
{
    [self.lblShopCode initData:self.shopVo.code withVal:self.shopVo.code];
    [self.listJoinMode initData:self.shopVo.joinMode == 1? NSLocalizedString(@"直营", nil):self.shopVo.joinMode == 0? NSLocalizedString(@"加盟", nil):self.shopVo.joinMode == 2?@"合作":self.shopVo.joinMode == 3?@"合营":nil   withVal:self.shopVo.joinMode == 1? NSLocalizedString(@"直营", nil):self.shopVo.joinMode == 0? NSLocalizedString(@"加盟", nil):self.shopVo.joinMode == 2?@"合作":self.shopVo.joinMode == 3?@"合营":nil ];
    [self.txtShopName  initData:self.shopVo.name];
    if ([NSString isBlank:self.shopVo.branchEntityId]) {
       [self.superCompanyRadio initData:@"0"];
        [self.superCompany visibal:NO];
    }else{
        [self.superCompanyRadio initData:@"1"];
        [self.superCompany visibal:YES];
    }
    
    [self.superCompany initData:self.shopVo.branchName withVal:self.shopVo.branchEntityId];
    [self.listShopBrand initData:self.shopVo.plateName withVal:self.shopVo.plateId];
    [self.txtEmail initData:self.shopVo.zipCode];
    [self.txtLinker initData:self.shopVo.linkman];
    [self.txtMobile initData:self.shopVo.phone1];
    [self.txtAddress initData:self.shopVo.address];
    self.title = self.shopVo.name;
    [self isHasLok];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void) isHasLok
{
    if ([[[Platform Instance] getkey:IS_BRANCH] isEqualToString:@"1"]) {
        if ([[Platform Instance] lockAct:PHONE_BRANCH_MANAGE]) {
            self.superCompany.userInteractionEnabled = NO;
            self.superCompany.lblVal.textColor = [UIColor grayColor];
            [self.superCompany.imgMore setImage:[UIImage imageNamed:@""]];
            if ([NSString isBlank:self.shopVo.branchEntityId]) {
                self.superCompanyRadio.userInteractionEnabled = NO;
            }else{
                self.superCompanyRadio.userInteractionEnabled = YES;
            }
        }else{
            self.superCompany.userInteractionEnabled = YES;
            self.superCompany.lblVal.textColor = [UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
            [self.superCompany.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
             self.superCompanyRadio.userInteractionEnabled = YES;
        }
    }else {
        if ([[Platform Instance] lockAct:PHONE_BRAND_BRANCH]) {
            self.superCompany.userInteractionEnabled = NO;
            self.superCompany.lblVal.textColor = [UIColor grayColor];
            [self.superCompany.imgMore setImage:[UIImage imageNamed:@""]];
            if ([NSString isBlank:self.shopVo.branchEntityId]) {
                self.superCompanyRadio.userInteractionEnabled = NO;
            }else{
                self.superCompanyRadio.userInteractionEnabled = YES;
            }
        }else{
            self.superCompany.userInteractionEnabled = YES;
            self.superCompany.lblVal.textColor = [UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
            [self.superCompany.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
            self.superCompanyRadio.userInteractionEnabled = YES;
        }
    }
}
#pragma 数据层处理
- (void)clearDo
{
    [self.lblShopCode initData:nil withVal:nil];
    [self.listJoinMode initData:nil withVal:nil];
    [self.txtShopName initData:nil];
    [self.txtEmail initData:nil];
    [self.txtLinker initData:nil];
    [self.txtMobile initData:nil];
    [self.txtAddress initData:nil];
    [self.superCompanyRadio initData:@"0"];
    [self.superCompany visibal:NO];
    [self.listShopBrand initData:nil withVal:nil];
    self.plateId = @"";
    self.branchEntityId = @"";
    self.branchId = @"";
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma ui-data-save
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtShopName getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"店名名称不能为空", nil)];
        return NO;
    }
    if (self.txtShopName.txtVal.text.length>20) {
        [AlertBox show:NSLocalizedString(@"店铺名称最多输入20个字符", nil)];
        return NO;
    }
    if ([NSString isBlank:self.branchEntityId] && [[self.superCompanyRadio getStrVal] isEqualToString:@"1"]) {
        if ([NSString isBlank:[self.superCompany getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"上级公司不能为空", nil)];
            return NO;
        }
    }
    if ([NSString isBlank:[self.listShopBrand getStrVal] ] || [[self.listShopBrand getStrVal] isEqualToString:@"0"]) { // 当没有选择品牌的时候值为0
        [AlertBox show:NSLocalizedString(@"品牌名称不能为空", nil)];
        return NO;
    }
    if (self.txtLinker.txtVal.text.length>20) {
        [AlertBox show:NSLocalizedString(@"联系人最多可输入20个字符", nil)];
        return NO;
    }
    if (self.txtMobile.txtVal.text.length>30) {
        [AlertBox show:NSLocalizedString(@"联系电话最多可输入30个字符", nil)];
        return NO;
    }
    if (self.txtEmail.txtVal.text.length>30) {
        [AlertBox show:NSLocalizedString(@"常用邮箱最多可输入30个字符", nil)];
        return NO;
    }
    if ([NSString isNotBlank:self.txtEmail.txtVal.text]) {
        if ([NSString isValidateEmail:self.txtEmail.txtVal.text]==NO) {
            [AlertBox show:NSLocalizedString(@"您输入的邮箱格式不正确", nil)];
            return NO;
        }
    }

    return YES;
}

-(ShopVO *) transMode
{
    ShopVO* shopVO=[ShopVO new];
    if ([NSString isNotBlank:[self.txtShopName getStrVal]]) {
        shopVO.name=[self.txtShopName getStrVal];
    }
    if ([NSString isNotBlank:[self.txtEmail getStrVal]]) {
        shopVO.zipCode=[self.txtEmail getStrVal];
    }
    if ([NSString isNotBlank:[self.txtLinker getStrVal]]) {
        shopVO.linkman=[self.txtLinker getStrVal];
    }
    if ([NSString isNotBlank:[self.txtMobile getStrVal]]) {
        shopVO.phone1=[self.txtMobile getStrVal];
    }
    if ([NSString isNotBlank:[self.txtAddress getStrVal]]) {
        shopVO.address=[self.txtAddress getStrVal];
    }
    if ([NSString isNotBlank:[self.listShopBrand getStrVal]]) {
        shopVO.plateName=self.listShopBrand.lblVal.text;
    }
    if ([NSString isNotBlank:self.plateId]) {
        shopVO.plateId = self.plateId;
    }else{
        shopVO.plateId = self.shopVo.plateId;
    }

    if ([NSString isNotBlank:self.branchEntityId]) {
        shopVO.curBranchEntityId = self.branchEntityId;
    }else{
        shopVO.curBranchEntityId = self.shopVo.curBranchEntityId;
    }
    shopVO.branchShopId = self.shopVo.branchShopId;
    shopVO.branchEntityId = self.shopVo.branchEntityId;
    shopVO.branchShopLastVer = self.shopVo.branchShopLastVer;
    if ([NSString isNotBlank:self.branchId]) {
        shopVO.branchId = self.branchId;
    }
    if ([[self.superCompanyRadio getStrVal] isEqualToString:@"0"]) {
        shopVO.curBranchEntityId = @"";
    }
    shopVO.id = self.shopVo.id;
    shopVO.code = self.shopVo.code;
    shopVO.orgId = self.shopVo.orgId;
    shopVO.orgName = self.shopVo.orgName;
    shopVO.onlineIp = self.shopVo.onlineIp;
    shopVO.entityId = self.shopVo.entityId;
    NSString *itemId;
    if ([self.listJoinMode.lblVal.text isEqualToString:@"直营"]) {
        itemId = @"1";
    }else if ([self.listJoinMode.lblVal.text isEqualToString:@"加盟"])
    {
        itemId = @"0";
    }else if ([self.listJoinMode.lblVal.text isEqualToString:@"合作"])
    {
        itemId = @"2";
    }else if ([self.listJoinMode.lblVal.text isEqualToString:@"合营"])
    {
        itemId = @"3";
    }

    shopVO.joinMode = itemId.integerValue;
    return shopVO;
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)confirmChangedMessage {
    __block StoresView *indexView;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[StoresView class]]) {
            indexView = obj;
            [indexView loadData];
            *stop = YES;
        }
    }];
    if (indexView) {
        [self.navigationController popToViewController:indexView animated:YES];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void)onItemListClick:(EditItemList *)obj
{
    self.obj = obj;
    
    if (obj.tag == BRAND_LIST) {
        [self queryPlateList];
    }else if (obj.tag == JOIN_MODE_LIST){
        NSString *itemId;
        if ([self.listJoinMode.lblVal.text isEqualToString:@"直营"]) {
            itemId = @"1";
        }else if ([self.listJoinMode.lblVal.text isEqualToString:@"加盟"])
        {
            itemId = @"0";
        }else if ([self.listJoinMode.lblVal.text isEqualToString:@"合作"])
        {
            itemId = @"2";
        }else if ([self.listJoinMode.lblVal.text isEqualToString:@"合营"])
        {
            itemId = @"3";
        }
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:@"经营类型"
                                                                                      options:[self getJoinModeList]
                                                                                currentItemId:itemId];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[self getJoinModeList][index] event:obj.tag];
        };
        pvc.shouldShowManagerButton = NO;
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
    else{
        
        TDFMediator *mediator = [[TDFMediator alloc] init];
        UIViewController *branchListContoller = [mediator TDFMediator_branchCompanyListViewControllerWithType:EditType delegate:self branchCompanyList:nil branchCompanyListArr:nil isFromBranchEditView:NO listCallBack:^(BOOL orFresh) {
        }];
        [self.navigationController pushViewController:branchListContoller animated:NO];
    }
}

- (void) queryPlateList
{
    //请求品牌
     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    [param setObject:[[Platform Instance] getkey:USER_ID] forKey:@"user_id"];
    
    @weakify(self);
    [[TDFChainService new] queryPlateListWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableArray *plateList = [[NSMutableArray alloc] init];
        plateList = [Plate convertToPlateListByArr:[data objectForKey:@"data"]];
        NSMutableArray *plateNameList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotEmpty:plateList]){
            for (Plate *plate in plateList) {
                NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:plate.name andId:plate.id];
                [plateNameList addObject:nameItem];
            }
        }else{
            [AlertBox show:NSLocalizedString(@"请先添加品牌", nil)];
        }
        [self showItemList:self.obj array:plateNameList];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)showItemList:(EditItemList *)obj array:(NSMutableArray *)array;
{
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"选择品牌", nil)
                                                                                  options:array
                                                                            currentItemId:[obj getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:array[index] event:obj.tag];
    };
    pvc.shouldShowManagerButton = YES;
    pvc.manageTitle = NSLocalizedString(@"品牌管理", nil);
    pvc.managerBlock = ^void(){
        [wself managerOption:wself.listShopBrand.tag];
    };
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO *vo=(NameItemVO *)item;
    if (event == JOIN_MODE_LIST) {
        [self.listJoinMode changeData:[vo obtainItemName] withVal:[vo obtainItemName]];
    }else{
        [self.listShopBrand changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        self.plateId = [vo obtainItemId];
    }
    return YES;
}


-(void)save
{
    if (![self isValid]) {
        return;
    }
    
    ShopVO *shopVo = [self transMode];
    [self showProgressHudWithText:NSLocalizedString(@"正在更新", nil)];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [parma setObject:[JsonHelper transJson:shopVo] forKey:@"shop_vo_str"];
    
        @weakify(self);
    [[TDFChainService new] modifyShopInfoWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        self.editStoresCallBack(YES);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
       [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 选项管理页.
- (void)managerOption:(NSInteger)eventType
{
    TDFMediator *mediator = [[TDFMediator alloc] init];
    
    @weakify(self);
    UIViewController *brandListContoller = [mediator TDFMediator_brandManagerListViewControllerWithBrandCallBack:^(BOOL orFresh) {
        @strongify(self);
        [self queryPlateList];
    }];
    [self.navigationController pushViewController:brandListContoller animated:YES];
}

-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
    [self.superCompany initLabel:NSLocalizedString(@"•上级公司", nil) withHit:nil isrequest:NO delegate:self];

    if ([NSString isNotBlank:self.shopVo.branchName]) {
        [self.superCompany initData:self.shopVo.branchName withVal:self.shopVo.branchEntityId];
    }else{
        if ([NSString isBlank:self.branchName]) {
        [self.superCompany setPlaceholder:NSLocalizedString(@"请选择", nil)];
        }else{
            [self.superCompany initData:self.branchName withVal:self.branchEntityId];
        }
    }
    self.superCompany.lblVal.textColor = [UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
    [self.superCompany.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.superCompany visibal:result];

    [self.superCompanyRadio changeData:[obj getStrVal]];
    
    [self isHasLok];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)selectOption:(id<INameItem>)data branchId:(NSString *)branchId
{
    [self.superCompany changeData:[data obtainItemName] withVal:[data obtainItemId]];
    self.branchEntityId = [data obtainItemId];
    self.branchId = branchId;
    return YES;
}

- (NSMutableArray *) getJoinModeList
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:@"直营" andId:@"1"];
    [arr addObject:item];
    
    NameItemVO *item1 = [[NameItemVO alloc] initWithVal:@"加盟" andId:@"0"];
    [arr addObject:item1];
    
    NameItemVO *item2 = [[NameItemVO alloc] initWithVal:@"合作" andId:@"2"];
    [arr addObject:item2];
    
    NameItemVO *item3 = [[NameItemVO alloc] initWithVal:@"合营" andId:@"3"];
    [arr addObject:item3];
    
    return arr;
}

@end
