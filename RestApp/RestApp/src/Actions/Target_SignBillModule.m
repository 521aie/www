//
//  Target_SignBillModule.m
//  RestApp
//
//  Created by 黄河 on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Target_SignBillModule.h"
#import "SignBillPayDetailView.h"
#import "SignBillConfirmView.h"
#import "SignBillDetailView.h"
#import "SignBillRecordView.h"
#import "SignBillDateView.h"
#import "SignBillPayView.h"
#import "SignBillView.h"
#import "SystemUtil.h"
#import "DateUtils.h"
@implementation Target_SignBillModule
///挂账处理
- (UIViewController *)Action_nativeSignBillViewController:(NSDictionary *)params
{
    SignBillView *signBill = [[SignBillView alloc]initWithNibName:@"SignBillView" bundle:nil];
    return signBill;
}

///已还款挂账单
- (UIViewController *)Action_nativeSignBillRecordViewController:(NSDictionary *)params
{
    SignBillRecordView *signBillRecordView = [[SignBillRecordView alloc] initWithNibName:@"SignBillRecordView" bundle:nil];
    signBillRecordView.callBack = params[@"callBack"];
    return signBillRecordView;
}

///还款详情
- (UIViewController *)Action_nativeSignBillPayDetailViewController:(NSDictionary *)params
{
    SignBillPayDetailView *signBillPayDetail = [[SignBillPayDetailView alloc] initWithNibName:@"SignBillPayDetailView" bundle:nil];
    signBillPayDetail.signBill = params[@"data"];
    signBillPayDetail.callBack = params[@"callBack"];
    return signBillPayDetail;
}

//加载添加挂账单详细信息
- (UIViewController *)Action_nativeSignBillDetailViewController:(NSDictionary *)params
{
    SignBillDetailView *signBillDetailView = [[SignBillDetailView alloc] initWithNibName:@"SignBillDetailView" bundle:nil];
    signBillDetailView.signBillPayNoPayOptionTotalVO = params[@"data"];
    return signBillDetailView;
}

//加载添加挂账日期界面
- (UIViewController *)Action_nativeSignBillDateViewController:(NSDictionary *)params
{
    SignBillDateView *signBillDateView = [[SignBillDateView alloc] initWithNibName:@"SignBillDateView" bundle:nil];
    NSDate *sourceDate = [NSDate date];
    NSDate *date = [DateUtils parseDateEnd:sourceDate];
    
    if (params[@"startDate"]!=nil) {
        signBillDateView.startDate = params[@"startDate"];
    } else {
        signBillDateView.startDate = [[NSDate alloc] initWithTimeInterval:-30*24*3600 sinceDate:sourceDate];
    }
    
    if (params[@"endDate"]!=nil) {
        signBillDateView.endDate = params[@"endDate"];
    } else {
        signBillDateView.endDate = date;
    }
    signBillDateView.callBack = params[@"callBack"];
    return signBillDateView;
}

//加载挂账确认界面
- (UIViewController *)Action_nativeSignBillConfirmViewController:(NSDictionary *)params
{
    SignBillConfirmView *signBillConfirmView = [[SignBillConfirmView alloc] initWithNibName:@"SignBillConfirmView" bundle:nil];
    signBillConfirmView.signBillPayNoPayOptionTotalVO = params[@"data"];
    signBillConfirmView.payIdSet = params[@"payIdSetArray"];
    return signBillConfirmView;
}

//加载挂账还款界面
- (UIViewController *)Action_nativeSignBillPayViewController:(NSDictionary *)params
{
    SignBillPayView *signBillPay = [[SignBillPayView alloc] initWithNibName:@"SignBillPayView" bundle:nil];
    signBillPay.payIdSet = params[@"payIdSet"];
    signBillPay.signBillPayNoPayOptionTotal = params[@"noPayData"];
    signBillPay.payTptalVO = params[@"payTotalData"];
    return signBillPay;
}
@end
