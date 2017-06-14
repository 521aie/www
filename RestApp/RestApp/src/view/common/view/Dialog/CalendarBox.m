//
//  DatePickerBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppController.h"
#import "CalendarBox.h"
#import "SystemUtil.h"

static CalendarBox *calendarBox;

@implementation CalendarBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.hidden = YES;
}

+ (void)initCalendarBox:(UIViewController *)appController
{
    calendarBox = (CalendarBox *)[appController.view viewWithTag:TAG_CALENDARBOX];
    if(!calendarBox) {
        calendarBox = [[CalendarBox alloc]initWithNibName:@"CalendarBox"bundle:nil];
        calendarBox.view.tag = TAG_CALENDARBOX;
        [appController.view addSubview:calendarBox.view];
    }
}

+ (void)show:(NSString *)title dateList:(NSArray *)dateList client:(id<CalendarClient>)client;
{
    calendarBox->calendarClient = client;
    [calendarBox showMoveIn];
}

+ (void)hide
{
    [calendarBox hideMoveOut];
}

- (IBAction)confirmBtnClick:(id)sender
{
    
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

@end
