//
//  TDFWaveAnimationView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/24.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFWaveAnimationView.h"
#import "TDFScrollLabel.h"
#import "UIView+TDFUIKit.h"
@interface TDFWaveAnimationView()

@property (nonatomic, strong)CADisplayLink *displayLink;

@property (nonatomic, strong)CAShapeLayer *waveLayer;

@property (nonatomic, strong)CAShapeLayer *circleLayer;

@property (nonatomic, strong)NSTimer *timer;


@property (nonatomic, assign)CGFloat startAngle;
///旋转的circleLayer 每次递增的角度
@property (nonatomic, assign)CGFloat incrementAngle;

@property (nonatomic, strong)TDFScrollLabel *scoreLabel;

@property (nonatomic, strong)UILabel *attentionLabel;

///两张图来回走实现波浪线效果
@property (nonatomic, strong)UIImageView *imageView1;
@property (nonatomic, strong)UIImageView *imageView2;

@property (nonatomic, strong)UIImageView *bottomImageView1;
@property (nonatomic, strong)UIImageView *bottomImageView2;

@property (nonatomic, strong)UIImageView *circleImageView;

@property (nonatomic, strong)UIImageView *heartRate;
@end

@implementation TDFWaveAnimationView

- (instancetype)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
        self.center = center;
        [self defaultConfig];
    }
    return self;
}

- (void)setScoreFontSize:(CGFloat)scoreFontSize descFontSize:(CGFloat)descFontSize
{
    self.scoreLabel.scoreFontSize = scoreFontSize;
    self.scoreLabel.descFontSize = descFontSize;
}

- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimation duration:(CGFloat)duration
{
    _score = score;
    [self.scoreLabel animationToValue:@(_score) duration:duration animation:isAnimation];
}

- (void)updateImageViewAndFrameWithScore:(CGFloat)score
{
    NSInteger colorType = 0;
    
    for (NSDictionary *ruleDict in self.colorRules) {
        NSNumber *colorCode = ruleDict[@"colorCode"];
        NSNumber *scoreRatio = ruleDict[@"scoreRatio"];
        
        if (score >= [scoreRatio integerValue]) {
            colorType = [colorCode integerValue];
            break;
        }
    }
    [self updateColorWithType:colorType];
}

- (void)updateColorWithType:(NSInteger)colorType
{
    if (colorType == 0) {
        [self updateImageWithTopImage:@"ico_greenfull" bottomImage:nil andCircleImage:@"ico_greencircle"];
    }else if (colorType == 1) {
        [self updateImageWithTopImage:self.isShowWaveAnimation ?@"ico_orangetop":@"ico_orangefull" bottomImage:self.isShowWaveAnimation ?@"ico_orangebottom":@"ico_orangefull" andCircleImage:@"ico_orangecircle"];
    }else if (colorType == 2) {
        [self updateImageWithTopImage:self.isShowWaveAnimation ?@"ico_redwavetop":@"ico_redfull" bottomImage:self.isShowWaveAnimation ?@"ico_redwavebottom":@"redfull" andCircleImage:@"ico_redcircle"];
    }
}


- (void)updateFrameWithPercent:(CGFloat)percent {
    [self updateFrameWithPercent:percent andView:self.imageView1];
    [self updateFrameWithPercent:percent andView:self.imageView2];
    [self updateFrameWithPercent:percent andView:self.bottomImageView1];
    [self updateFrameWithPercent:percent andView:self.bottomImageView2];
    
    if (percent == 1) {
        [self stopWaveAnimation];
    }else {
        [self beginWaveAnimation];
    }
}

- (void)updateImageWithTopImage:(NSString *)topImage
                    bottomImage:(NSString *)bottomImage
                 andCircleImage:(NSString *)circleImage {
    self.imageView1.image = [UIImage imageNamed:topImage];
    self.imageView2.image = [UIImage imageNamed:topImage];
    self.bottomImageView1.image = [UIImage imageNamed:bottomImage];
    self.bottomImageView2.image = [UIImage imageNamed:bottomImage];
    self.circleImageView.image = [UIImage imageNamed:circleImage];
}

- (void)updateFrameWithPercent:(CGFloat)percent andView:(UIImageView *)imageView {
    CGRect rect = imageView.frame;
    rect.origin.y = CGRectGetHeight(self.frame) *(1 - percent);
    rect.size.height = imageView.image.size.height;
    rect.size.width = imageView.image.size.width;
    imageView.frame = rect;
}


