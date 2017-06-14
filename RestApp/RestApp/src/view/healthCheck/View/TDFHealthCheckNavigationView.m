//
//  TDFHealthCheckNavigationView.m
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckNavigationView.h"

@interface TDFHealthCheckNavigationView ()

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIImageView *backIcon;

@property (nonatomic, strong) UILabel *backLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *spliteView;

@end
@implementation TDFHealthCheckNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        [self addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(11);
            make.bottom.equalTo(self).with.offset(-15);
            make.height.equalTo(@17);
            make.width.equalTo(@50);
        }];
        
        [self.backButton addSubview:self.backIcon];
        [self.backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backButton);
            make.centerY.equalTo(self.backButton);
            make.width.equalTo(@9);
            make.height.equalTo(@17);
        }];
        
        [self.backButton addSubview:self.backLabel];
        [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backIcon.mas_trailing).with.offset(2);
            make.centerY.equalTo(self.backButton);
            make.height.equalTo(@13);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.backLabel);
            make.height.equalTo(@20);
        }];
        
        [self addSubview:self.spliteView];
        [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    
    return self;
}

- (void)updateTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)backButtonClicked
{
    if (self.backBlock) {
        self.backBlock();
    }
}

#pragma mark -- Getters && Setters --

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (UIImageView *)backIcon
{
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backIcon.image = [UIImage imageNamed:@"health_navigation_back_icon"];
    }
    
    return _backIcon;
}

- (UILabel *)backLabel
{
    if (!_backLabel) {
        _backLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _backLabel.font = [UIFont systemFontOfSize:13];
        _backLabel.textColor = [UIColor whiteColor];
        _backLabel.text = @"返回";
    }
    
    return _backLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
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
