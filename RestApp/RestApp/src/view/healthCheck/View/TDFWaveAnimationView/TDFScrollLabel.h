//
//  TDFScrollLabel.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/30.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFScrollLabel : UILabel

@property (nonatomic, copy)void(^callBack)(CGFloat score);

@property (nonatomic, assign) CGFloat scoreFontSize;

@property (nonatomic, assign) CGFloat descFontSize;

- (void)animationToValue:(NSNumber *)toValue
                duration:(CGFloat)duration
               animation:(BOOL)doAnimation;

@end
