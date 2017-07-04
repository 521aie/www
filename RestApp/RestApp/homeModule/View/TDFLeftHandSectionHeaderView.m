//
//  TDFLeftHandSectionHeaderView.m
//  RestApp
//
//  Created by happyo on 2017/6/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLeftHandSectionHeaderView.h"
#import "NSString+TDF_Empty.h"

@interface TDFLeftHandSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) UIView *spliteLine;

@property (nonatomic, strong) UIImageView *rightArrowIcon;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSString *clickUrl;

@end
@implementation TDFLeftHandSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(20);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.height.equalTo(@14);
        }];
        
        [self addSubview:self.spliteLine];
        
        [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(20);
            make.trailing.equalTo(self.mas_trailing).offset(-20);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@1);
        }];
        
        [self addSubview:self.rightArrowIcon];
        [self.rightArrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing).offset(-10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.height.equalTo(@11);
            make.width.equalTo(@11);
        }];
        
        [self addSubview:self.moreLabel];
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rightArrowIcon);
            make.trailing.equalTo(self.rightArrowIcon.mas_leading);
            make.height.equalTo(@11);
        }];
        
        [self addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.moreLabel);
            make.top.equalTo(self.moreLabel);
            make.bottom.equalTo(self.moreLabel);
            make.trailing.equalTo(self.rightArrowIcon);
        }];
    }
    
    return self;
}

- (void)configureViewWithTitle:(NSString *)title more:(NSString *)more clickUrl:(NSString *)clickUrl
{
    self.titleLabel.text = title;
    
    if ([more isNotEmpty]) {
        self.moreLabel.text = more;
        self.clickUrl = clickUrl;
        
        self.moreLabel.hidden = NO;
        self.rightArrowIcon.hidden = NO;
    } else {
        self.moreLabel.hidden = YES;
        self.rightArrowIcon.hidden = YES;
    }
}

#pragma mark -- Action --

- (void)rightButtonClicked
{
    if (self.clickedBlock) {
        self.clickedBlock(self.clickUrl);
    }
}

#pragma mark -- Getters && Setters --

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _moreLabel.font = [UIFont systemFontOfSize:11];
        _moreLabel.textColor = [UIColor whiteColor];
        
    }
    
    return _moreLabel;
}

- (UIImageView *)rightArrowIcon
{
    if (!_rightArrowIcon) {
        _rightArrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightArrowIcon.image = [UIImage imageNamed:@"homePage_arrow_right"];
    }
    
    return _rightArrowIcon;
}

- (UIView *)spliteLine
{
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _spliteLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    
    return _spliteLine;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}

@end
