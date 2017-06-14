//
//  TDFLayoutGroupListWithImageView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/13.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFLayoutGroupListWithImageView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
@interface TDFLayoutGroupListWithImageView ()
{
    CGFloat _space;
}

@end

@implementation TDFLayoutGroupListWithImageView

+ (instancetype)listViewWithSpacing:(CGFloat)space {
    return [[self alloc] initWithSpacing:space];
}


- (instancetype)initWithSpacing:(CGFloat)space {
    self = [super init];
    if (self) {
        _space = space;
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.infoLabel];
    
    [self addSubview:self.infoImageView];
    [self addSubview:self.detailImageView];
    
    self.detailLabel.font = [UIFont systemFontOfSize:11];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:self.detailLabel];
    
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self.infoImageView.mas_height);
        make.centerY.equalTo(self.infoLabel);
        make.right.equalTo(self).offset(-73);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.infoImageView.mas_right).offset(7);
    }];
    
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
        make.right.equalTo(self);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(_space);
        make.right.equalTo(self.detailImageView.mas_left);
    }];
    
    
}

#pragma mark -- setter&&getter
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
    }
    return _infoLabel;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [UIImageView new];
    }
    return _infoImageView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

- (UIImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = [UIImageView new];
    }
    return _detailImageView;
}

- (void)setIsShowDetail:(BOOL)isShowDetail {
    _isShowDetail = isShowDetail;
    if (isShowDetail) {
        self.detailLabel.hidden = NO;
        self.detailImageView.hidden = NO;
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.infoImageView.mas_right).offset(7);
        }];
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoLabel.mas_bottom).offset(_space);
            make.right.equalTo(self.detailImageView.mas_left);
            make.bottom.equalTo(self);
        }];
    }else {
        self.detailLabel.hidden = YES;
        self.detailImageView.hidden = YES;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoLabel.mas_bottom).offset(_space);
            make.right.equalTo(self.detailImageView.mas_left);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.infoImageView.mas_right).offset(7);
            make.bottom.equalTo(self);
        }];
    }
}

@end
