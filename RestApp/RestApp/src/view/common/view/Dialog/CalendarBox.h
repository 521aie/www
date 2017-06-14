//
//  DatePickerBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "Calendar.h"
#import <UIKit/UIKit.h>
#import "AppController.h"
#import "CalendarClient.h"
#import "PopupBoxViewController.h"

@interface CalendarBox : PopupBoxViewController
{
    id<CalendarClient> calendarClient;
    
    int event;
}
@property (nonatomic, retain) IBOutlet Calendar *calendar;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

+ (void)initCalendarBox:(UIViewController *)appController;

+ (void)show:(NSString *)title dateList:(NSArray *)dateList client:(id<CalendarClient>)client;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

@end
