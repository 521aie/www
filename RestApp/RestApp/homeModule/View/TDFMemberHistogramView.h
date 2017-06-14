//
//  TDFMemberHistogramView.h
//  Pods
//
//  Created by happyo on 2017/4/10.
//
//

#import <UIKit/UIKit.h>
@class TDFMemberInfoDayModel;
@class TDFMemberInfoMonthModel;
@class TDFMemberHistogramView;

@protocol TDFMemberHistogramViewProtocol <NSObject>

@optional
- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView switchStyle:(BOOL)isDayStyle;

- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView didScrollToDayModel:(TDFMemberInfoDayModel *)dayModel atIndex:(NSInteger)index;

- (void)memberHistogramView:(TDFMemberHistogramView *)histogramView didScrollToMonthModel:(TDFMemberInfoMonthModel *)monthModel atIndex:(NSInteger)index;

@end

@interface TDFMemberHistogramView : UIView

@property (nonatomic, strong) id<TDFMemberHistogramViewProtocol> delegate;

- (void)configureViewWithDayList:(NSArray<TDFMemberInfoDayModel *> *)dayList;

- (void)configureViewWithMonthList:(NSArray<TDFMemberInfoMonthModel *> *)monthList;

- (CGFloat)heightForView;

@end
