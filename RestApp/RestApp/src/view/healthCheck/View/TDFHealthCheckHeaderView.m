//
//  TDFHealthCheckHeaderView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/7.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFHealthCheckHeaderView.h"
#import "TDFWaveAnimationView.h"
#import "TDFProgressView.h"
#import "UIColor+Hex.h"
#import "UIView+TDFUIKit.h"
#import "Masonry.h"

@interface TDFCheckOverBottomView ()
@property (nonatomic, strong)UIButton *checkSettingButton;
@end

@implementation TDFCheckOverBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    [self.checkSettingButton setImage:[UIImage imageNamed:@"ico_checksetting"] forState:UIControlStateNormal];
    self.checkSettingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.checkSettingButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3.5, 0, 3.5)];
    [self.checkSettingButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3.5, 0, -3.5)];
    [self.checkSettingButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkSettingButton setTitle:NSLocalizedString(@"体检设置", nil) forState:UIControlStateNormal];
    self.checkSettingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.checkSettingButton];
    [self addSubview:self.resultLabel];
    
    self.resultLabel.font = [UIFont systemFontOfSize:15];
    self.resultLabel.textColor = [UIColor whiteColor];
    self.resultLabel.numberOfLines = 2;
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.checkSettingButton.mas_right).offset(20);
        make.left.equalTo(self.mas_left).offset(20+99+15);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.checkSettingButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.checkSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.resultLabel.mas_centerY);
    }];
}

#pragma mark --buttonClick
- (void)buttonClick:(UIButton *)button {
    if (self.buttonClick) {
        self.buttonClick();
    }
}


#pragma mark -- setter && getter

- (UIButton *)checkSettingButton {
    if (!_checkSettingButton) {
        _checkSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _checkSettingButton;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [UILabel new];
    }
    return _resultLabel;
}

@end





@interface TDFHealthCheckHeaderView()

@property (nonatomic, strong)UILabel *textLabel;

@property (nonatomic, strong)UIButton *closeButton;

@property (nonatomic, assign)BOOL isShowProgress;

@property (nonatomic, strong) UILabel *summarizeLabel;

@property (nonatomic, strong) UILabel *compareLabel;

@property (nonatomic, strong) UIButton *healthSettingButton;

@property (nonatomic, strong) UIImageView *healthSettingIcon;

@property (nonatomic, strong) UILabel *healthSettingLabel;

@property (nonatomic, strong) UIButton *historyButton;

@property (nonatomic, strong) UIImageView *historyIcon;

@property (nonatomic, strong) UILabel *historyLabel;

@property (nonatomic, strong) UIView *spliteView;

@end

@implementation TDFHealthCheckHeaderView

- (instancetype)initWithDefaultScore:(NSInteger)score {
    self = [super init];
    if (self) {
        self.totalScore = score;
        [self defultConfig];
    }
    return self;
}

- (void)congfigureSummarize:(NSAttributedString *)summarize compare:(NSAttributedString *)compare
{
    self.summarizeLabel.attributedText = summarize;
    self.compareLabel.attributedText = compare;
}

- (void)defultConfig {
    self.backgroundColor = [UIColor clearColor];
    [self.closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"health_close_top_icon"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    self.textLabel.text = NSLocalizedString(@"正在进行体检...", nil);
    [self addSubview:self.waveAnimation];
    self.waveAnimation.score = self.totalScore;
    self.waveAnimation.colorRules = self.colorRules;
    [self.waveAnimation updateImageViewAndFrameWithScore:self.totalScore];
    self.waveAnimation.isShowWaveAnimation = NO;
    [self addSubview:self.textLabel];
    
    self.progressView.backgroundColor = [UIColor lightGrayColor];
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#47D801"];
    [self addSubview:self.progressView];
    
    [self addSubview:self.summarizeLabel];
    [self addSubview:self.compareLabel];
    
    [self addSubview:self.healthSettingButton];
    [self.healthSettingButton addSubview:self.healthSettingIcon];
    [self.healthSettingButton addSubview:self.healthSettingLabel];
    
    [self addSubview:self.historyButton];
    [self.historyButton addSubview:self.historyIcon];
    [self.historyButton addSubview:self.historyLabel];
    
    [self addSubview:self.spliteView];

    [self addConstraint];
    self.isShowProgress = YES;
}

- (void)addConstraint {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(40);
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waveAnimation.mas_right).offset(25);
        make.right.equalTo(self).offset(-46);
        make.top.equalTo(self).offset(49);
        make.height.greaterThanOrEqualTo(@18);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waveAnimation.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(10);
    }];
    
    [self.summarizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@13);
    }];
    
    [self.compareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.textLabel);
        make.top.equalTo(self.summarizeLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(self).with.offset(-55);
    }];
    
    [self.healthSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(30);
        make.bottom.equalTo(self).with.offset(-10);
        make.height.equalTo(@18);
        make.width.equalTo(@90);
    }];
    
    [self.healthSettingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.healthSettingButton);
        make.centerY.equalTo(self.healthSettingButton);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.healthSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.healthSettingIcon.mas_trailing).with.offset(5);
        make.centerY.equalTo(self.healthSettingButton);
        make.height.equalTo(@13);
        make.trailing.equalTo(self.healthSettingButton);
    }];
    
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(-30);
        make.bottom.equalTo(self).with.offset(-10);
        make.height.equalTo(@18);
        make.width.equalTo(@80);
    }];
    
    [self.historyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.historyButton);
        make.centerY.equalTo(self.historyButton);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.historyIcon.mas_trailing).with.offset(5);
        make.centerY.equalTo(self.historyButton);
        make.height.equalTo(@13);
        make.trailing.equalTo(self.historyButton);
    }];
    
    [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)reset {
    self.waveAnimation.score = self.totalScore;
    self.waveAnimation.colorRules = self.colorRules;
    [self.waveAnimation updateImageViewAndFrameWithScore:self.totalScore];
    [self.waveAnimation startCircleAnimation];
    self.isShowProgress = YES;
}

