//
//  TDFWaveAnimationView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/24.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TDFWaveAnimationView : UIControl

@property (nonatomic, assign)CGFloat score;

@property (nonatomic, assign) NSInteger levelType;

@property (nonatomic, strong)NSString *attentionText;

@property (nonatomic, assign)BOOL isShowAttentionText;

@property (nonatomic, assign)BOOL isShowWaveAnimation;

@property (nonatomic, strong) NSArray<NSDictionary *> *colorRules;

///没体检或者重新体检
@property (nonatomic, assign)BOOL isNoScore;

///error
@property (nonatomic, assign)BOOL isError;

///circleLayer 旋转半径
@property (nonatomic, assign)CGFloat circleRadius;

@property (nonatomic, copy)void(^touchClick)();

- (void)setScoreFontSize:(CGFloat)scoreFontSize descFontSize:(CGFloat)descFontSize;

- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimation duration:(CGFloat)duration;

- (void)updateFrameWithPercent:(CGFloat)percent;

- (void)updateImageViewAndFrameWithScore:(CGFloat)score;

- (void)updateColorWithType:(NSInteger)colorType;

- (instancetype)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius;

- (void)startCircleAnimation;

- (void)stopCircleAnimation;

@end
