//
//  TDFBusinessBarChartView.h
//  RestApp
//
//  Created by happyo on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFBusinessInfoModel;
@class TDFBusinessBarChartView;

@protocol TDFBusinessBarChartViewDelegate <NSObject>

@optional
- (void)chartView:(TDFBusinessBarChartView *)chartView monthDidChanged:(NSString *)newDate;

/**
 日柱状图的回调

 @param chartView
 @param newDayModel 选中的日model
 @param dayDate xx日
 */
- (void)chartView:(TDFBusinessBarChartView *)chartView dayDidChanged:(TDFBusinessInfoModel *)newDayModel dayDate:(NSString *)dayDate;

/**
 月柱状图的回调

 @param chartView
 @param newMonthModel 选中的月model
 @param monthDate xx月
 */
- (void)chartView:(TDFBusinessBarChartView *)chartView monthDidChanged:(TDFBusinessInfoModel *)newMonthModel monthDate:(NSString *)monthDate;

@end

@interface TDFBusinessBarChartView : UIView

@property (nonatomic, strong) id<TDFBusinessBarChartViewDelegate> delegate;

- (void)configureViewWithDayList:(NSArray<TDFBusinessInfoModel *> *)dayList monthDate:(NSString *)monthDate;

- (void)configureViewWithMonthList:(NSArray<TDFBusinessInfoModel *> *)monthList;

+ (CGFloat)heightForChartView;

@end
