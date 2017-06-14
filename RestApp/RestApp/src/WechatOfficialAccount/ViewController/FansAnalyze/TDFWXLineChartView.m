//
//  TDFWXLineChartView.m
//  TDFLineChart
//
//  Created by 黄河 on 2017/4/20.
//  Copyright © 2017年 黄河. All rights reserved.
//
#import <TDFCategories/TDFCategories.h>
#import "TDFWXLineChartView.h"

const CGFloat TDFLineChartAxisTextW = 100.0f;
const CGFloat TDFLineChartAxisTextH = 9.0f;

@implementation TDFWXLinePoint : NSObject
+ (instancetype)pointWithX:(NSString *)x y:(CGFloat)y {
    TDFWXLinePoint *p = [[self alloc] init];
    p.x = x;
    p.y = y;
    return p;
}
@end

@interface TDFWXLineChartView ()

@property (nonatomic, strong)CAShapeLayer *lineLayer;

@property (nonatomic, strong)CAShapeLayer *coordinateLayer;

@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *pointsLayers;
@property (strong, nonatomic) NSMutableArray <UILabel *> *xLabels;
@property (strong, nonatomic) NSMutableArray <UILabel *> *yLabels;
@property (strong, nonatomic) NSMutableArray <UILabel *> *pLabels;
@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *yGridLayers;
@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *lineLayers;
@end


@implementation TDFWXLineChartView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pointsLayers = @[].mutableCopy;
        self.xLabels = @[].mutableCopy;
        self.yLabels = @[].mutableCopy;
        self.pLabels = @[].mutableCopy;
        self.yGridLayers = @[].mutableCopy;
        self.lineLayers = @[].mutableCopy;
        
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.coordinateLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    
    [self drawView];
    
    [self drawLineChart];
}

- (void)drawView {
    UIBezierPath *ypath = [UIBezierPath bezierPath];
    [ypath moveToPoint:CGPointMake(0, 0)];
    [ypath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [ypath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    self.coordinateLayer.path = ypath.CGPath;
    self.coordinateLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.coordinateLayer.fillColor = [UIColor clearColor].CGColor;
    self.coordinateLayer.lineWidth = 0.5;
    
    [self drawXLayer];
    [self drawYLayer];
    
}

- (void)drawYLayer {
    [self.yGridLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.yGridLayers removeAllObjects];
    [self.yLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.yLabels removeAllObjects];
    
    if (!self.yAxisValues.count) {
        return;
    }
    
    CGFloat vSpacing = self.bounds.size.height / (CGFloat)self.yAxisValues.count;
    for (NSInteger i = 0; i < self.yAxisValues.count + 1; i ++) {
        
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(-TDFLineChartAxisTextW - 5,
                                                                    self.frame.size.height - vSpacing * i - TDFLineChartAxisTextH * 0.5,
                                                                    TDFLineChartAxisTextW,
                                                                    TDFLineChartAxisTextH)];
        yLabel.font = [UIFont systemFontOfSize:TDFLineChartAxisTextH];
        yLabel.textColor = [UIColor whiteColor];
        yLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:yLabel];
        [self.yLabels addObject:yLabel];
        if (!i) {
            yLabel.text = (@0).stringValue;
        } else {
            yLabel.text = self.yAxisValues[i - 1];
            
            CGPoint start = CGPointMake(0, vSpacing * (i - 1));
            CGPoint end = CGPointMake(self.bounds.size.width, vSpacing * (i - 1));
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:start];
            [path addLineToPoint:end];
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.strokeColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5].CGColor;
            layer.lineWidth = 0.5;
            layer.path = path.CGPath;
            [self.coordinateLayer addSublayer:layer];
            [self.yGridLayers addObject:layer];
        }
    }
}

