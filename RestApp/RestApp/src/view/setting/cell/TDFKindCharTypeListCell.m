//
//  TDFKindCharTypeListCell.m
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindCharTypeListCell.h"
#import "UIColor+Hex.h"

@implementation TDFKindCharTypeListCell

#pragma mark - ConfigView 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [self configView];
    }
    return self;
}

- (void)configView {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.imageIcon];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@1);
    }];
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-8);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.lineView.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(8);
        make.right.equalTo(self.imageIcon.mas_left).offset(8);
    }];
}

#pragma mark - Accessor 

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    return _lineView;
}

- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc] init ];
        _imageIcon.image = [UIImage imageNamed:@"ico_next.png"];
    }
    return _imageIcon;
}

@end
