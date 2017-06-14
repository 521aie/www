//
//  TDFLayoutGroupListView.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/12/13.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFLayoutGroupListView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
@interface TDFLayoutGroupListView ()
{
    CGFloat _space;
}
@end

@implementation TDFLayoutGroupListView

+ (instancetype)listViewWithSpacing:(CGFloat)space {
    return [[self alloc] initWithSpacing:space];
}


- (instancetype)initWithSpacing:(CGFloat)space {
    self = [super init];
    if (self) {
        _space = space;
        [self defaultConfigTypeLabel];
    }
    return self;
}


- (void)defaultConfigTypeLabel {
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    self.detailLabel.font = [UIFont systemFontOfSize:11];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(_space);
    }];
//    self.isShowDetail = NO;
}


#pragma mark -- setter && getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

- (void)setIsShowDetail:(BOOL)isShowDetail {
    _isShowDetail = isShowDetail;
    if (!isShowDetail) {
        self.detailLabel.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(_space);
        }];
    }else {
        self.detailLabel.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(_space);
            make.bottom.equalTo(self);
        }];
    }
}

@end
