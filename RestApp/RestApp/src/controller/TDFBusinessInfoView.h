//
//  TDFBusinessInfoView.h
//  RestApp
//
//  Created by happyo on 2016/11/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFBusinessInfoModel.h"
@class TDFBusinessInfoView;

typedef NS_ENUM(NSInteger, TDFBusinessDateStyle) {
    TDFBusinessDateStyleDay,
    TDFBusinessDateStyleMonth
};

typedef NS_ENUM(NSInteger, TDFMoreButtonStyle) {
    TDFMoreButtonStyleExtension,
    TDFMoreButtonStyleForward,
    TDFMoreButtonStyleNone
};

@protocol TDFBusinessInfoViewDelegate <NSObject>

- (void)businessInfoView:(TDFBusinessInfoView *)view monthDidChanged:(NSString *)newMonth;

- (void)businessInfoViewHeightChanged:(TDFBusinessInfoView *)view;

@end

@interface TDFBusinessInfoView : UIView

@property (nonatomic, strong) void (^forwardBlock)(NSString *dayString); // 右侧forwar点击block

@property (nonatomic, strong) void (^extensionBlock)();  // 右侧的展开block

@property (nonatomic, weak) id<TDFBusinessInfoViewDelegate> delegate;

// 显示未展开的view，有 当月 和 当日 两种
- (void)configureViewWithAccount:(double)account dateStyle:(TDFBusinessDateStyle)dateStyle dateString:(NSString *)dateString;

// 显示展开的 当日收益图
- (void)configureViewWithDayList:(NSArray<TDFBusinessInfoModel *> *)dayList monthDate:(NSString *)monthDate;

// 显示展开的 当月收益图
//- (void)configureViewWithMonthModel:(TDFBusinessInfoModel *)monthModel;

// 显示展开的 月收益图
- (void)configureViewWithMonthList:(NSArray<TDFBusinessInfoModel *> *)monthList;

- (CGFloat)heightForInfoView;

@end
