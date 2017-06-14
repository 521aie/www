//
//  SeatListView.m
//  RestApp
//
//  Created by zxh on 14-4-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "SignBillDateView.h"
#import "UIViewController+Picker.h"
#import "TDFDatePickerController.h"

@implementation SignBillDateView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    [self initWithDate:self.startDate endDate:self.endDate];
}

- (void)initNavigate
{
    self.title = NSLocalizedString(@"挂账日期", nil);
}

- (void)initMainView
{
    [self.startDateLst initLabel:NSLocalizedString(@"开始日期", nil) withHit:nil isrequest:YES delegate:self];
    [self.endDateLst initLabel:NSLocalizedString(@"结束日期", nil) withHit:nil isrequest:YES delegate:self];
}


- (void)initWithDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    [self.startDateLst initData:[DateUtils formatTimeWithDate:self.startDate type:TDFFormatTimeTypeYearMonthDay] withVal:[DateUtils formatTimeWithDate:self.startDate type:TDFFormatTimeTypeYearMonthDay]];
    [self.endDateLst initData:[DateUtils formatTimeWithDate:self.endDate type:TDFFormatTimeTypeYearMonthDay] withVal:[DateUtils formatTimeWithDate:self.endDate type:TDFFormatTimeTypeYearMonthDay]];
}

- (IBAction)confirmBtnClick:(id)sender
{
    if (self.callBack) {
        self.callBack(self.startDate,self.endDate);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onItemListClick:(EditItemList *)obj
{
    __weak __typeof(self) wself = self;
    if (obj==self.startDateLst) {
        [self showDatePickerWithTitle:NSLocalizedString(@"开始日期", nil) mode:(UIDatePickerModeDate) editItem:obj mininumDate:nil maxinumDate:self.endDate completionBlock:^void(NSDate *newDate){
            
            wself.startDate = newDate;
        }];
    } else if (obj==self.endDateLst){
        [self showDatePickerWithTitle:NSLocalizedString(@"结束日期", nil) mode:(UIDatePickerModeDate) editItem:obj mininumDate:self.startDate maxinumDate:nil completionBlock:^void(NSDate *newDate){
        
            wself.endDate = newDate;
        }];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    if (event==SIGN_BILL_START_DATE) {
        date = [DateUtils parseDateStart:date];
        if (self.endDate!=nil && [date timeIntervalSince1970]>[self.endDate timeIntervalSince1970]) {
            [AlertBox show:NSLocalizedString(@"开始日期不能晚于结束日期哦！", nil)];
            return NO;
        } else {
            self.startDate = date;
            [self.startDateLst initData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay] withVal:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay]];
        }
    } else if (event==SIGN_BILL_END_DATE) {
        date = [DateUtils parseDateEnd:date];
        if (self.startDate!=nil && [date timeIntervalSince1970]<[self.startDate timeIntervalSince1970]) {
            [AlertBox show:NSLocalizedString(@"结束日期不能早于开始日期哦！", nil)];
            return NO;
        } else {
            self.endDate = date;
            [self.endDateLst initData:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay] withVal:[DateUtils formatTimeWithDate:date type:TDFFormatTimeTypeYearMonthDay]];
        }
    }
    return YES;
}

@end
