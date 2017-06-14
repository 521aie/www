//
//  TDFImaginaryLineView.m
//  RestApp
//
//  Created by tripleCC on 2017/5/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFImaginaryLineView.h"

@interface TDFImaginaryLineView()
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation TDFImaginaryLineView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.shapeLayer && !CGRectEqualToRect(self.frame, CGRectZero)) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        
        [shapeLayer setStrokeColor:self.lineColor.CGColor];
        
        [shapeLayer setLineWidth:self.frame.size.height];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:self.lineWidth], [NSNumber numberWithInt:self.lineSpacing], nil]];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
        [self.layer addSublayer:shapeLayer];
        self.shapeLayer = shapeLayer;
    }
}
@end
