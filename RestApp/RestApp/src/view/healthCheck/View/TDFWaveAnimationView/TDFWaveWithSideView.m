//
//  TDFWaveWithSideView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/28.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFWaveWithSideView.h"
#import "TDFWaveAnimationView.h"
#import "UIColor+Hex.h"
@interface TDFWaveWithSideView ()
{
    CGFloat _radius;
    
}
///弧线与圆的交点水平线距离view底部距离（控制高度）
@property (nonatomic, assign)CGFloat interSectionToBottom;

///圆最底部距离view最底部(控制陷入的深度)
@property (nonatomic, assign)CGFloat circleToBottom;

@property (nonatomic, strong)TDFWaveAnimationView *waveAnimationView;

@property (nonatomic, strong)CAGradientLayer *gradientLayer;

@end

@implementation TDFWaveWithSideView

- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius {
    self = [super initWithFrame:frame];
    if (self) {
        self.interSectionToBottom = 10;
        self.circleToBottom = -15;
        _radius = radius;
        self.waveAnimationView = [[TDFWaveAnimationView alloc] initWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)-(_radius + self.circleToBottom)) andRadius:radius];
        [self.waveAnimationView setScoreFontSize:38 descFontSize:12];
        self.waveAnimationView.isShowWaveAnimation = YES;
        __weak TDFWaveWithSideView *weakSelf = self;
        self.waveAnimationView.touchClick = ^{
            if (weakSelf.touchClick) {
                weakSelf.touchClick();
            }
        };
        
        [self drawCurve];
        [self.layer addSublayer:self.waveAnimationView.layer];
        
        
        
    }
    return self;
}

- (void)drawCurve {
    
    ///交点距离中心点
    double distance = [self distanceToWaveViewCenterXWithRadius:_radius
                                     andDistanceInterSectionToBottom:self.interSectionToBottom
                                                   andcircleToBottom:self.circleToBottom];
    
    CGPoint pointLeft = CGPointMake(self.waveAnimationView.center.x - distance , CGRectGetHeight(self.frame) - self.interSectionToBottom);
    CGPoint pointRight = CGPointMake(self.waveAnimationView.center.x + distance , CGRectGetHeight(self.frame) - self.interSectionToBottom);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - self.interSectionToBottom + 5)];
    [path addQuadCurveToPoint:pointLeft controlPoint:CGPointMake([self controlPointXWithPonit1:CGPointMake(0, CGRectGetHeight(self.frame) - self.interSectionToBottom + 5) andPoint2:pointLeft], pointLeft.y)];
    
//    CGFloat bottomLeftDistance = [self distanceToWaveViewCenterXWithRadius:_radius
//                                     andDistanceInterSectionToBottom:0
//                                                   andcircleToBottom:self.circleToBottom];
    
//    CGPoint pointBottom = CGPointMake(self.waveAnimationView.center.x - bottomLeftDistance, CGRectGetHeight(self.frame));
    float startAngle = asin((self.waveAnimationView.center.x - pointLeft.x)/(_radius)) + M_PI_2;
//    float endAngle = asin((self.waveAnimationView.center.x - pointBottom.x)/(_radius)) + M_PI_2;
    float endAngle = asin((self.waveAnimationView.center.x - pointRight.x)/(_radius)) + M_PI_2;
    [path addArcWithCenter:self.waveAnimationView.center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:NO];

    [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.interSectionToBottom + 5) controlPoint:CGPointMake([self controlPointXWithPonit1:pointRight andPoint2:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.interSectionToBottom + 5)], pointRight.y)];
//
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
    [path closePath];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
//    layer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor greenColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, pointLeft.y/CGRectGetHeight(self.frame));
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer.mask = layer;
    [self.layer addSublayer:self.gradientLayer];
//    [self.layer addSublayer:layer];

}

- (void)updateHeight:(NSInteger)waterHeight
{
    [self.waveAnimationView updateFrameWithPercent:waterHeight / 100.0];
}

///找到相交点
- (double)distanceToWaveViewCenterXWithRadius:(CGFloat)radius
               andDistanceInterSectionToBottom:(CGFloat)interSectionBottom
                             andcircleToBottom:(CGFloat)circleToBottom {
    
    return sqrt((2 * (interSectionBottom - circleToBottom) * radius - pow((interSectionBottom - circleToBottom), 2)));
}

///贝塞尔基准点x
- (CGFloat)controlPointXWithPonit1:(CGPoint)point1
                         andPoint2:(CGPoint)point2 {
    CGFloat height = point2.y - point1.y;
    CGFloat width = point2.x - point1.x;
    CGFloat hypotenuse = (pow(height, 2) + pow(width, 2))/ (2.0 * width);
    return sqrt((pow(hypotenuse, 2) - pow(height, 2))) + point1.x;
}

#pragma mark -- setter && getter

- (void)setAttentionText:(NSString *)attentionText {
    _attentionText = attentionText;
    self.waveAnimationView.attentionText = attentionText;
}

- (void)setIsShowAttentionText:(BOOL)isShowAttentionText {
    _isShowAttentionText = isShowAttentionText;
    self.waveAnimationView.isShowAttentionText = isShowAttentionText;
}

- (void)setScore:(CGFloat)score {
    _score = score;
    self.waveAnimationView.score = score;
    self.waveAnimationView.colorRules = self.colorRules;
    [self.waveAnimationView updateImageViewAndFrameWithScore:score];
    [self updateSideColorWithScore:score];
}

- (void)setIsNoScore:(BOOL)isNoScore {
    _isNoScore = isNoScore;
    self.waveAnimationView.isNoScore = isNoScore;
    if (isNoScore) {
        self.gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#DE1F01" alpha:0.9].CGColor,(id)[UIColor colorWithHexString:@"#DE1F01" alpha:0.9].CGColor];
    }else {
        [self updateSideColorWithScore:self.score];
    }
    
}

- (void)updateSideColorWithScore:(CGFloat)score {
    
    NSInteger colorType = 0;
    
    for (NSDictionary *ruleDict in self.colorRules) {
        NSNumber *colorCode = ruleDict[@"colorCode"];
        NSNumber *scoreRatio = ruleDict[@"scoreRatio"];
        
        if (score >= [scoreRatio integerValue]) {
            colorType = [colorCode integerValue];
            break;
        }
    }
    [self updateColorWithType:colorType];
}

- (void)updateColorWithType:(NSInteger)colorType
{
    NSArray *array;

    if (colorType == 0) {
        array = @[(id)[UIColor colorWithHexString:@"#47D801" alpha:0.9].CGColor,(id)[UIColor colorWithHexString:@"#47D801" alpha:0.9].CGColor];
    }else if (colorType == 1) {
        array = @[(id)[UIColor colorWithHexString:@"#FF8800" alpha:0.9].CGColor,(id)[UIColor colorWithHexString:@"#FF8800" alpha:0.9].CGColor];
    }else if (colorType == 2) {
        array = @[(id)[UIColor colorWithHexString:@"#DE1F01" alpha:0.9].CGColor,(id)[UIColor colorWithHexString:@"#DE1F01" alpha:0.9].CGColor];
    }
    self.gradientLayer.colors = array;
    
    [self.waveAnimationView updateColorWithType:colorType];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    CGPoint btnP =  [self convertPoint:point toView:self.waveAnimationView];
    if ( [self.waveAnimationView pointInside:btnP withEvent:event]) {
        return self.waveAnimationView;
    }else {
        return [super hitTest:point withEvent:event];
    }
}

@end
