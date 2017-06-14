//
//  UIView+TDFUIKit.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/9.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "UIView+TDFUIKit.h"

@implementation UIView (TDFUIKit)

- (CGFloat)tdf_width {
    return self.frame.size.width;
}

- (CGFloat)tdf_height {
    return self.frame.size.height;
}

- (CGFloat)tdf_originX {
    return self.frame.origin.x;
}

- (CGFloat)tdf_originY {
    return self.frame.origin.y;
}

- (CGFloat)tdf_rightX {
    return (self.tdf_originX + self.tdf_width);
}

- (CGFloat)tdf_bottomY {
    return (self.tdf_originY + self.tdf_height);
}

- (void)tdf_setX:(CGFloat)x {
    [self tdf_setX:x tdf_setY:self.tdf_originY];
}

- (void)tdf_setY:(CGFloat)y {
    [self tdf_setX:self.tdf_originX tdf_setY:y];
}

- (void)tdf_setWidth:(CGFloat)width {
    [self tdf_setWidth:width tdf_setHeight:self.tdf_height];
}

- (void)tdf_setHeight:(CGFloat)height {
    [self tdf_setWidth:self.tdf_width tdf_setHeight:height];
}

- (void)tdf_setX:(CGFloat)x tdf_setY:(CGFloat)y {
    [self setFrameWith:x y:y width:self.tdf_width height:self.tdf_height];
}

- (void)tdf_setWidth:(CGFloat)width tdf_setHeight:(CGFloat)height {
    [self setFrameWith:self.tdf_originX y:self.tdf_originY width:width height:height];
}

- (void)setFrameWith:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    self.frame = CGRectMake(x, y, width, height);
}

- (void)setTop:(CGFloat)top {
    
}

- (void)setLeft:(CGFloat)left {
    
}

- (void)setRight:(CGFloat)right {
    
}

- (void)setBottom:(CGFloat)bottom {
    
}

@end
