//
//  TDFOAFanCommentItemView.m
//  TDFDNSPod
//
//  Created by Octree on 17/3/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "TDFOAFanCommentItemView.h"
#import <Masonry/Masonry.h>

@interface TDFOAFanCommentItemView ()

@property (strong, nonatomic, readwrite) UIView *colorView;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UILabel *detailLabel;
@property (strong, nonatomic, readwrite) UILabel *ratioLabel;

@end

@implementation TDFOAFanCommentItemView

#pragma mark - Life Cyle

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
    }
    
    return self;
}

#pragma mark - Method


- (void)configViews {

    [self addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorView.mas_right).with.offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(13);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
    }];
    
    [self addSubview:self.ratioLabel];
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self);
        make.width.equalTo(@70);
    }];
}

#pragma mark - Accessor

- (UIView *)colorView {
    
    if (!_colorView) {
        
        _colorView = [[UIView alloc] init];
        _colorView.layer.masksToBounds = YES;
        _colorView.layer.cornerRadius = 2;
    }
    return _colorView;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.textColor = [UIColor whiteColor];
    }
    return _detailLabel;
}
- (UILabel *)ratioLabel {
    
    if (!_ratioLabel) {
        
        _ratioLabel = [[UILabel alloc] init];
        _ratioLabel.font = [UIFont systemFontOfSize:11];
        _ratioLabel.textColor = [UIColor whiteColor];
    }
    return _ratioLabel;
}

@end
