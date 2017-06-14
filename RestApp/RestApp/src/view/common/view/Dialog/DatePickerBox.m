//
//  DatePickerBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DatePickerClient.h"
#import "DatePickerBox.h"
#import "AppController.h"
#import "ObjectUtil.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"

static DatePickerBox *datePickerBox;

@implementation DatePickerBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
    self.view.hidden = YES;
}

+ (void)initDatePickerBox:(AppController *)appController
{
    datePickerBox = [[DatePickerBox alloc]initWithNibName:@"DatePickerBox"bundle:nil];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:datePickerBox.view];
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>) client event:(NSInteger)eventType
{
    if ([ObjectUtil isNotNull:date]) {
        [datePickerBox.datePicker setDate:date animated:YES];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date] animated:YES];
    }
    datePickerBox.lblTitle.text = title;
    datePickerBox->datePickerClient = client;
    [datePickerBox.lblDateClear setHidden:YES];
    [datePickerBox.img setHidden:YES];
    [datePickerBox.btnClear setHidden:YES];
    datePickerBox->event = eventType;
    datePickerBox.datePicker.hidden = NO;
    [datePickerBox.datePicker setMinimumDate:nil];
    [datePickerBox showMoveIn];
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)eventType
{
    [DatePickerBox show:title date:date client:client event:eventType];
    if (startDate!=nil) {
        [datePickerBox.datePicker setMinimumDate:startDate];
    } else {
        [datePickerBox.datePicker setMinimumDate:nil];
    }
    
    if (endDate!=nil) {
        [datePickerBox.datePicker setMaximumDate:endDate];
    } else {
        [datePickerBox.datePicker setMaximumDate:nil];
    }
}

//显示带清空按钮的页.
+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DatePickerClient>) client event:(int)event
{
    if (date != nil) {
        [datePickerBox.datePicker setDate:date animated:YES];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date] animated:YES];
    }
    datePickerBox.lblTitle.text=title;
    datePickerBox->datePickerClient = client;
    datePickerBox->event=event;
    [datePickerBox.lblDateClear setLeft:(310-datePickerBox.lblDateClear.width)];
    [datePickerBox.img setLeft:(datePickerBox.lblDateClear.left-28)];
    [datePickerBox.btnClear setWidth:datePickerBox.lblDateClear.width+28];
    [datePickerBox.btnClear setLeft:datePickerBox.img.left];
    [datePickerBox.lblDateClear setHidden:NO];
    [datePickerBox.img setHidden:NO];
    [datePickerBox.btnClear setHidden:NO];
    [datePickerBox showMoveIn];
}

- (IBAction)clearBtnClick:(id)sender
{
    [datePickerClient clearDate:event];
    [self hideMoveOut];
}

+ (void)hide
{
    [datePickerBox hideMoveOut];
}

- (IBAction)confirmBtnClick:(id)sender
{
    if (datePickerBox->event == 11) {
         [self hideMoveOut];
    }
    NSDate *date = [self.datePicker date];
    if ([datePickerClient pickDate:date event:event]) {
        [self hideMoveOut];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

@end
