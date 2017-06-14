//
//  TDFHomeReportHistogramView.h
//  Pods
//
//  Created by happyo on 2017/3/30.
//
//

#import <UIKit/UIKit.h>
@class TDFHomeReportListCellModel;
@class TDFHomeReportHistogramModel;
@class TDFHomeReportHistogramView;
@class TDFHistogramModel;
@class TDFHistogramView;

/**
 TDFHomeReportHistogramView 子类必须实现 TDFHomeReportHistogramProtocol 这个协议
 */
@protocol TDFHomeReportHistogramProtocol <NSObject>

@required
- (TDFHistogramModel *)transformReportModelToHistogramModel:(TDFHomeReportHistogramModel *)reportModel maxAccount:(double)maxAccount;

- (void)configureTitleWithModel:(TDFHomeReportHistogramModel *)reportModel;

- (CGFloat)histogramItemWidth;

@optional
- (void)updateHistogramMasonry;

@end

@protocol TDFHomeReportHistogramDelegate <NSObject>

@optional
- (void)homeReportHistogramView:(TDFHomeReportHistogramView *)histogramView didScrollToModel:(TDFHomeReportHistogramModel *)model;

- (void)homeReportHistogramView:(TDFHomeReportHistogramView *)histogramView didClickForwardButton:(NSString *)forwardUrl;

@end

@interface TDFHomeReportHistogramModel : NSObject

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *account;

@property (nonatomic, assign) double dAccount;

@property (nonatomic, strong) NSArray<TDFHomeReportListCellModel *> *commonCells;

@end

@interface TDFHomeReportHistogramView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) TDFHistogramView *histogramView;

@property (nonatomic, weak) id<TDFHomeReportHistogramProtocol> child;

@property (nonatomic, weak) id<TDFHomeReportHistogramDelegate> delegate;

- (void)configureViewWithModelList:(NSArray<TDFHomeReportHistogramModel *> *)modelList forwardString:(NSString *)forwardString forwardUrl:(NSString *)forwardUrl;

- (CGFloat)heightForView;

@end
