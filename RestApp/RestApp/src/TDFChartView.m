//
//  TDFChartView.m
//  RestApp
//
//  Created by happyo on 2016/12/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFChartView.h"
#import "TDFCategories.h"


const CGFloat TDFChartAxisTextW = 100.0f;
const CGFloat TDFChartAxisTextH = 9.0f;

@implementation TDFPoint : NSObject
+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y {
    TDFPoint *p = [[self alloc] init];
    p.x = x;
    p.y = y;
    return p;
}
@end

@implementation TDFLine

- (instancetype)init
{
    self = [super init];
    
    if (!self) {
        self.points = [NSArray array];
        self.color = [UIColor redColor];
    }
    
    return self;
}

@end

@interface TDFChartView ()

@property (nonatomic, strong)CAShapeLayer *lineLayer;

@property (nonatomic, strong)CAShapeLayer *coordinateLayer;

@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *pointsLayers;
@property (strong, nonatomic) NSMutableArray <UILabel *> *xLabels;
@property (strong, nonatomic) NSMutableArray <UILabel *> *yLabels;
@property (strong, nonatomic) NSMutableArray <UILabel *> *pLabels;
@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *yGridLayers;
@property (strong, nonatomic) NSMutableArray <CAShapeLayer *> *lineLayers;

@property (nonatomic, strong) NSMutableArray<UIView *> *lineDescViews;
@end


@implementation TDFChartView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pointsLayers = @[].mutableCopy;
        self.xLabels = @[].mutableCopy;
        self.yLabels = @[].mutableCopy;
        self.pLabels = @[].mutableCopy;
        self.yGridLayers = @[].mutableCopy;
        self.lineLayers = @[].mutableCopy;
        self.xAxisValues = [NSArray array];
        
        self.showPointLabel = NO;
        self.showPointCircle = NO;
        
        self.axisColor = [UIColor whiteColor];
        
        self.xLabelColor = [UIColor whiteColor];
        self.yLabelColor = [UIColor whiteColor];
        
        self.yMax = 100;
        
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
    self.coordinateLayer.strokeColor = self.axisColor.CGColor;
    self.coordinateLayer.fillColor = [UIColor clearColor].CGColor;
    
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
        
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(-TDFChartAxisTextW - 5,
                                                                    self.frame.size.height - vSpacing * i - TDFChartAxisTextH * 0.5,
                                                                    TDFChartAxisTextW,
                                                                    TDFChartAxisTextH)];
        yLabel.font = [UIFont systemFontOfSize:TDFChartAxisTextH];
        yLabel.textColor = self.yLabelColor;
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
            [layer setLineJoin:kCALineJoinRound];
            [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
            [self.coordinateLayer addSublayer:layer];
            [self.yGridLayers addObject:layer];
        }
    }
}

- (void)drawXLayer {
    [self.xLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.xLabels removeAllObjects];
    
    //    TDFLine *firstLine = self.lines.firstObject;
    if (!self.xAxisValues.count) {
        return;
    }
    
    CGFloat hSpacing = [self getHSpace];
    for (NSInteger i = 0 ; i < self.xAxisValues.count; i ++) {
        UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * hSpacing - TDFChartAxisTextW * 0.5,
                                                                    self.frame.size.height + 5,
                                                                    TDFChartAxisTextW,
                                                                    TDFChartAxisTextH)];
        xLabel.text = self.xAxisValues[i];
        xLabel.font = [UIFont systemFontOfSize:TDFChartAxisTextH];
        xLabel.textColor = self.xLabelColor;
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
    [self.lineDescViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lineDescViews removeAllObjects];
    
    if (!self.lines.count || CGRectEqualToRect(self.bounds, CGRectZero)) {
        return;
    }
    
    CGFloat yMaxValue = self.yMax;
    CGFloat yHeight = yMaxValue - 0;
    
    CGFloat hSpacing = [self getHSpace];
    
    for (int index = 0; index < self.lines.count; index++) {
        TDFLine *line = self.lines[index];
        
        if (!line.points.count) {
            continue;
        }
        NSInteger lineIndex = index % 2;
        NSInteger row = index / 2 + 1;
        
        CGFloat startX = (self.bounds.size.width - 85 * 2 - 50) / 2.0;
        UIView *lineDescView = [[UIView alloc] initWithFrame:CGRectMake(startX + lineIndex * 85 + lineIndex * 50, self.bounds.size.height + 20 + (row - 1) * 20, 100, 9)];
        UIView *lineColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 4.5, 25, 2)];
        lineColorView.backgroundColor = line.color;
        UILabel *lineDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, 9)];
        lineDescLabel.font = [UIFont systemFontOfSize:9];
        lineDescLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        lineDescLabel.text = line.title;
        
        [lineDescView addSubview:lineColorView];
        [lineDescView addSubview:lineDescLabel];
        
        [self addSubview:lineDescView];
        [self.lineDescViews addObject:lineDescView];
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 2.0;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.lineJoin = kCALineJoinRound;
        lineLayer.strokeColor = line.color.CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:lineLayer];
        [self.lineLayers addObject:lineLayer];
        
        for (NSInteger i = 0; i < line.points.count; i++) {
            TDFPoint *point = line.points[i];
            
            CGFloat y = yHeight ? self.bounds.size.height - (point.y / yHeight) * self.bounds.size.height : self.bounds.size.height;
            CGPoint descPoint = CGPointMake(hSpacing * i, y);
            
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
            
            if (self.showPointCircle) {
                CAShapeLayer *pointLayer = [CAShapeLayer layer];
                pointLayer.lineCap = kCALineCapRound;
                pointLayer.lineJoin = kCALineJoinBevel;
                pointLayer.lineWidth = 0.5;
                pointLayer.strokeColor = [UIColor redColor].CGColor;
                pointLayer.fillColor = [UIColor whiteColor].CGColor;
                pointLayer.path = pointPath.CGPath;
                [self.layer addSublayer:pointLayer];
                [self.pointsLayers addObject:pointLayer];
            }
            
            if (self.showPointLabel) {
                UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TDFChartAxisTextW, TDFChartAxisTextH)];
                pLabel.center = CGPointMake((i + 1) * hSpacing, y - TDFChartAxisTextH);
                pLabel.text = @(point.y).stringValue;
                pLabel.font = [UIFont systemFontOfSize:TDFChartAxisTextH];
                pLabel.textColor = [UIColor whiteColor];
                pLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:pLabel];
                [self.pLabels addObject:pLabel];
            }
            
        }
        
        lineLayer.path = linePath.CGPath;
    }
}

- (CGFloat)getHSpace
{
    if (self.xAxisValues.count < 2) {
        return 10;
    }
    
    CGFloat hSpacing = self.bounds.size.width / (CGFloat)(self.xAxisValues.count - 1);
    
    return hSpacing;
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

- (void)setLines:(NSArray<TDFLine *> *)lines {
    _lines = lines;
    
    [self drawLineChart];
}

- (NSMutableArray<UIView *> *)lineDescViews
{
    if (!_lineDescViews) {
        _lineDescViews = [NSMutableArray<UIView *> array];
    }
    
    return _lineDescViews;
}

@end


