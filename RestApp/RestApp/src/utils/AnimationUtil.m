//
//  AnimationUtil.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-29.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AnimationUtil.h"

@implementation AnimationUtil

+ (void)startEaseInEaseOutAnimate:(UIView *)animView duration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [animView.layer addAnimation:animation forKey:nil];
}

+ (void)startMoveInAnimate:(UIView *)animView duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [animView.layer addAnimation:animation forKey:nil];
}

+ (void)startMoveOutAnimate:(UIView *)animView duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [animView.layer addAnimation:animation forKey:nil];
}

+ (CABasicAnimation *)generateShakeAnimation:(UIView *)view
{
    CGFloat rotation = 0.03;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    return shake;
}

+ (CABasicAnimation *)generateShakeAnimationOnce:(UIView *)view
{
    CGFloat rotation = 0.4;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.2;
    shake.autoreverses = NO;
    shake.repeatCount  = 3;
    shake.removedOnCompletion = YES;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    return shake;
}

@end
