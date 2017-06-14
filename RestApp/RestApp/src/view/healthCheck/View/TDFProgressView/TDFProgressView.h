//
//  TDFProgressView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/6.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFProgressView : UIView

@property (nonatomic, assign)CGFloat allTime;

- (void)startAnimationWithStartTime:(CGFloat)startTime;

- (void)startAnimationWithAlltime:(CGFloat)allTime;
@end
