//
//  TDFCycleView.m
//  ClassProperties
//
//  Created by xueyu on 2016/12/7.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import "TDFCycleView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
@interface TDFCycleView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIColor *progressColor;
@end
@implementation TDFCycleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lineWidth = 5;
        _label = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view.textAlignment =  NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:9];
            view;
        });

    }
    return self;
}

-(void)loadDatas:(id)data{
    _progressColor = [UIColor colorWithHexString:data[@"color"]];
    self.label.textColor = [UIColor colorWithHexString:data[@"color"]];
    [self drawProgress:[data[@"value"] integerValue]*0.01];
}
-(void)drawRect:(CGRect)rect{
    [self drawCycleProgress];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
}

- (void)drawProgress:(CGFloat )progress
{
//    NSLog(@"%.2f",self.frame.size.height);
    self.label.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    _progress = progress;
    [self setNeedsDisplay];

}

- (void)drawCycleProgress
{

    BOOL isClockwise = _progress > 0 ? YES:NO;
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置

    CAShapeLayer *backgroundLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)  radius:CGRectGetWidth(self.bounds) / 2 - _lineWidth / 2    startAngle:endA endAngle:M_PI * 2 lineWidth:_lineWidth   color:[UIColor colorWithHexString:@"#EFEFEF"] clockwise:YES];
    [self.layer addSublayer:backgroundLayer];
    _progressLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.bounds) / 2 - _lineWidth / 2  startAngle:-M_PI_2 endAngle:endA lineWidth:_lineWidth color:_progressColor clockwise:isClockwise];
    [self.layer addSublayer:_progressLayer];

    
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle  endAngle:(CGFloat)endAngle lineWidth:(CGFloat)lineWidth color:(UIColor *)color clockwise:(BOOL)clockwise{
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor
                       ].CGColor;
    slice.strokeColor = color.CGColor;
    slice.opacity = 1;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}
@end
