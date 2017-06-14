//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSString+Estimate.h"
#import "TDFSignBillService.h"
#import "SignBillPayView.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "SignBillView.h"
#import "RemoteEvent.h"
#import "TDFTransService.h"
#import "DicSysItem.h"
#import "NumberUtil.h"
#import "FormatUtil.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "SignBillVO.h"
#import "ObjectUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillPayView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sysService = [ServiceFactory Instance].systemService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self initWithData:self.payTptalVO signBillPayNoPayOptionTotal:self.signBillPayNoPayOptionTotal payIdSet:self.payIdSet];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"还款", nil) backImg:Head_ICON_CANCEL moreImg:nil];
    self.title = NSLocalizedString(@"还款", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
}

-(void) initMainView
{
    [self.lstKindPay initLabel:NSLocalizedString(@"付款方式", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtResultFee initLabel:NSLocalizedString(@"应收(元)", nil) withHit:nil];
    [self.lstPayFee initLabel:NSLocalizedString(@"实收(元)", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtMemo initLabel:NSLocalizedString(@"备注", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container setBackgroundColor:[UIColor clearColor]];
    
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self.lstPayFee setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveFinish:) name:REMOTE_SIGNBILL_SAVE_BILL object:nil];
}

- (void)initWithData:(SignBillPayTotalVO *)signBillPayTotalVO signBillPayNoPayOptionTotal:(SignBillPayNoPayOptionTotalVO *)signBillPayNoPayOptionTotal payIdSet:(NSMutableArray *)payIdSet;
{
    if (signBillPayTotalVO!=nil) {
        NSString *data = [FormatUtil formatDouble3:signBillPayTotalVO.fee];
        [self.txtResultFee initData:data withVal:data];
        [self.lstPayFee initData:data withVal:data];
        [self.lstKindPay initData:@"" withVal:@""];
        [self.txtMemo initData:@""];
    }
}

- (NSInteger)currentKindIndexWithKinds:(NSArray *)kinds {

    NSString *val = [self.lstKindPay getStrVal];
    
    for (NSInteger i = 0; i < kinds.count; i++) {
        DicSysItem *item = kinds[i];
        if ([item.val isEqualToString:val]) {
            
            return i;
        }
    }
    
    return 0;
}

-(void)loadKindPayFinish:(id )data
{
    NSArray *list = [data  objectForKey:@"data"];
//    NSArray *list = [data  objectForKey:@"data"];
    NSArray *kindPayArray = [JsonHelper transList:list objName:@"DicSysItem"];
    self.kindPayList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:kindPayArray]) {
        for (DicSysItem *item in kindPayArray) {
            if ([SYSTEM_TYPE_CARD isEqualToString:item.val]==NO) {
                [self.kindPayList addObject:item];
            }
        }
    }
    
//    [OptionPickerBox initData:self.kindPayList itemId:[self.lstKindPay getStrVal]];
//    [OptionPickerBox show:NSLocalizedString(@"付款方式", nil) client:self event:EVENT_KINDPAY_SELECT];
    
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"付款方式", nil)
                                                                              options:self.kindPayList
                                                                     currentSelectedIndex:[self currentKindIndexWithKinds:self.kindPayList]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:wself.kindPayList[index] event:EVENT_KINDPAY_SELECT];
    };

    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

-(void)saveFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[SignBillView class]]) {
            SignBillView *vc = (SignBillView *)viewController;
            [vc loadSignBillList];
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
}

- (BOOL)isValid
{
    NSString *kindPayId = [self.lstKindPay getStrVal];
    if ([NSString isBlank:kindPayId]) {
        [AlertBox show:NSLocalizedString(@"请输入付款方式!", nil)];
        return NO;
    }
    return YES;
}

- (IBAction)confirmPayBtnClick:(id)sender
{
    if ([self isValid]) {
        
        double fee = [self.txtResultFee getStrVal].doubleValue;
        double realFee = [self.lstPayFee getStrVal].doubleValue;
        
        if ([NumberUtil isEqualNum:fee num2:realFee]) {
            [self doPaySignbill];
        } else {
            [MessageBox show:NSLocalizedString(@"您的实收金额与挂账金额不一致，确认继续还款？", nil) client:self];
        }
    }
}

- (void)doPaySignbill
{
    SignBillVO *signBill = [[SignBillVO alloc]init];
    signBill.payModeId = [self.lstKindPay getStrVal];
    signBill.fee = [self.txtResultFee getStrVal].doubleValue;
    signBill.realFee = [self.lstPayFee getStrVal].doubleValue;
    signBill.memo = [self.txtMemo getStrVal];
    signBill.company =  self.signBillPayNoPayOptionTotal.name;
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];

    [[TDFSignBillService new] saveSignBillPayList:self.payIdSet signBill:signBill sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        for (UIViewController *viewController in [self.navigationController viewControllers]) {
            if ([viewController isKindOfClass:[SignBillView class]]) {
                SignBillView *vc = (SignBillView *)viewController;
                [vc loadSignBillList];
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];

    }];
}

- (void)onItemListClick:(EditItemList *)obj
{
    if (obj==self.lstKindPay) {

       [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
       // [sysService listDicSysItems:@"SIGNBILL_PAYMODE" Target:self Callback:@selector(loadKindPayFinish:)];
       [[TDFTransService new]  listDicSysItems:@"SIGNBILL_PAYMODE" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud  hide: YES];
            [self loadKindPayFinish:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
        }];

    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    if (eventType==EVENT_KINDPAY_SELECT) {
        DicSysItem *dicSysItem = (DicSysItem *)selectObj;
        [self.lstKindPay initData:[dicSysItem obtainItemName] withVal:[dicSysItem obtainItemValue]];
    }
    return YES;
}

- (void) clientInput:(NSString *)val event:(NSInteger)eventType
{
    if (EVENT_PAY_FEE_INPUT==eventType) {
        [self.lstPayFee initData:val withVal:val];
    }
}

- (void)confirm
{
    [self doPaySignbill];
}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signBill"];
}


@end
