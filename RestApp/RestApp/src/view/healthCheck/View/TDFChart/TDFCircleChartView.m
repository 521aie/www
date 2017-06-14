//
//  TDFCircleChartView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/5.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFCircleChartView.h"
#import "TDFCircleView.h"
#import "Masonry.h"
@interface TDFCircleChartView ()
{
    CGFloat _width;
    CGFloat _space;
}
@end

@implementation TDFCircleChartView

- (instancetype)initWithWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        _width = width;
        _space = 15;
    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self updateView];
}

- (void)updateView {
    CGFloat width = (_width - (_dataArray.count + 1) * _space)/_dataArray.count;
    for (int i = 0; i < _dataArray.count; i ++) {
        TDFCircleView *circleView = [TDFCircleView new];
        [self addSubview:circleView];
        circleView.scoreText = @"-200%";
        circleView.backgroundColor = [UIColor redColor];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(_space + (_space + width) * i);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(width);
            make.width.mas_equalTo(width);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
}

@end
