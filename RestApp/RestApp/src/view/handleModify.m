//
//  handleModify.m
//  RestApp
//
//  Created by 栀子花 on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "handleModify.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "MBProgressHUD.h"
#import "BillModifyService.h"
#import "BillOptimizationTaskVo.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "GlobalRender.h"
#import "BillModifyModule.h"
#import "TDFOptionPickerController.h"
#import "MenuRender.h"
#import "Platform.h"
#import "RestConstants.h"
#import "RemoteResult.h"
#import "UIViewController+Picker.h"

@implementation handleModify

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
    [self loadDatas];
}


#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"手工优化账单", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"手工优化账单", nil);
}



-(void) initMainView
{
    [self.lsStartDate initLabel:NSLocalizedString(@"选择开始日期", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsEndDate initLabel:NSLocalizedString(@"选择结束日期", nil) withHit:nil isrequest:YES delegate:self];
    [self.billType initLabel:NSLocalizedString(@"选择优化的账单类型", nil) withHit:nil isrequest:YES delegate:self];
    [self.billPer initLabel:NSLocalizedString(@"▪︎ 账单占营业额百分比(%)", nil) withHit:nil isrequest:YES delegate:self];
    [self.startDateTxt initLabel:NSLocalizedString(@"开始日期", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.endDateTxt initLabel:NSLocalizedString(@"结束日期", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];

    [self.biiTypeTxt initLabel:NSLocalizedString(@"优化的账单类型", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.percentTxt initLabel:NSLocalizedString(@"▪︎ 账单占营业额百分比(%)", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.startDateTxt.txtVal.textColor = [UIColor darkGrayColor];
    self.endDateTxt.txtVal.textColor = [UIColor darkGrayColor];
    self.biiTypeTxt.txtVal.textColor = [UIColor darkGrayColor];
    self.percentTxt.txtVal.textColor = [UIColor darkGrayColor];
    [self.percentTxt.lblName setWidth:200];
    self.cancleView.hidden = YES;
    self.container.hidden =NO;

    [self clearDo];
    self.lsStartDate.tag = BILLMOD_START_DATE;
    self.lsEndDate.tag =BILLMOD_END_DATE;
    self.billType.tag = BILL_MODIFY_TYPE;
    self.billPer.tag = BILL_TURNOVER_PER;
}


- (void)onNavigateEvent:(NSInteger)event
{
    if (event ==DIRECT_LEFT) {
     [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onItemListClick:(EditItemList*)obj
{
    if(obj.tag==BILLMOD_START_DATE|| obj.tag==BILLMOD_END_DATE){
        
        [self showDatePickerWithTitle:obj.lblName.text mode:UIDatePickerModeDate editItem:obj];
    }
   else if (obj.tag == BILL_MODIFY_TYPE) {
//        [OptionPickerBox initData:[MenuRender listBillType] itemId:[obj getStrVal]];
//        [OptionPickerBox show:NSLocalizedString(@"选择优化的账单类型", nil)  client:self event:obj.tag];
       TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"选择优化的账单类型", nil)
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
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay];
   
    if (event==BILLMOD_START_DATE) {
        [self.lsStartDate changeData:dateStr withVal:dateStr] ;
    } else {
        [self.lsEndDate changeData:dateStr withVal:dateStr] ;
    }
    return YES;
}

#pragma 数据层处理
-(BOOL)isValid{
   
    if ([NSString isBlank:[self.lsStartDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"开始日期不能为空", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsEndDate getStrVal] ]) {
        [AlertBox show:NSLocalizedString(@"结束日期不能为空", nil)];
        return NO;
    }
    
    NSDate* startDate=[DateUtils DateWithString:[self.lsStartDate getStrVal] type:TDFFormatTimeTypeYearMonthDayString];
    NSDate* endDate=[DateUtils DateWithString:[self.lsEndDate getStrVal] type:TDFFormatTimeTypeYearMonthDayString];

    double start = [startDate timeIntervalSince1970];
    double end = [endDate timeIntervalSince1970];
    double datep = end - start;
    if (datep >  30 * 24 * 60 *60) {
        [AlertBox show:NSLocalizedString(@"时间跨度不能超过30天", nil)];
        return NO;
    }
    
    NSComparisonResult result=[startDate compare:endDate];
    if (result==NSOrderedDescending) {
        [AlertBox show:NSLocalizedString(@"结束日期不能小于开始日期!", nil)];
        return NO;
    }
    
    NSComparisonResult resulte=[startDate compare:[NSDate date]];
    if (resulte==NSOrderedDescending) {
        [AlertBox show:NSLocalizedString(@"结束日期不能晚于当前日期!", nil)];
        return NO;
    }
    
    NSComparisonResult resulte2 =[endDate compare:[NSDate date]];
    if (resulte2 == NSOrderedDescending) {
        [AlertBox show:NSLocalizedString(@"结束日期不能晚于当前日期!", nil)];
        return NO;
    }
    return YES;
}


#pragma 点击手动优化账单
- (IBAction)btnClick:(id)sender
{
    if (![self isValid]) {
        return ;
    }
    [UIHelper alertView:self.view andDelegate:self andTitle:NSLocalizedString(@"提示", nil) andMessage:NSLocalizedString(@"确认要优化账单吗？", nil)event:1];
}

#pragma 点击取消优化账单
- (IBAction)cancleBtnClick:(id)sender
{
    [UIHelper alertView:self.view andDelegate:self andTitle:NSLocalizedString(@"提示", nil) andMessage:NSLocalizedString(@"确认要取消本次优化吗？", nil)event:2];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
    if (buttonIndex == 0) {
        return;
    }else{
        [service saveBillModifyTarget:[self billData] target:self Callback:@selector(requestBack:)];

    }

    } else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            return;
        }else{
            [service clearBillModify:0 target:self callback:@selector(deleteFinish:)];

        }
    }

   
}


-(NSDictionary *)billData{
  
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[self.lsStartDate getDataLabel] forKey:@"startDate"];
    [dict setObject:[self.lsEndDate getDataLabel] forKey:@"endDate"];
    [dict setObject:@"0" forKey:@"taskType"];
    [dict setObject:[self.billType getStrVal] forKey:@"billOptimizationType"];
    [dict setObject:[self.billPer getDataLabel] forKey:@"billQuantityPercent"];
    if ([[self.billPer getStrVal] isEqual:NSLocalizedString(@"▪︎ 账单所占营业额百分比(%)", nil) ]) {
        [dict setObject:[self.billPer getStrVal] forKey:@"billQuantityPercent"];
    }else{
        [dict setObject:[self.billPer getStrVal] forKey:@"turnoverPercent"];
    }
    return dict;
}

#pragma mark 加载数据
-(void)loadDatas{
    [self clearDo];
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [service queryBillModifyWithInfo:0 target:self callback:@selector(getInfoBack:)];
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
    BillOptimizationTaskVo *vo  = [JsonHelper dicTransObj:data obj:[BillOptimizationTaskVo new]];
    if ([NSString isBlank:vo.taskId]) {
        [self clearDo];
    }else{
        [self fillModel:vo];
    
    }
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
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    BillOptimizationTaskVo *vo  = [JsonHelper dicTransObj:data obj:[BillOptimizationTaskVo new]];
    [self fillModel:vo];
}

-(void)deleteFinish:(RemoteResult *)result{

    [hud hide:YES];
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.cancleView.hidden = YES;
    self.container.hidden = NO;
    [self clearDo];
}
#pragma 数据层处理
- (void)clearDo
{
    self.cancleView.hidden = YES;
    self.container.hidden = NO;
    [self.lsStartDate initData:nil withVal:nil];
    [self.lsEndDate initData:nil withVal:nil];
    [self.billType initData:NSLocalizedString(@"根据营业额", nil) withVal:@"0"];
    [self.billPer initData:@"50" withVal:@"50"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel:(BillOptimizationTaskVo*)vo
{
    self.cancleView.hidden = NO;
    self.container.hidden = YES;
    [self.startDateTxt initData:vo.startDate ];
    [self.endDateTxt initData:vo.endDate ];
    [self.biiTypeTxt initData:[MenuRender obtainItem:[MenuRender listBillType] itemId:[NSString stringWithFormat:@"%d",vo.billOptimizationType]] ];
    self.percentTxt.lblName.text = vo.billOptimizationType?NSLocalizedString(@"▪︎ 账单所占营业额百分比(%)", nil):NSLocalizedString(@"▪︎ 账单所占总单数百分比(%)", nil);
    [self.percentTxt initData:vo.billOptimizationType?[NSString stringWithFormat:@"%d",vo.billQuantityPercent]:[NSString stringWithFormat:@"%d",vo.turnoverPercent]];
    NSString *dateStr = [DateUtils formatTimeWithTimestamp:vo.createTime *1000 type:TDFFormatTimeTypeFullTime];
    self.lip.text=[NSString stringWithFormat:NSLocalizedString(@"任务创建时间:%@ \n取消后本次优化后可重新选择", nil),dateStr];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
@end
