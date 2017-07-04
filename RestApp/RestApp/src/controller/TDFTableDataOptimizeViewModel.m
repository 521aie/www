//
//  TDFTableDataOptimizeViewModel.m
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableDataOptimizeViewModel.h"
#import "TDFTableDataOptimizeController.h"
#import "BillOptimizationTaskVo.h"
#import "TDFSKDisplayedTextItem.h"
#import "TDFSKSingleButtonItem.h"
#import "TDFSKButtonItemTransaction.h"
#import "UIHelper.h"
#import "BillModifyService.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "NameItemVO.h"

@interface TDFTableDataOptimizeViewModel ()

@property (nonatomic, weak) TDFTableDataOptimizeController *controller;
@property (nonatomic, assign) NSMutableArray *allObserverItems;
@property (nonatomic, strong) BillModifyService *service;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation TDFTableDataOptimizeViewModel

- (instancetype)initWith:(TDFTableDataOptimizeController *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        _allObserverItems = [NSMutableArray array];
        _service = [ServiceFactory Instance].billModifyService;
        _hud = [[MBProgressHUD alloc] initWithView:self.controller.view];
    }
    return self;
}

#pragma mark -- 更改优化方式
- (void)loadData {
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.controller.view andHUD:self.hud];
    [_service queryBillModifyWithInfo:-1 target:self callback:@selector(getOptimizeMethod:)];
}
- (void)getOptimizeMethod:(RemoteResult *)result {
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    
    if (![data.allKeys containsObject:@"taskType"]) {
        self.controller.isAuto  =   1;
    }
    else {
        self.controller.isAuto = [data[@"taskType"] intValue];
    }

    self.controller.pickerDataOptimizeMethodItem.preValue = [TDFTableDataOptimizeStringFormater stringByMethodType:self.controller.isAuto];
    self.controller.pickerDataOptimizeMethodItem.textValue = [TDFTableDataOptimizeStringFormater stringByMethodType:self.controller.isAuto];
    
    [self.controller buildConfigureSections];
    
    [self loadMamualData];
    [self loadAutoData];
    [self changeOptimizeMethod];
}
//更改优化类型的操作
- (void)changeOptimizeMethod {
    
    self.controller.pickerStartDateItem.shouldShow                  =   !self.controller.isAuto;
    self.controller.pickerEndDateItem.shouldShow                    =   !self.controller.isAuto;
    self.controller.mamualPickerOptimizeBillTypeItem.shouldShow     =   !self.controller.isAuto;
    self.controller.mamualpickerBillPerOfTotalNumItem.shouldShow    =   !self.controller.isAuto;
    self.controller.mamualpickerBillPerOfTurnOverItem.shouldShow    =   !self.controller.isAuto;
    self.controller.textTaskCreateDateItem.shouldShow               =   !self.controller.isAuto;
    self.controller.footButton.shouldShow                           =   !self.controller.isAuto;
    
    self.controller.pickerAutoOptimizeDayItem.shouldShow            =   self.controller.isAuto;
    self.controller.autoPickerOptimizeBillTypeItem.shouldShow       =   self.controller.isAuto;
    self.controller.autoPickerBillPerOfTotalNumItem.shouldShow      =   self.controller.isAuto;
    self.controller.autoPickerBillPerOfTurnOverItem.shouldShow      =   self.controller.isAuto;
    
    [self changeMamualOptimizeBillType];
    [self changeAutoOptimizeBillType];
    
    [self.controller.manager reloadData];
}




#pragma mark --- 手动优化的操作
#pragma mark --- 手动优化的操作
#pragma mark --- 手动优化的操作

//获取手动优化的设置
- (void)loadMamualData {
    [_service queryBillModifyWithInfo:0 target:self callback:@selector(getMamualInfoBack:)];
}
- (void)getMamualInfoBack:(RemoteResult *)result {
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    self.controller.mamualMethodVO  = [JsonHelper dicTransObj:data obj:[BillOptimizationTaskVo new]];
    if ([ObjectUtil isEmpty:self.controller.mamualMethodVO]) {
        [self mamualClearData];
    }else{
        [self mamualFillData:self.controller.mamualMethodVO];
    }
}