- (void)drawXLayer {
    [self.xLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.xLabels removeAllObjects];
    
    if (!self.lines.firstObject.count) {
        return;
    }
    
    CGFloat hSpacing = self.bounds.size.width / (CGFloat)self.lines.firstObject.count;
    for (NSInteger i = 0 ; i < self.lines.firstObject.count; i ++) {
        UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * hSpacing - TDFLineChartAxisTextW * 0.5,
                                                                    self.frame.size.height + 5,
                                                                    TDFLineChartAxisTextW,
                                                                    TDFLineChartAxisTextH)];
        xLabel.text = self.lines.firstObject[i].x;
        xLabel.font = [UIFont systemFontOfSize:TDFLineChartAxisTextH];
        xLabel.textColor = [UIColor whiteColor];
        xLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:xLabel];
        
        [self.xLabels addObject:xLabel];
    }
}

- (void)drawLineChart {
    [self.pointsLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.pointsLayers removeAllObjects];
    [self.lineLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.lineLayers removeAllObjects];
    [self.pLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pLabels removeAllObjects];
    
    if (!self.lines.count || CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    
    CGFloat yMaxValue = [self.yAxisValues.lastObject floatValue];
    
    CGFloat yHeight = yMaxValue - 0;
    
    CGFloat hSpacing = self.lines.firstObject.count > 0 ? self.bounds.size.width / (CGFloat)(self.lines.firstObject.count) : self.bounds.size.width ;
    for (NSArray <TDFWXLinePoint *> *points in self.lines) {
        
        if (!points.count) {
            continue;
        }
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineJoin = kCALineJoinRound;
        lineLayer.lineWidth = 2.0;
        lineLayer.strokeColor = [UIColor redColor].CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:lineLayer];
        [self.lineLayers addObject:lineLayer];
        
        for (NSInteger i = 0; i < points.count; i++) {
            TDFWXLinePoint *point = points[i];
            
            CGFloat y = yHeight ? self.bounds.size.height - (point.y / yHeight) * self.bounds.size.height : self.bounds.size.height;
            CGPoint descPoint = CGPointMake(hSpacing * (i + 1), y);
            
            if (!i) {
                [linePath moveToPoint:descPoint];
            } else {
                [linePath addLineToPoint:descPoint];
            }
            
            CGFloat inflexionWidth = 4.0f;
            CGRect circleRect = CGRectMake(hSpacing * (i + 1) - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
            CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
            UIBezierPath *pointPath = [UIBezierPath bezierPath];
            [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
            [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
            pointPath.lineWidth = 0.5;
            
            CAShapeLayer *pointLayer = [CAShapeLayer layer];
            pointLayer.lineCap = kCALineCapRound;
            pointLayer.lineJoin = kCALineJoinBevel;
            pointLayer.lineWidth = 0.5;
            pointLayer.strokeColor = [UIColor redColor].CGColor;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
            pointLayer.path = pointPath.CGPath;
            [self.layer addSublayer:pointLayer];
            [self.pointsLayers addObject:pointLayer];
            
            UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TDFLineChartAxisTextW, TDFLineChartAxisTextH)];
            pLabel.center = CGPointMake((i + 1) * hSpacing, y - TDFLineChartAxisTextH);
            pLabel.text = @(point.y).stringValue;
            pLabel.font = [UIFont systemFontOfSize:TDFLineChartAxisTextH];
            pLabel.textColor = [UIColor whiteColor];
            pLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:pLabel];
            [self.pLabels addObject:pLabel];
            
        }
        
        lineLayer.path = linePath.CGPath;
    }
}

+ (CGFloat)yAxisValueLength:(NSString *)value {
    return [value tdf_widthForFont:[UIFont systemFontOfSize:TDFLineChartAxisTextH]] + 5;
}
#pragma mark --setter && getter
- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
    }
    return _lineLayer;
}

- (CAShapeLayer *)coordinateLayer {
    if (!_coordinateLayer) {
        _coordinateLayer = [CAShapeLayer layer];
    }
    return _coordinateLayer;
}

- (void)setLines:(NSArray<NSArray<TDFWXLinePoint *> *> *)lines {
    _lines = lines;
    
    [self drawLineChart];
}
@end


