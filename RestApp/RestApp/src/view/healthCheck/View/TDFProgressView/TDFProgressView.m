//
//  TDFProgressView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/6.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFProgressView.h"
#import "Masonry.h"
#import "UIView+TDFUIKit.h"
#import "UIColor+Hex.h"
@interface TDFProgressView ()
{
    CGFloat _width;
}

@property (nonatomic, strong)CAGradientLayer *progressLayer;

@property (nonatomic, strong)UIView *shadowView;

@end

@implementation TDFProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    self.layer.masksToBounds = YES;
//    self.progressLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    self.progressLayer.frame = CGRectMake(0, 0, 0, 0);
    self.progressLayer.startPoint = CGPointMake(0, 0);
    self.progressLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:self.progressLayer];
    self.shadowView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.shadowView.frame = CGRectMake(0, 0, 0, 0);
    [self addSubview:self.shadowView];
//    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
    }
    return _shadowView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.tdf_height/2.0;
    [self updateProgressFrame];
}

- (void)updateProgressFrame {
    self.progressLayer.frame = CGRectMake(self.progressLayer.frame.origin.x, self.progressLayer.frame.origin.y,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.shadowView.frame = CGRectMake(0, 0, self.tdf_width, self.tdf_height);
}

#pragma mark --setter && getter
- (CALayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAGradientLayer layer];
    }
    return _progressLayer;
}

- (void)setAllTime:(CGFloat)allTime {
    _allTime = allTime;
    [self startAnimationWithAlltime:allTime];
}

#pragma mark --Animation

- (void)startAnimationWithStartTime:(CGFloat)startTime {
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:startTime animations:^{
        [self.shadowView tdf_setX:100];
    } completion:nil];
}

- (void)startAnimationWithAlltime:(CGFloat)allTime {
    NSLog(@"-----%f",[[NSDate date] timeIntervalSince1970]);
    [UIView animateWithDuration:allTime  animations:^{
        [self.shadowView tdf_setX:self.tdf_rightX];
    } completion:^(BOOL finished) {
        NSLog(@"-----%f",[[NSDate date] timeIntervalSince1970]);
    }];
}

@end
