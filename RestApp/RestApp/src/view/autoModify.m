//
//  autoModify.m
//  RestApp
//
//  Created by 栀子花 on 16/5/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "autoModify.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "NSString+Estimate.h"
#import "MBProgressHUD.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "BillModifyService.h"
#import "ServiceFactory.h"
#import "GlobalRender.h"
#import "BillOptimizationTaskVo.h"
#import "BillModifyModule.h"
#import "OptionPickerBox.h"
#import "MenuRender.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "RestConstants.h"
#import "RemoteResult.h"
#import "UIViewController+Picker.h"

@interface autoModify()<IEditItemRadioEvent>
@property (nonatomic, strong)BillOptimizationTaskVo *billVO;
@end

@implementation autoModify
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(BillModifyModule *)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service=[ServiceFactory Instance].billModifyService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    [self initNotifaction];
    self.title =NSLocalizedString(@"自动优化账单", nil);
    [self loadData];
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"自动优化账单", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)leftNavigationButtonAction:(id)sender
{
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}
-(void) initMainView
{

    [self.doauto initLabel:NSLocalizedString(@"每天自动优化账单", nil) withHit:nil delegate:self];
    [self.autoday initLabel:NSLocalizedString(@"▪︎ 自动优化前几天的账单(天)", nil) withHit:nil delegate: self];
    [self.billType initLabel:NSLocalizedString(@"▪︎ 选择优化的账单类型", nil)  withHit:nil delegate:self];
    [self.billPer initLabel:NSLocalizedString(@"▪︎ 账单占营业额百分比(%)", nil) withHit:nil delegate:self];
    [self clearDo];
    
    self.doauto.tag = BILL_EVE_AUTO;
    self.autoday.tag = BILL_AUTO_DAY;
    self.billType.tag = BILL_MODIFY_TYPE;
    self.billPer.tag = BILL_TURNOVER_PER;
}


-(void)loadData
{
      [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
      [service queryBillModifyWithInfo:1 target:self callback:@selector(getInfoBack:)];
}

- (void)getInfoBack:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    self.billVO  = [JsonHelper dicTransObj:data obj:[BillOptimizationTaskVo new]];
    if ([ObjectUtil isEmpty:self.billVO]) {
        self.billVO = [BillOptimizationTaskVo new];
        [self clearDo];
    }else{
        [self fillModel:self.billVO];
    }
}
#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_AutoBillView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_AutoBillView_Change  object:nil];
    
}
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}
#pragma 数据层处理
- (void)clearDo
{
    [self.doauto initShortData:0];
    [self subVisibal];
    [self.autoday initData:@"2" withVal:@"2"];
    [self.billType initData:NSLocalizedString(@"根据营业额", nil) withVal:@"0"];
    [self.billPer initData:@"50" withVal:@"50"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel:(BillOptimizationTaskVo*)vo
{
    [self.doauto initShortData:vo.onOff];
    [self subVisibal];
    if (!vo.onOff) {
        [self clearDo];
        return;
    }
    [self.autoday initData:[NSString stringWithFormat:@"%d",vo.dateOffSet] withVal:[NSString stringWithFormat:@"%d",vo.dateOffSet]];
    [self.billType initData:[MenuRender obtainItem:[MenuRender listBillType] itemId:[NSString stringWithFormat:@"%d",vo.billOptimizationType]] withVal:[NSString stringWithFormat:@"%d",vo.billOptimizationType]];
    self.billPer.lblName.text = vo.billOptimizationType?NSLocalizedString(@"▪︎ 账单所占总单数百分比(%)", nil):NSLocalizedString(@"▪︎ 账单所占营业额百分比(%)", nil);
    NSString *billPerString = vo.billOptimizationType?[NSString stringWithFormat:@"%d",vo.billQuantityPercent]:[NSString stringWithFormat:@"%d",vo.turnoverPercent];
    [self.billPer initData:billPerString withVal:billPerString];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(BOOL)isValid
{
    if (![self.doauto getVal]) {
        return YES;
    }
    return NO;
}
-(void)save
{
    [service saveBillModifyTarget:[self billData] target:self Callback:@selector(requestBack:)];
}

- (void)requestBack:(RemoteResult *)result
{
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
      [self.navigationController popViewControllerAnimated:YES];
}


-(NSDictionary *)billData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.doauto getVal]?@"true":@"false" forKey:@"onOff"];
    [dict setObject:@"1" forKey:@"taskType"];
    if ([NSString isNotBlank:self.billVO.taskId]) {
      [dict setObject:self.billVO.taskId forKey:@"taskId"];
    }
    [dict setObject:[self.autoday getDataLabel] forKey:@"dateOffSet"];
    [dict setObject:[self.billType getStrVal] forKey:@"billOptimizationType"];
    if ([[self.billType getStrVal] isEqual:@"1" ]) {
        [dict setObject:[self.billPer getStrVal] forKey:@"billQuantityPercent"];
    }else{
        [dict setObject:[self.billPer getStrVal] forKey:@"turnoverPercent"];
    }
    return dict;
}


#pragma mark UI
//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio *)obj
{
    if (obj.tag==BILL_EVE_AUTO) {
        [self subVisibal];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) subVisibal
{
    BOOL isOpen=[self.doauto getVal];
    [self.autoday visibal:isOpen];
    [self.billType visibal:isOpen];
    [self.billPer visibal:isOpen];
}


- (void)onItemListClick:(EditItemList*)obj
{
    if(obj.tag==BILL_AUTO_DAY){
//        [OptionPickerBox initData:[MenuRender listAutoDay] itemId:[obj getStrVal]];
//        [OptionPickerBox show:NSLocalizedString(@"自动优化前几天的账单(天)", nil)  client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"自动优化前几天的账单(天)", nil)
                                                                                      options:[MenuRender listAutoDay]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listAutoDay][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if (obj.tag == BILL_MODIFY_TYPE) {
//        [OptionPickerBox initData:[MenuRender listBillType] itemId:[obj getStrVal]];
//        [OptionPickerBox show:NSLocalizedString(@"选择优化账单的类型", nil)  client:self event:obj.tag];
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"选择优化账单的类型", nil)
                                                                                      options:[MenuRender listBillType]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listBillType][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
    else if (obj.tag == BILL_TURNOVER_PER) {
//        [ OptionPickerBox initData:[MenuRender listBillPer] itemId:[obj getStrVal]];
//        [OptionPickerBox show:[obj.lblName.text substringFromIndex:1] client:self event:obj.tag];
    
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:[obj.lblName.text substringFromIndex:1]
                                                                                      options:[MenuRender listBillPer]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listBillPer][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (event == BILL_MODIFY_TYPE) {
        [self.billType changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"0"]) {
            [self.billPer initLabel:NSLocalizedString(@"▪︎ 账单所占营业额百分比(%)", nil) withHit:nil isrequest:YES delegate:self];
            [self.billPer initData:@"50" withVal:@"50"];
        }else{
            [self.billPer initLabel:NSLocalizedString(@"▪︎ 账单所占总单数百分比(%)", nil) withHit:nil isrequest:YES delegate:self];
            [self.billPer initData:@"50" withVal:@"50"];
        }
    }else if (event == BILL_TURNOVER_PER){
        [self.billPer changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (event == BILL_AUTO_DAY){
       [self.autoday changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

@end
