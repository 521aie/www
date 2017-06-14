//
//  TDFHealthCheckHeaderView.h
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/7.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFCheckOverBottomView : UIView
@property (nonatomic, copy)void(^buttonClick)();


@property (nonatomic, strong)UILabel *resultLabel;
@end
@class TDFWaveAnimationView;
@interface TDFHealthCheckHeaderView : UIView

@property (nonatomic, copy)void(^buttonClick)();

@property (nonatomic, strong)TDFWaveAnimationView *waveAnimation;

@property (nonatomic, strong)UIProgressView *progressView;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, strong) NSArray<NSDictionary *> *colorRules;

//@property (nonatomic, strong)TDFCheckOverBottomView *bottomView;

@property (nonatomic, assign)CGFloat allTime;

@property (nonatomic, assign)BOOL isAnimationOver;

@property (nonatomic, copy)void(^checkSettingClick)();

@property (nonatomic, copy)void(^healthHistoryClick)();

@property (nonatomic, strong)NSString *text;

//@property (nonatomic, strong)NSAttributedString *resultAttributedString;

- (instancetype)initWithDefaultScore:(NSInteger)score;

- (void)congfigureSummarize:(NSAttributedString *)summarize compare:(NSAttributedString *)compare;

- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimation duration:(CGFloat)duration;

- (void)startAnimationWithStartTime:(CGFloat)startTime;

- (void)stopAnimation;

- (void)reset;

@end