- (void)stopAnimation {
    [self.waveAnimation stopCircleAnimation];
}

- (void)startAnimationWithStartTime:(CGFloat)startTime {
    [UIView animateWithDuration:startTime animations:^{
        [self.progressView setProgress:0.3 animated:YES];
    }];
}

- (void)setAllTime:(CGFloat)allTime {
    _allTime = allTime;
    [UIView animateWithDuration:allTime animations:^{
        [self.progressView setProgress:1 animated:YES];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressView.layer.cornerRadius = self.progressView.tdf_height/2.0;
    self.progressView.clipsToBounds = YES;
}

#pragma mark -- Private Methods --

- (void)updateBottomView:(BOOL)hidden
{
    self.healthSettingButton.hidden = hidden;
    self.summarizeLabel.hidden = hidden;
    self.compareLabel.hidden = hidden;
    self.historyButton.hidden = hidden;
}

#pragma mark -- Actions --

- (void)healthSettingButtonClicked
{
    if (self.checkSettingClick) {
        self.checkSettingClick();
    }
}

- (void)historyButtonClicked
{
    if (self.healthHistoryClick) {
        self.healthHistoryClick();
    }
}

#pragma mark --ButtonClick
- (void)buttonClick:(UIButton *)button {
    if (self.buttonClick) {
        self.buttonClick();
    }
}

#pragma mark -- setter && getter

- (TDFWaveAnimationView *)waveAnimation {
    if (!_waveAnimation) {
        _waveAnimation = [[TDFWaveAnimationView alloc] initWithCenter:CGPointMake(25 + 80/2.0, 40 + 80/2.0) andRadius:80/2.0];
        _waveAnimation.colorRules = self.colorRules;
    }
    return _waveAnimation;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _closeButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor colorWithHeX:0xCC0000];
    }
    
    return _textLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    }
    return _progressView;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}

- (void)setIsShowProgress:(BOOL)isShowProgress {
    _isShowProgress = isShowProgress;
    if (isShowProgress) {
        [self updateBottomView:YES];
        self.progressView.hidden = NO;
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.waveAnimation.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(self).offset(-20);
        }];
    }else {
        self.progressView.hidden = YES;
        [self updateBottomView:NO];
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.waveAnimation.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(10);
        }];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIsAnimationOver:(BOOL)isAnimationOver {
    _isAnimationOver = isAnimationOver;
    if (isAnimationOver) {
        self.isShowProgress = NO;
        self.progressView.progress = 0;
    }else {
        self.isShowProgress = YES;
    }
}
- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimation duration:(CGFloat)duration
{
    [self.waveAnimation setScore:score withAnimation:isAnimation duration:duration];
    self.waveAnimation.colorRules = self.colorRules;
    [self.waveAnimation updateImageViewAndFrameWithScore:score];
}

- (UILabel *)summarizeLabel
{
    if (!_summarizeLabel) {
        _summarizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _summarizeLabel.font = [UIFont systemFontOfSize:13];
        _summarizeLabel.textColor = [UIColor whiteColor];
//        _summarizeLabel.numberOfLines = 0;
        _summarizeLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _summarizeLabel;
}

- (UILabel *)compareLabel
{
    if (!_compareLabel) {
        _compareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _compareLabel.font = [UIFont systemFontOfSize:13];
        _compareLabel.numberOfLines = 0;
        _compareLabel.textColor = [UIColor whiteColor];
    }
    
    return _compareLabel;
}

- (UIButton *)healthSettingButton
{
    if (!_healthSettingButton) {
        _healthSettingButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_healthSettingButton addTarget:self action:@selector(healthSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _healthSettingButton;
}

- (UILabel *)healthSettingLabel
{
    if (!_healthSettingLabel) {
        _healthSettingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _healthSettingLabel.textColor = [UIColor whiteColor];
        _healthSettingLabel.font = [UIFont systemFontOfSize:13];
        _healthSettingLabel.text = @"体检设置";
    }
    
    return _healthSettingLabel;
}

- (UIImageView *)healthSettingIcon
{
    if (!_healthSettingIcon) {
        _healthSettingIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _healthSettingIcon.image = [UIImage imageNamed:@"health_setting_icon"];
    }
    
    return _healthSettingIcon;
}

- (UIButton *)historyButton
{
    if (!_historyButton) {
        _historyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_historyButton addTarget:self action:@selector(historyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _historyButton;
}

- (UILabel *)historyLabel
{
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _historyLabel.textColor = [UIColor whiteColor];
        _historyLabel.font = [UIFont systemFontOfSize:13];
        _historyLabel.text = @"历史报告";
    }
    
    return _historyLabel;
}

- (UIImageView *)historyIcon
{
    if (!_historyIcon) {
        _historyIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _historyIcon.image = [UIImage imageNamed:@"health_history_icon"];
    }
    
    return _historyIcon;
}

- (UIView *)spliteView
{
    if (!_spliteView) {
        _spliteView = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _spliteView;
}


@end
