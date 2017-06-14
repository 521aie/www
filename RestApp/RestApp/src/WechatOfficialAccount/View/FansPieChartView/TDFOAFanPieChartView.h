//
//  TDFOAFanPieChartView.h
//  TDFDNSPod
//
//  Created by Octree on 17/3/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDFOAFanPieChartItemPresentable <NSObject>

@property (nonatomic) CGFloat ratio;
@property (nonatomic) UIColor *pieColor;
@property (copy, nonatomic, readonly) NSString *pieDescription;
@property (copy, nonatomic, readonly) NSString *highlightDescription;
@property (copy, nonatomic, readonly) NSString *commentTitle;
@property (copy, nonatomic, readonly) NSString *commentDescription;
@property (copy, nonatomic, readonly) NSString *commentRatioDescription;

@end


@class TDFOAFanPieChartView;

@protocol TDFOAFanPieChartViewDelegate <NSObject>

- (void)fanPieChartView:(TDFOAFanPieChartView *)chartView didSelectItemAtIndex:(NSInteger)index;
- (void)fanPieChartViewDidDeSelectItem:(TDFOAFanPieChartView *)chartView;

@end

@interface TDFOAFanPieChartView : UIView

@property (weak, nonatomic) id<TDFOAFanPieChartViewDelegate> delegate;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic, readonly) UIButton *fansButton;

- (instancetype)initWithTitle:(NSString *)title presenters:(NSArray <id<TDFOAFanPieChartItemPresentable>>*)presenters;
/**
 *  更新视图
 *
 *  @param presenters presenters
 */
- (void)reloadWithPresenters:(NSArray <id<TDFOAFanPieChartItemPresentable>>*)presenters;

- (CGFloat)expectedHeight;


@end
