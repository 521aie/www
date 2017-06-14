//
//  TDFOfficialAccountMenuCell.m
//  TDFFakeOfficialAccount
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFOfficialAccountMenuCell.h"

@interface TDFOfficialAccountMenuCell ()

@property (nonatomic) BOOL showArrow;
@property (nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation TDFOfficialAccountMenuPresenter

@end


@implementation TDFOfficialAccountMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configLayers];
    }
    return self;
}

+ (Class)layerClass {

    return [CAShapeLayer class];
}

- (void)configLayers {
    
    self.backgroundColor = [UIColor clearColor];
    self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = 1;
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowRadius = 1;
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
}

- (CGSize)sizeThatFits:(CGSize)size withPresenter:(TDFOfficialAccountMenuPresenter *)presenter {

    size.height = presenter.showArrow ? 42 : 35;
    return size;
}

- (void)updateWithPresenter:(TDFOfficialAccountMenuPresenter *)presenter {

    self.showArrow = presenter.showArrow;
    CGPathRef path = [self pathForShadow].CGPath;
    self.shapeLayer.path = path;
    self.layer.shadowPath = path;
}


- (UIBezierPath *)pathForShadow {
    
    if (!self.showArrow) {
        
        return [UIBezierPath bezierPathWithRect:self.bounds];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(0, height - 7)];
    
    CGFloat halfWidth = width / 2;
    
    [path addLineToPoint:CGPointMake(halfWidth - 7, height - 7)];
    [path addLineToPoint:CGPointMake(halfWidth, height)];
    [path addLineToPoint:CGPointMake(halfWidth + 7, height - 7)];
    [path addLineToPoint:CGPointMake(width, height - 7)];
    
    [path addLineToPoint:CGPointMake(width, 0)];
    
    [path closePath];
    return path;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.showArrow = NO;
}

- (CAShapeLayer *)shapeLayer {
    
    return (CAShapeLayer *)self.layer;
}

@end
