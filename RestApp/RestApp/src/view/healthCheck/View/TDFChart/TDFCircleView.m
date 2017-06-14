//
//  TDFCircleView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/5.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFCircleView.h"
#import "Masonry.h"
@interface TDFCircleView ()
{
    BOOL _clockwise;
}
@property (nonatomic, strong)CAShapeLayer *circleLayer;

@property (nonatomic, strong)CAShapeLayer *shadowLayer;

@property (nonatomic, strong)UILabel *label;

@end

@implementation TDFCircleView

- (instancetype)init {
    self = [super init];
    if (self) {
        _clockwise = YES;
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.shadowLayer];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layouView];
}

- (void)layouView {
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetWidth(self.frame)/2.0)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0) radius:CGRectGetWidth(self.frame)/2.0 startAngle:-M_PI_2 endAngle:M_PI clockwise:_clockwise ];
    [path closePath];
    self.circleLayer.path = path.CGPath;
    
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    [shadowPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0) radius:CGRectGetWidth(self.frame)/2.0-10 startAngle:0 endAngle:2 *M_PI clockwise:_clockwise ];
    self.shadowLayer.fillColor = [UIColor whiteColor].CGColor;
    self.shadowLayer.path = shadowPath.CGPath;
}

#pragma mark -- setter && getter
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CAShapeLayer layer];
    }
    return _shadowLayer;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (void)setScoreText:(NSString *)scoreText {
    _scoreText = scoreText;
    self.label.text = scoreText;
    if ([_scoreText hasPrefix:@"-"]) {
        _clockwise = NO;
    }else {
        _clockwise = YES;
    }
}
@end
