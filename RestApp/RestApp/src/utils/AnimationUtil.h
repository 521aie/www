//
//  AnimationUtil.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-29.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationUtil : NSObject

+ (void)startEaseInEaseOutAnimate:(UIView *)animView duration:(CFTimeInterval)duration;

+ (void)startMoveInAnimate:(UIView *)animView duration:(CFTimeInterval)duration;

+ (void)startMoveOutAnimate:(UIView *)animView duration:(CFTimeInterval)duration;

+ (CABasicAnimation *)generateShakeAnimation:(UIView *)view;

+ (CABasicAnimation *)generateShakeAnimationOnce:(UIView *)view;

@end
