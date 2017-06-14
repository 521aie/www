//
//  TDFBrandKindPayCell.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBrandKindPayCell.h"

@implementation TDFBrandKindPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *view =[[UIView alloc] init];
        view.backgroundColor =[UIColor whiteColor];
        view.alpha =0.6;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).with.offset(1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_next"];
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.mas_offset(22);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(self.mas_top).with.offset(14);
        }];
        
        [self addSubview:self.isChainImg];
        [self.isChainImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
             make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(31, 15));
        }];
        self.isChainImg.hidden = YES;
        
        [self addSubview:self.subtitleLabel];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-14);
        }];
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(icon.mas_left);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:11];
        _subtitleLabel.textColor = [UIColor colorWithRed:7/255.0 green:173/255.0 blue:31/255.0 alpha:1];
    }
    return _subtitleLabel;
}

- (UILabel *)rightLabel {
    if(!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:11];
        _rightLabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
    }
    return _rightLabel;
}

- (UIImageView *) isChainImg
{
    if (!_isChainImg) {
        _isChainImg = [[UIImageView alloc] init];
        _isChainImg.image = [UIImage imageNamed:@"ico_chain"];
    }
    return _isChainImg;
}

@end
