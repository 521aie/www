//
//  TDFHeadNameItemView.m
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHeadNameItemView.h"
#import "Masonry.h"

@interface TDFHeadNameItemView()
@property (nonatomic, strong)UIView *backView;
@end
@implementation TDFHeadNameItemView
#pragma mark --init
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView{
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.backView];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@21);
        make.left.equalTo(self.titleLabel.mas_left).offset(-15);
        make.right.equalTo(self.titleLabel.mas_right).offset(15);
    }];
    self.backView.layer.cornerRadius = 21/2.0;
}


@end
