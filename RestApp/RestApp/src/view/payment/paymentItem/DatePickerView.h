//
//  DatePickerView.h
//  RestApp
//
//  Created by guopin on 16/6/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerView;
@protocol DatePickerViewEvent<NSObject>
-(void)pickerOption:(DatePickerView *)obj eventType:(NSInteger)evenType;
@end
@interface DatePickerView : UIView
@property(nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, assign)id<DatePickerViewEvent>delegate;
@property (nonatomic, assign) NSUInteger year;
@property (nonatomic, assign) NSUInteger month;
@property(nonatomic, strong)NSMutableArray *years;
@property(nonatomic, strong)NSMutableArray *monthes;
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title client:(id<DatePickerViewEvent>)delegate;
-(void)initDate:(NSUInteger)year month:(NSUInteger)month;
@end