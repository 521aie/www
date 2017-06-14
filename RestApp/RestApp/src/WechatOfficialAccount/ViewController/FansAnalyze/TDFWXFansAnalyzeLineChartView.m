//
//  TDFWXFansAnalyzeLineChartView.m
//  RestApp
//
//  Created by tripleCC on 2017/5/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <Masonry/Masonry.h>
#import <TDFCategories/TDFCategories.h>
#import <TDFBatchOperation/TDFBatchOperation.h>

#import "TDFWXFansAnalyzeLineChartView.h"
#import "TDFWXLineChartView.h"

@interface TDFWXFansAnalyzeLineChartView()
@property (strong, nonatomic) TDFWXLineChartView *chartView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *lineColorView;
@end

@implementation TDFWXFansAnalyzeLineChartView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        [self addSubview:self.chartView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineColorView];
        [self addSubview:self.detailLabel];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(@10);
            make.left.right.equalTo(self);
        }];
        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@58);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-20);
        }];
        [self.lineColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.titleLabel);
            make.width.height.equalTo(@10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    self.detailLabel.text = detail;
}

- (void)setChart:(NSArray<TDFWXChartModel *> *)chart {
    _chart = chart;
    
    NSInteger maxYValue = [[chart tdf_foldLeftWithStart:@0 reduce:^id(id result, TDFWXChartModel *next) {
        return @([result integerValue] > next.count ? [result integerValue] : next.count);
    }] integerValue];
    
    
    [self.chartView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10 + [TDFWXLineChartView yAxisValueLength:@(maxYValue).stringValue]));
    }];
    

    // 4能整除
    if (maxYValue % 4 != 0) maxYValue = ((maxYValue / 4) + 1) * 4;
    NSInteger vSpacing = maxYValue / 4;
    
    if (maxYValue > 0) {
        NSMutableArray *yAxisValues = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            [yAxisValues addObject:[NSString stringWithFormat:@"%ld", vSpacing * (i + 1)]];
        }
        self.chartView.yAxisValues = yAxisValues;
    } else {
        self.chartView.yAxisValues = nil;
    }
    
    NSArray *line = [chart tdf_map:^id(TDFWXChartModel *value) {
        return [TDFWXLinePoint pointWithX:value.date y:value.count];
    }];
    
    if (line) {
        self.chartView.lines = @[line];
    }
}


- (TDFWXLineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[TDFWXLineChartView alloc] init];
    }
    
    return _chartView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIView *)lineColorView {
    if (!_lineColorView) {
        _lineColorView = [[UIView alloc] init];
        _lineColorView.backgroundColor = [UIColor tdf_colorWithRGB:0xe12038];
        _lineColorView.layer.cornerRadius = 2.0f;
        _lineColorView.clipsToBounds = YES;
    }
    
    return _lineColorView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.numberOfLines = 2;
    }
    
    return _detailLabel;
}
@end
