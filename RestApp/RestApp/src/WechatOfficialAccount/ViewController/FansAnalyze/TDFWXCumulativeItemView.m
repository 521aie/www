//
//  TDFWXCumulativeItemView.m
//  RestApp
//
//  Created by tripleCC on 2017/5/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <TDFCategories/TDFCategories.h>
#import "TDFWXCumulativeItemView.h"

@interface TDFWXCumulativeItemView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UIButton *linkButton;
@end

@implementation TDFWXCumulativeItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.linkButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.centerX.equalTo(self);
            make.width.lessThanOrEqualTo(self);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.lessThanOrEqualTo(self);
        }];
        [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.width.lessThanOrEqualTo(self);
            make.height.equalTo(@11);
            make.centerX.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setCountString:(NSString *)countString {
    _countString = countString;
    self.countLabel.text = countString;
}

- (void)setLinkString:(NSString *)linkString {
    _linkString = linkString;
    [self.linkButton setTitle:linkString forState:UIControlStateNormal];
}

- (void)addTarget:(id)target linkAction:(SEL)action {
    [self.linkButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_linkButton setTitleColor:[UIColor tdf_colorWithRGB:0x0088cc] forState:UIControlStateNormal];
        _linkButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    
    return _linkButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont boldSystemFontOfSize:15];
        _countLabel.textColor = [UIColor whiteColor];
    }
    
    return _countLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

@end
