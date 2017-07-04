//
//  TDFHomeBossCenterView.m
//  RestApp
//
//  Created by happyo on 2017/6/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHomeBossCenterView.h"
#import "SXHeadLine.h"
#import "UIImageView+WebCache.h"

@implementation TDFHomeBossCenterModel

@end

@interface TDFHomeBossCenterView ()

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImageView *notReadImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *caseImageView;

@property (nonatomic, strong) SXHeadLine *headLine;

@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, strong) TDFHomeBossCenterModel *model;

@end
@implementation TDFHomeBossCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.alphaView];
        [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.leading.equalTo(self).with.offset(10);
            make.trailing.equalTo(self).with.offset(-10);
            make.bottom.equalTo(self);
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alphaView).with.offset(10);
            make.centerY.equalTo(self.alphaView);
            make.height.equalTo(@64);
            make.width.equalTo(@64);
        }];
        
        [self addSubview:self.notReadImageView];
        [self.notReadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconImageView.mas_trailing).with.offset(-12);
            make.centerY.equalTo(self.iconImageView.mas_top).with.offset(12);
            make.width.equalTo(@7);
            make.height.equalTo(@7);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(5);
            make.top.equalTo(self.alphaView).with.offset(27);
            make.height.equalTo(@13);
            make.trailing.equalTo(self).with.offset(-5);
        }];
        
        [self addSubview:self.caseImageView];
        [self.caseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(5);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(11);
            make.height.equalTo(@9);
            make.width.equalTo(@25);
        }];
        
        [self addSubview:self.headLine];
        [self.headLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.caseImageView.mas_trailing).with.offset(5);
            make.centerY.equalTo(self.caseImageView);
            make.height.equalTo(@11);
            make.trailing.equalTo(self.alphaView).with.offset(-5);
        }];
        
        [self addSubview:self.clickButton];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.alphaView);
        }];
    }
    
    return self;
}

- (void)configureViewWithModel:(TDFHomeBossCenterModel *)model
{
    self.model = model;
    
    self.titleLabel.text = model.title;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImage]];
    
    self.notReadImageView.hidden = !model.hasUnReadCase;
    
    [self.caseImageView sd_setImageWithURL:[NSURL URLWithString:model.caseImage]];
    
    self.headLine.messageArray = model.marketingCaseList;
    
    [self.headLine start];
}

+ (CGFloat)heightForView
{
    return 98;
}

#pragma mark -- Actions --

- (void)buttonClicked
{
    self.notReadImageView.hidden = YES;
    if (self.clickBlock) {
        self.clickBlock(self.model.clickUrl);
    }
}

#pragma mark -- Getters && Setters --

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.layer.cornerRadius = 5;
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    
    return _alphaView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _iconImageView;
}

- (UIImageView *)notReadImageView
{
    if (!_notReadImageView) {
        _notReadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _notReadImageView.image = [UIImage imageNamed:@"notiNumIconOne.png"];
    }
    
    return _notReadImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UIImageView *)caseImageView
{
    if (!_caseImageView) {
        _caseImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _caseImageView;
}

- (UIButton *)clickButton
{
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_clickButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _clickButton;
}

- (SXHeadLine *)headLine
{
    if (!_headLine) {
        _headLine = [[SXHeadLine alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 135, 11)];
        [_headLine setBgColor:[UIColor clearColor] textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] textFont:[UIFont systemFontOfSize:11]];
        [_headLine setScrollDuration:1.0 stayDuration:3.0];
        _headLine.hasGradient = YES;
    }
    
    return _headLine;
}



@end