//清除手动优化设置
- (void)clearMamualData{
    [self.service clearBillModify:0 target:self callback:@selector(claerMamualData:)];
}
- (void)claerMamualData:(RemoteResult*) result {
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self mamualClearData];
}
//服务端没有数据的时候、或者取消优化的时候。清除手动优化的数据
- (void)mamualClearData {
    self.controller.mamualMethodVO = [BillOptimizationTaskVo new];
    self.controller.mamualMethodVO.billOptimizationType     = 0;
    self.controller.mamualMethodVO.turnoverPercent          = 50;
    self.controller.mamualMethodVO.billQuantityPercent      = 50;
    
    self.controller.pickerStartDateItem.preValue    =   nil;
    self.controller.pickerStartDateItem.textValue   =   nil;
    
    self.controller.pickerEndDateItem.preValue      =   nil;
    self.controller.pickerEndDateItem.textValue     =   nil;
    
    self.controller.mamualPickerOptimizeBillTypeItem.preValue     = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:0];
    self.controller.mamualPickerOptimizeBillTypeItem.textValue    = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:0];
    
    self.controller.mamualpickerBillPerOfTotalNumItem.preValue  = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.billQuantityPercent];
    self.controller.mamualpickerBillPerOfTotalNumItem.textValue = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.billQuantityPercent];
    
    self.controller.mamualpickerBillPerOfTurnOverItem.preValue  = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.billQuantityPercent];
    self.controller.mamualpickerBillPerOfTurnOverItem.textValue = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.turnoverPercent];
    
    self.controller.textTaskCreateDateItem.text =   nil;
    
    //设置picker的默认值
    TDFShowPickerStrategy *picStrategy = (TDFShowPickerStrategy *)self.controller.mamualpickerBillPerOfTotalNumItem.strategy;
    NSString *per = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.billQuantityPercent];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;

    picStrategy = (TDFShowPickerStrategy *)self.controller.mamualpickerBillPerOfTurnOverItem.strategy;
    per = [NSString stringWithFormat:@"%d",self.controller.mamualMethodVO.turnoverPercent];
    item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    
    [self mamualOptimizeStatus:NO];         //设置状态为未优化、
    [self mamualItemEditEnable:YES];        //设置手动优化的item为可编辑
    [self.controller.manager reloadData];
}
//手动优化的有数据的时候，进行设置
- (void)mamualFillData:(BillOptimizationTaskVo *)data; {
    
    self.controller.pickerStartDateItem.preValue    = data.startDate;
    self.controller.pickerStartDateItem.textValue   = data.startDate;
    
    self.controller.pickerEndDateItem.preValue      = data.endDate;
    self.controller.pickerEndDateItem.textValue     = data.endDate;
    
    self.controller.mamualPickerOptimizeBillTypeItem.preValue     = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:data.billOptimizationType];
    self.controller.mamualPickerOptimizeBillTypeItem.textValue    = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:data.billOptimizationType];
    
    self.controller.mamualpickerBillPerOfTotalNumItem.preValue    = [NSString stringWithFormat:@"%d",data.billQuantityPercent];
    self.controller.mamualpickerBillPerOfTotalNumItem.textValue   = [NSString stringWithFormat:@"%d",data.billQuantityPercent];
    
    self.controller.mamualpickerBillPerOfTurnOverItem.preValue    = [NSString stringWithFormat:@"%d",data.turnoverPercent];
    self.controller.mamualpickerBillPerOfTurnOverItem.textValue   = [NSString stringWithFormat:@"%d",data.turnoverPercent];
    
    [self changeMamualOptimizeBillType];                                //设置优化类型。
    [self mamualOptimizeStatus:YES];                                    //设置状态为已经优化
    [self mamualClearTime:self.controller.mamualMethodVO.createTime];   //设置创建时间
    [self mamualItemEditEnable:NO];                                     //设置所有item为不可编辑
    [self.controller.manager reloadData];
}
//设置手动优化的开启状态
- (void)mamualOptimizeStatus:(BOOL)optimized {
    if (!self.controller.isAuto) {
        self.controller.textTaskCreateDateItem.shouldShow = optimized;
    }
    self.controller.footButton.transaction  =   optimized ? self.controller.cancelFooterTransaction : self.controller.startFooterTransaction;
    [self.controller.manager reloadData];
}
//设置手动优化的item是否可以编辑
- (void)mamualItemEditEnable:(BOOL)able {
    self.controller.pickerStartDateItem.editStyle                   = !able;
    self.controller.pickerEndDateItem.editStyle                     = !able;
    self.controller.mamualPickerOptimizeBillTypeItem.editStyle      = !able;
    self.controller.mamualpickerBillPerOfTurnOverItem.editStyle     = !able;
    self.controller.mamualpickerBillPerOfTotalNumItem.editStyle     = !able;
}
//更改手动优化账单类型操作
- (void)changeMamualOptimizeBillType {
    
    if (!self.controller.isAuto) {
        self.controller.mamualpickerBillPerOfTurnOverItem.shouldShow  =       !self.controller.mamualMethodVO.billOptimizationType;
        self.controller.mamualpickerBillPerOfTotalNumItem.shouldShow  =        self.controller.mamualMethodVO.billOptimizationType;
        [self.controller.manager reloadData];
    }
}
//设置手动优化的创建时间
- (void)mamualClearTime:(long)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    self.controller.textTaskCreateDateItem.text = [NSString stringWithFormat:@"任务创建时间：%@ \n取消本次优化后可重新选择",dateString];
}