///默认配置
- (void)defaultConfig {
    self.incrementAngle = (2 * M_PI)/20;
    
    self.waveLayer.frame = self.bounds;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, nil, CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0,CGRectGetWidth(self.bounds) /2.0 - 2.5, 0, 2 * M_PI, YES);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    self.waveLayer.mask = layer;
    self.waveLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    [self.layer addSublayer:self.waveLayer];
    
    self.bottomImageView1.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.waveLayer.bounds), CGRectGetHeight(self.waveLayer.bounds));
    [self.waveLayer addSublayer:self.bottomImageView1.layer];
    
    self.bottomImageView2.frame = CGRectMake(-[UIImage imageNamed:@"ico_orangebottom"].size.width, CGRectGetHeight(self.waveLayer.bounds), CGRectGetWidth(self.waveLayer.bounds), CGRectGetHeight(self.waveLayer.bounds));
    [self.waveLayer addSublayer:self.bottomImageView2.layer];
    
    self.imageView1.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.waveLayer.bounds), CGRectGetHeight(self.waveLayer.bounds));
    [self.waveLayer addSublayer:self.imageView1.layer];
    
    self.imageView2.frame = CGRectMake(-[UIImage imageNamed:@"ico_orangetop"].size.width, CGRectGetHeight(self.frame), CGRectGetWidth(self.waveLayer.bounds), CGRectGetHeight(self.waveLayer.bounds));
    [self.waveLayer addSublayer:self.imageView2.layer];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2.0 ;

    self.circleImageView = [[UIImageView alloc] init];
    self.circleImageView.frame = self.bounds;
    [self addSubview:self.circleImageView];
    [self.layer addSublayer:self.circleLayer];
    [self startCircleAnimation];
    
    self.heartRate.hidden = YES;
    [self addSubview:self.heartRate];
    @weakify(self);

    self.scoreLabel.callBack = ^(CGFloat score){
        @strongify(self);
        [self updateImageViewAndFrameWithScore:score];
    };
    [self addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startCircleAnimation {
    if (!_timer) {
        self.startAngle = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAngel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateAngel {
    self.circleImageView.transform = CGAffineTransformMakeRotation(self.startAngle);
    self.startAngle = self.startAngle + self.incrementAngle;
}

- (void)stopCircleAnimation {
    [_timer invalidate];
    _timer = nil;
}

- (void)beginWaveAnimation {
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawLine)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopWaveAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)drawLine {
    
    CGRect rect = self.imageView1.frame;
    if (rect.origin.x >= self.tdf_width) {
        rect.origin.x = self.imageView2.tdf_originX - self.imageView1.tdf_width;
        self.imageView1.frame = rect;
    }
    rect.origin.x += 2;
    self.imageView1.frame = rect;
    
    
    
    rect = self.imageView2.frame;
    if (rect.origin.x >= self.tdf_width) {
        rect.origin.x = self.imageView1.tdf_originX - self.imageView2.tdf_width;
        self.imageView2.frame = rect;
    }
    rect.origin.x += 2;
    self.imageView2.frame = rect;
    
    rect = self.bottomImageView1.frame;
    if (rect.origin.x >= self.tdf_width) {
        rect.origin.x = self.bottomImageView2.tdf_originX - self.bottomImageView2.tdf_width;
        self.bottomImageView1.frame = rect;
    }
    rect.origin.x += 1;
    self.bottomImageView1.frame = rect;
    
    
    
    rect = self.bottomImageView2.frame;
    if (rect.origin.x >= self.tdf_width) {
        rect.origin.x = self.bottomImageView1.tdf_originX - self.bottomImageView2.tdf_width;
        self.bottomImageView2.frame = rect;
    }
    rect.origin.x += 1;
    self.bottomImageView2.frame = rect;
}
#pragma mark -- touchClick
- (void)selectClick:(UIControl *)control {
    if (self.touchClick) {
        self.touchClick();
    }
}

#pragma mark -- setter && getter

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
    }
    return _imageView2;
}

- (UIImageView *)bottomImageView1 {
    if (!_bottomImageView1) {
        _bottomImageView1 = [UIImageView new];
        _bottomImageView1.contentMode = UIViewContentModeTop;
    }
    return _bottomImageView1;
}

