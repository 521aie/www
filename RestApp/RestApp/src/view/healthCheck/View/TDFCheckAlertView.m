//
//  TDFCheckAlertView.m
//  RestApp
//
//  Created by 黄河 on 2016/12/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCheckAlertView.h"
#import "Masonry.h"
@interface TDFCheckAlertView ()

@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIImageView *attentionImageView;

@property (nonatomic, strong)UILabel *textLabel;

@property (nonatomic, strong)UIButton *closeButton;

@end

@implementation TDFCheckAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    self.backImageView.image = [UIImage imageNamed:@"ico_checkattention"];
//    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.backImageView];
    
    self.attentionImageView.image = [UIImage imageNamed:@"ico_checkPeople"];
    [self addSubview:self.attentionImageView];
    
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:20];
    self.textLabel.textColor = [UIColor redColor];
    
    [self addSubview:self.textLabel];
    
    [self.closeButton setImage:[UIImage imageNamed:@"ico_red_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self addConstraints];
}

- (void)closeButtonClick:(UIButton *)button {
    if (self.closeClick) {
        self.closeClick();
    }else {
        [self removeFromSuperview];
    }
}

- (void)addConstraints {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(21);
        make.right.equalTo(self).offset(-21);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self);
    }];
    [self.attentionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.backImageView);
        make.centerY.equalTo(self).offset(-8);
        make.left.equalTo(self.backImageView).offset(13);
        make.width.lessThanOrEqualTo(@(self.attentionImageView.image.size.width));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionImageView.mas_right).offset(15);
        make.centerY.equalTo(self.attentionImageView);
        make.right.equalTo(self.backImageView).offset(-9);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView.mas_right);
        make.centerY.equalTo(self.backImageView.mas_top);
    }];
    
    
}

#pragma mark --setter && getter

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
    }
    return _backImageView;
}

- (UIImageView *)attentionImageView {
    if (!_attentionImageView) {
        _attentionImageView = [UIImageView new];
    }
    return _attentionImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _closeButton;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.textLabel.text = titleStr;
}

@end
