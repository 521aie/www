//
//  TDFHomeCollectionReusableView.m
//  RestApp
//
//  Created by 黄河 on 16/9/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHomeCollectionReusableView.h"
#import "Masonry.h"
@implementation TDFHomeCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        self.line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        [self addSubview:self.line];
        [self layoutView];
    }
    return self;
}

- (void)layoutView{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark --init
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
    }
    return _line;
}

@end