- (UIImageView *)bottomImageView2 {
    if (!_bottomImageView2) {
        _bottomImageView2 = [UIImageView new];
        _bottomImageView2.contentMode = UIViewContentModeTop;
    }
    return _bottomImageView2;
}

- (CAShapeLayer *)waveLayer
{
    if (!_waveLayer) {
        _waveLayer = [[CAShapeLayer alloc] init];
    }
    return _waveLayer;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
    }
    return _circleLayer;
}

- (UILabel *)attentionLabel {
    if (!_attentionLabel) {
        _attentionLabel = [UILabel new];
        _attentionLabel.textColor = [UIColor whiteColor];
        _attentionLabel.font = [UIFont systemFontOfSize:11];
        _attentionLabel.textAlignment = NSTextAlignmentCenter;
        _attentionLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 + 15);
        _attentionLabel.bounds = self.bounds;
        [self addSubview:self.attentionLabel];
    }
    return _attentionLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [TDFScrollLabel new];
        _scoreLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        _scoreLabel.bounds = self.bounds;
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = [UIColor whiteColor];
        [self addSubview:_scoreLabel];
    }
    return _scoreLabel;
}

- (void)setAttentionText:(NSString *)attentionText {
    _attentionText = attentionText;
    self.attentionLabel.text = attentionText;
}

- (void)setIsError:(BOOL)isError {
    _isError =isError;
    if (isError) {
        [self stopWaveAnimation];
        self.scoreLabel.text = NSLocalizedString(@"体检失败", nil);
        self.imageView1.image = [UIImage imageNamed:@"ico_redfull"];
        self.imageView2.image = [UIImage imageNamed:@"ico_redfull"];
        self.circleImageView.image = [UIImage imageNamed:@"ico_redcircle"];
        self.imageView1.frame = self.bounds;
        self.imageView2.frame = self.bounds;
    }else {
        self.imageView1.frame = CGRectMake(0, self.imageView1.tdf_originY, self.imageView1.image.size.width, self.imageView1.image.size.height);
        self.imageView2.frame = CGRectMake(-self.imageView2.image.size.width, self.imageView2.tdf_originY, self.imageView2.image.size.width, self.imageView2.image.size.height);
    }
}

- (void)setIsShowAttentionText:(BOOL)isShowAttentionText {
    _isShowAttentionText = isShowAttentionText;
    if (isShowAttentionText) {
        self.attentionLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 + 15);
        self.scoreLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 - 10);
    }else {
        self.scoreLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        self.attentionText = nil;
    }
}

- (void)setScore:(CGFloat)score {
    [self setScore:score withAnimation:NO duration:0];
}

- (void)setIsNoScore:(BOOL)isNoScore {
    _isNoScore = isNoScore;
    if (isNoScore) {
        [self stopWaveAnimation];
        self.scoreLabel.hidden = YES;
        self.imageView1.image = [UIImage imageNamed:@"ico_redfull"];
        self.imageView2.image = [UIImage imageNamed:@"ico_redfull"];
        self.circleImageView.image = [UIImage imageNamed:@"ico_redcircle"];
        self.heartRate.hidden = NO;
        self.imageView1.frame = self.bounds;
        self.imageView2.frame = self.bounds;
    }else {
        self.scoreLabel.hidden = NO;
        self.imageView1.frame = CGRectMake(0, self.imageView1.tdf_originY, self.imageView1.image.size.width, self.imageView1.image.size.height);
        self.imageView2.frame = CGRectMake(-self.imageView2.image.size.width, self.imageView2.tdf_originY, self.imageView2.image.size.width, self.imageView2.image.size.height);
        self.heartRate.hidden = YES;
    }
    
}

- (void)setIsShowWaveAnimation:(BOOL)isShowWaveAnimation {
    _isShowWaveAnimation = isShowWaveAnimation;
    if (!isShowWaveAnimation) {
        [self.imageView1 tdf_setY:0];
        [self.imageView2 tdf_setY:0];
        [self.bottomImageView1 tdf_setY:0];
        [self.bottomImageView2 tdf_setY:0];
        [self stopWaveAnimation];
    }
}

- (UIImageView *)heartRate {
    if (!_heartRate) {
        _heartRate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_heartrate"]];
        _heartRate.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 - 15);
    }
    return _heartRate;
}

@end
