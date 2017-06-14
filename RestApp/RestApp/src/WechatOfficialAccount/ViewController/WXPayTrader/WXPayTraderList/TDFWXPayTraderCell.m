//
//  TDFWXPayTraderCell.m
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXPayTraderCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"


@interface TDFWXPayTraderCell ()

@property (strong, nonatomic, readwrite) UILabel *nameLabel;
@property (strong, nonatomic, readwrite) UILabel *badgeLabel;
@property (strong, nonatomic, readwrite) UIButton *detailButton;

@end

@implementation TDFWXPayTraderCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configViews];
    }
    
    return self;
}

#pragma mark - Method

- (void)configViews {

    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self);
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self).with.offset(10);
        make.centerY.equalTo(self);
        make.width.mas_lessThanOrEqualTo(130);
    }];
    
    [self addSubview:self.badgeLabel];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(5);
        make.top.equalTo(self.nameLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(16);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_disclosure_indicator"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    [self addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.right.equalTo(imageView.mas_left).with.offset(-8);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
}

- (void)buttonTapped {

    !self.buttonBlock ?: self.buttonBlock();
}



#pragma mark - Accessor

- (UILabel *)nameLabel {

    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    return _nameLabel;
}

- (UILabel *)badgeLabel {

    if (!_badgeLabel) {
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:11];
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 3;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor colorWithHeX:0x07AD00];
    }
    
    return _badgeLabel;
}

- (UIButton *)detailButton {

    if (!_detailButton) {
        
        _detailButton = [[UIButton alloc] init];
        [_detailButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_detailButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _detailButton;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.badgeLabel.backgroundColor = [UIColor colorWithHeX:0x07AD00];
}

@end
