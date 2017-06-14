//
//  TDFShowDatePickerStategy.m
//  RestApp
//
//  Created by Octree on 13/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShowDatePickerStrategy.h"
#import "TDFDatePickerController.h"

@implementation TDFShowDatePickerStrategy


- (void)invoke {
    [self showDatePickerView];
}

- (void)showDatePickerView {
    
    TDFDatePickerController *vc = [[TDFDatePickerController alloc] initWithTitle:self.pickerName
                                                                     currentDate:self.currentDate
                                                                  datePickerMode:self.mode];
    vc.maxinumDate = self.maxinumDate;
    vc.mininumDate = self.mininumDate;
    vc.competionBlock = ^(NSDate *newDate) {
        if ([self.delegate conformsToProtocol:@protocol(TDFPickerStrategyDelegate)]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = self.format;
            if ([self.delegate strategyCallbackWithTextValue:[formatter stringFromDate:newDate] requestValue:newDate]) {
                self.currentDate = newDate;
            }
        }
    };
    
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:vc animated:YES completion:nil];
}

@end
