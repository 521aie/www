//
//  UIView+TDFUIKit.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/9.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TDFUIKit)

@property (nonatomic, assign, readonly)CGFloat tdf_height;
@property (nonatomic, assign, readonly)CGFloat tdf_width;

@property (nonatomic, assign, readonly)CGFloat tdf_originX;
@property (nonatomic, assign, readonly)CGFloat tdf_originY;

@property (nonatomic, assign, readonly)CGFloat tdf_rightX;

@property (nonatomic, assign, readonly)CGFloat tdf_bottomY;

- (void)tdf_setX:(CGFloat)x;
- (void)tdf_setY:(CGFloat)y;
- (void)tdf_setWidth:(CGFloat)width;
- (void)tdf_setHeight:(CGFloat)height;

- (void)tdf_setX:(CGFloat)x tdf_setY:(CGFloat)y;
- (void)tdf_setWidth:(CGFloat)width tdf_setHeight:(CGFloat)height;
@end
