//
//  UIViewController+Picker.h
//  RestApp
//
//  Created by Octree on 8/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "TDFOptionPickerController.h"

typedef void  (^TDFDateCompletionBlock)(NSDate *date);
typedef void  (^TDFOptionPickerCompletion)(NSInteger index);

@interface UIViewController (Picker)


- (void)showDatePickerWithTitle:(NSString *)title mode:(UIDatePickerMode)mode editItem:(EditItemList *)item;

- (void)showDatePickerWithTitle:(NSString *)title mode:(UIDatePickerMode)mode editItem:(EditItemList *)item mininumDate:(NSDate *)date maxinumDate:(NSDate *)date;

- (void)showDatePickerWithTitle:(NSString *)title mode:(UIDatePickerMode)mode editItem:(EditItemList *)item mininumDate:(NSDate *)mindate maxinumDate:(NSDate *)maxdate completionBlock:(TDFDateCompletionBlock)completion;


@end
