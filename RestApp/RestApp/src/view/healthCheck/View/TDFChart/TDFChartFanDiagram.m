//
//  TDFChartFanDiagram.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/1.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFChartFanDiagram.h"
#import "UIColor+Hex.h"
@interface TDFChartFanDiagram ()
@property (nonatomic, assign)CGFloat radius;
@end
@implementation TDFChartFanDiagram


- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius {
    return  [self initWithCenter:center radius:radius
                   withDataArray:nil andColorArray:nil];
}

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius
                 withDataArray:(NSArray *)dataArray
                 andColorArray:(NSArray *)colorArray {
    self = [super init];
    if (self) {
        self.radius = radius;
        self.center = center;
        self.bounds = CGRectMake(0, 0, radius * 2.0, radius * 2.0);
        if (dataArray) {
            self.dataArray = dataArray;
        }
        if (colorArray) {
            self.colorArray = colorArray;
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.radius = self.bounds.size.width/2.0;
}

-(void)loadDatas:(id)data{
    self.dataArray = data[@"percent"];
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self layoutIfNeeded];
    [self drawFanDiagram];
}

- (void)drawFanDiagram {
    
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = startAngle;
    CGFloat total = 0.0f;
    for (int i = 0; i < _dataArray.count; i++) {
        total += [_dataArray[i] floatValue];
    }
    
    for (int i = 0; i < _dataArray.count; i ++) {
        if ([_dataArray[i] floatValue] == 0) {
            continue;
        }
        endAngle = ([_dataArray[i] floatValue] / total) * 2 * M_PI + startAngle;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.radius, self.radius)];
        [path addArcWithCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path closePath];
        CAShapeLayer *shaperLayer = [CAShapeLayer layer];
        shaperLayer.fillColor = [[UIColor colorWithHexString:_colorArray[i]] CGColor];
        shaperLayer.path = path.CGPath;
        [self.layer addSublayer:shaperLayer];
        
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%.0f",[_dataArray[i] floatValue]];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.textAlignment = NSTextAlignmentCenter;
        label.bounds = CGRectMake(0, 0, 15, 9);
        label.font = [UIFont systemFontOfSize:9];
        CGFloat labelCenterY = (self.radius * 0.75) *sin(([_dataArray[i] floatValue] / total) * M_PI + startAngle) + self.radius;
        CGFloat labelCenterX = (self.radius * 0.75) *cos(([_dataArray[i] floatValue] / total) * M_PI + startAngle) + self.radius;
        label.center = CGPointMake(labelCenterX, labelCenterY);
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        startAngle = endAngle;
    }
}

-(UIColor *)colorRandom
{
    CGFloat r=arc4random_uniform(256)/255.0;
    CGFloat g=arc4random_uniform(256)/255.0;
    CGFloat b=arc4random_uniform(256)/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
@end
