//
//  TDFPieChartView.m
//  TDFDNSPod
//
//  Created by Octree on 8/3/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFPieChartView.h"

@interface TDFPieChartView ()<CAAnimationDelegate>

@property (strong, nonatomic) CAShapeLayer *highlightedLayer;
@property (strong, nonatomic) UIView *pieView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;

@end

@implementation TDFPieChartView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        _shouldHighlight = YES;
        _duration = 0.8;
        [self configViews];
    }
    return self;
}

#pragma mark - Public Method

- (void)stroke:(BOOL)animated {
    
    [self.pieView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self initialPieLayer];
    !animated ?: [self showStrokeAnimtion];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self stroke:YES];
}
#pragma mark - Private Method

#pragma mark Config Views

- (void)configViews {

    [self addSubview:self.pieView];
}


#pragma mark Pie Layer

- (CGFloat)pieRadius {

    return self.radius ?: MIN(self.frame.size.width, self.frame.size.height) / 2;
}

- (void)initialPieLayer {

    CGFloat radius = [self pieRadius];
    CGFloat start = 0;
    for (TDFPieChartItem *item in self.items) {
        
        CAShapeLayer *layer = [self generateShapeLayerWithStartPersentage:start
                                                            endPersentage:start + item.ratio
                                                                    color:item.color
                                                              borderWidth:radius
                                                                   radius:radius / 2];
        [self.pieView.layer addSublayer:layer];
        start += item.ratio;
    }
}

- (CAShapeLayer *)generateShapeLayerWithStartPersentage:(CGFloat)start
                                          endPersentage:(CGFloat)end
                                                  color:(UIColor *)color
                                            borderWidth:(CGFloat)borderWidth
                                                 radius:(CGFloat)radius {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:[self pieCenter]
                                                              radius:radius
                                                          startAngle:-M_PI_2
                                                            endAngle:M_PI_2 * 3
                                                           clockwise:YES];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeStart = start;
    shapeLayer.strokeEnd = end;

    return shapeLayer;
}

- (CGPoint)pieCenter {

    return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark Animation

- (CAShapeLayer *)generateMaskLayer {

    CGFloat radius = [self pieRadius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:[self pieCenter]
                                                              radius:radius / 2
                                                          startAngle:-M_PI_2
                                                            endAngle:M_PI_2 * 3
                                                           clockwise:YES];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.lineWidth = radius;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    return shapeLayer;
}

- (void)showStrokeAnimtion {

    self.maskLayer = [self generateMaskLayer];
    self.pieView.layer.mask = self.maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = self.duration;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [self.maskLayer addAnimation:animation forKey:@"animation"];
}

#pragma mark Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self.pieView];
    [self didTouchAtPoint:touchLocation];
}

- (void)didTouchAtPoint:(CGPoint)touchLocation {
    CGPoint circleCenter = [self pieCenter];
    
    if (self.items.count == 0) {
        return;
    }
    
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y),2) + powf((touchLocation.x - circleCenter.x),2));
    
    if (distanceFromCenter > [self pieRadius]) {
        
        if (distanceFromCenter > [self pieRadius] + 5 && [self.delegate respondsToSelector:@selector(pieChartViewDidTouchOutSide:)]) {
            [self.delegate pieChartViewDidTouchOutSide:self];
            [self.highlightedLayer removeFromSuperlayer];
        }
        return;
    }
    
    [self.highlightedLayer removeFromSuperlayer];
    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
    CGFloat start;
    CGFloat end;
    NSUInteger index = [self findIndexWithPersentage:percentage startPersentage:&start endPersenage:&end];
    
    if ([self.delegate respondsToSelector:@selector(pieChartView:didSelectedItemAtIndex:)]) {
        
        [self.delegate pieChartView:self didSelectedItemAtIndex:index];
    }
    
    TDFPieChartItem *item = self.items[index];
    CGFloat radius = [self pieRadius];
    self.highlightedLayer = [self generateShapeLayerWithStartPersentage:start
                                                        endPersentage:end
                                                                color:item.color
                                                          borderWidth:10
                                                               radius:radius];
    [self.pieView.layer addSublayer:self.highlightedLayer];
}

- (NSUInteger)findIndexWithPersentage:(CGFloat)persentage startPersentage:(CGFloat *)startPersentage endPersenage:(CGFloat *)endPersentage {

    CGFloat end = 0;
    NSInteger index = 0;
    for (TDFPieChartItem *item in self.items) {
        end += item.ratio;
        if (persentage < end) {
            
            *startPersentage = end - item.ratio;
            *endPersentage = end;
            return index;
        }
        index++;
    }
    
    return index;
}

- (CGFloat)findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference{
    
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI/2)/(2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.pieView.layer.mask = nil;
    self.maskLayer = nil;
}

#pragma mark - Accessor

- (UIView *)pieView {

    if (!_pieView) {
        
        _pieView = [[UIView alloc] initWithFrame:self.bounds];
        _pieView.backgroundColor = [UIColor clearColor];
        _pieView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
    }
    return _pieView;
}

@end


@implementation TDFPieChartItem

- (instancetype)initWithRatio:(CGFloat)ratio color:(UIColor *)color text:(NSString *)text {

    if (self = [super init]) {
        
        _ratio = ratio;
        _color = color;
        _text = text;
    }
    return self;
}

+ (instancetype)itemWithRatio:(CGFloat)ratio color:(UIColor *)color text:(NSString *)text {

    return [[[self class] alloc] initWithRatio:ratio color:color text:text];
}

@end
