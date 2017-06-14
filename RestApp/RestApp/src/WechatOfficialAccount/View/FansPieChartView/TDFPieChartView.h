//
//  TDFPieChartView.h
//  TDFDNSPod
//
//  Created by Octree on 8/3/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFPieChartItem : NSObject

@property (nonatomic) CGFloat ratio;
@property (strong, nonatomic) UIColor *color;
@property (copy, nonatomic) NSString *text;

- (instancetype)initWithRatio:(CGFloat)ratio color:(UIColor *)color text:(NSString *)text;
+ (instancetype)itemWithRatio:(CGFloat)ratio color:(UIColor *)color text:(NSString *)text;

@end

@class TDFPieChartView;
@protocol TDFPieChartViewDelegate <NSObject>

- (void)pieChartView:(TDFPieChartView *)chartView didSelectedItemAtIndex:(NSUInteger)index;
- (void)pieChartViewDidTouchOutSide:(TDFPieChartView *)chartView;

@end

@interface TDFPieChartView : UIView

@property (weak, nonatomic) id<TDFPieChartViewDelegate> delegate;
@property (copy, nonatomic) NSArray<TDFPieChartItem *> *items;
//  radius, default min(width, height)
@property (nonatomic) CGFloat radius;
//  default true
@property (nonatomic) BOOL shouldHighlight;

//  animation duration, default: 0.8
@property (nonatomic) CGFloat duration;

- (void)stroke:(BOOL)animated;

@end