//保存手动优化设置
- (void)saveMamualData {
    
    if (self.controller.mamualMethodVO.startDate == nil) {
        [AlertBox show:@"请选择开始日期"];
        return;
    }
    if (self.controller.mamualMethodVO.endDate == nil) {
        [AlertBox show:@"请选择结束日期"];
        return;
    }

    if ([self judgeDate]) {
        [AlertBox show:@"开启日期不能早于结束日期"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"taskType"]                = @"0";
    dic[@"startDate"]               = self.controller.mamualMethodVO.startDate;
    dic[@"endDate"]                 = self.controller.mamualMethodVO.endDate;
    dic[@"billOptimizationType"]    = @(self.controller.mamualMethodVO.billOptimizationType);
    dic[@"billQuantityPercent"]     = @(self.controller.mamualMethodVO.billQuantityPercent);
    dic[@"turnoverPercent"]         = @(self.controller.mamualMethodVO.turnoverPercent);
    [self saveMamualData:dic];
}
//保存手动优化设置
- (void)saveMamualData:(NSDictionary *)dic {
    [self.hud showAnimated:YES];
    [_service saveBillModifyTarget:dic target:self Callback:@selector(mamualRequestBack:)];
}
- (void)mamualRequestBack:(RemoteResult *)result{
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self loadMamualData];
}
- (BOOL)judgeDate {
    
    NSDateFormatter *formattr = [[NSDateFormatter alloc] init];
    [formattr setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *startDate = [formattr dateFromString:self.controller.mamualMethodVO.startDate];
    NSDate *endDate = [formattr dateFromString:self.controller.mamualMethodVO.endDate];
    long startTime  = startDate.timeIntervalSince1970;
    long endTimd    = endDate.timeIntervalSince1970;
    
    return endTimd < startTime;
}








#pragma mark --- 自动优化的操作
#pragma mark --- 自动优化的操作
#pragma mark --- 自动优化的操作
//从服务端获取自动优化的设置
- (void)loadAutoData {
    [_service queryBillModifyWithInfo:1 target:self callback:@selector(getAutoInfoBack:)];
}
- (void)getAutoInfoBack:(RemoteResult *)result
{
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    self.controller.autoMethodVO  = [JsonHelper dicTransObj:data obj:[BillOptimizationTaskVo new]];
    if ([ObjectUtil isEmpty:self.controller.autoMethodVO]) {
        self.controller.autoMethodVO = [BillOptimizationTaskVo new];
        [self autoClearData];
    }else{
        [self autoFillData:self.controller.autoMethodVO];
    }
}
//服务端没有自动优化数据的操作的时候
- (void)autoClearData {
    
    self.controller.autoMethodVO.billQuantityPercent    =   50;
    self.controller.autoMethodVO.turnoverPercent        =   50;
    self.controller.autoMethodVO.billOptimizationType   =   0;
    self.controller.autoMethodVO.dateOffSet             =   1;
    
    self.controller.pickerAutoOptimizeDayItem.preValue  = @"1";
    self.controller.pickerAutoOptimizeDayItem.textValue = @"1";
    
    self.controller.autoPickerOptimizeBillTypeItem.textValue    =   [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:0];
    self.controller.autoPickerOptimizeBillTypeItem.preValue     =   [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:0];
    
    self.controller.autoPickerBillPerOfTotalNumItem.textValue   =   @"50";
    self.controller.autoPickerBillPerOfTotalNumItem.preValue    =   @"50";
    
    self.controller.autoPickerBillPerOfTurnOverItem.textValue   =   @"50";
    self.controller.autoPickerBillPerOfTurnOverItem.preValue    =   @"50";
    
    //设置picker的默认值
    TDFShowPickerStrategy *picStrategy = (TDFShowPickerStrategy *)self.controller.autoPickerBillPerOfTurnOverItem.strategy;
    NSString *per = [NSString stringWithFormat:@"%d",self.controller.autoMethodVO.turnoverPercent];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    picStrategy = (TDFShowPickerStrategy *)self.controller.autoPickerBillPerOfTotalNumItem.strategy;
    per = [NSString stringWithFormat:@"%d",self.controller.autoMethodVO.billQuantityPercent];
    item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    [self.controller.manager reloadData];
}
//服务端有数据的时候，填充设置
- (void)autoFillData:(BillOptimizationTaskVo *)data {
    
    self.controller.pickerAutoOptimizeDayItem.preValue      = [NSString stringWithFormat:@"%d",data.dateOffSet];
    self.controller.pickerAutoOptimizeDayItem.textValue     = [NSString stringWithFormat:@"%d",data.dateOffSet];
    
    self.controller.autoPickerOptimizeBillTypeItem.preValue     = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:data.billOptimizationType];
    self.controller.autoPickerOptimizeBillTypeItem.textValue    = [TDFTableDataOptimizeStringFormater stringByBillOptimizeType:data.billOptimizationType];
    
    if (data.billOptimizationType) {
        TDFShowPickerStrategy *picStrategy = (TDFShowPickerStrategy *)self.controller.autoPickerOptimizeBillTypeItem.strategy;
        picStrategy.selectedItem = [[NameItemVO alloc] initWithVal:[TDFTableDataOptimizeStringFormater stringByBillOptimizeType:1] andId:@"1"];
    }
    
    //设置picker的默认值
    TDFShowPickerStrategy *picStrategy = (TDFShowPickerStrategy *)self.controller.autoPickerBillPerOfTurnOverItem.strategy;
    NSString *per = [NSString stringWithFormat:@"%d",self.controller.autoMethodVO.turnoverPercent];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    
    picStrategy = (TDFShowPickerStrategy *)self.controller.autoPickerBillPerOfTotalNumItem.strategy;
    per = [NSString stringWithFormat:@"%d",self.controller.autoMethodVO.billQuantityPercent];
    item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    picStrategy = (TDFShowPickerStrategy *)self.controller.pickerAutoOptimizeDayItem.strategy;
    per = [NSString stringWithFormat:@"%d",self.controller.autoMethodVO.dateOffSet];
    item = [[NameItemVO alloc] initWithVal:per andId:per];
    picStrategy.selectedItem = item;
    
    self.controller.autoPickerBillPerOfTotalNumItem.preValue    = [NSString stringWithFormat:@"%d",data.billQuantityPercent];
    self.controller.autoPickerBillPerOfTotalNumItem.textValue   = [NSString stringWithFormat:@"%d",data.billQuantityPercent];
    
    self.controller.autoPickerBillPerOfTurnOverItem.preValue    = [NSString stringWithFormat:@"%d",data.turnoverPercent];
    self.controller.autoPickerBillPerOfTurnOverItem.textValue   = [NSString stringWithFormat:@"%d",data.turnoverPercent];
    [self changeAutoOptimizeBillType];          //设置自动优化账单类型
    [self.controller.manager reloadData];
}
//更改自动优化账单类型操作
- (void)changeAutoOptimizeBillType {
    if (self.controller.isAuto) {
        self.controller.autoPickerBillPerOfTurnOverItem.shouldShow  =       !self.controller.autoMethodVO.billOptimizationType;
        self.controller.autoPickerBillPerOfTotalNumItem.shouldShow  =       self.controller.autoMethodVO.billOptimizationType;
        [self.controller.manager reloadData];
    }
}
//保存数据
- (void)saveAutoData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"onOff"]                   = @"true";
    dic[@"taskType"]                = @"1";
    dic[@"taskId"]                  = self.controller.autoMethodVO.taskId;
    dic[@"dateOffSet"]              = @(self.controller.autoMethodVO.dateOffSet);
    dic[@"billOptimizationType"]    = @(self.controller.autoMethodVO.billOptimizationType);
    dic[@"billQuantityPercent"]     = @(self.controller.autoMethodVO.billQuantityPercent);
    dic[@"turnoverPercent"]         = @(self.controller.autoMethodVO.turnoverPercent);
    [self saveAutoData:dic];
}
//保存自动优化设置
- (void)saveAutoData:(NSDictionary *)dic {
    [self.hud showAnimated:YES];
    [_service saveBillModifyTarget:dic target:self Callback:@selector(autoRequestBack:)];
}
- (void)autoRequestBack:(RemoteResult *)result {
    [self.hud hideAnimated:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.controller.navigationController popViewControllerAnimated:YES];
}


@end















