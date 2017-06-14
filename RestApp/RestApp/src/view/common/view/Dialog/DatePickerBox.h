//
//  DatePickerBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppController.h"
#import "DatePickerClient.h"
#import "PopupBoxViewController.h"

@interface DatePickerBox : PopupBoxViewController
{
    id<DatePickerClient> datePickerClient;
    
    NSInteger event;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UILabel *lblDateClear;
@property (nonatomic, retain) IBOutlet UIButton *btnClear;

+ (void)initDatePickerBox:(AppController *)appController;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client event:(NSInteger)eventType;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)eventType;

//显示带清空按钮的页.(供应链新增)
+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DatePickerClient>) client event:(int)event;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)clearBtnClick:(id)sender;

@end
