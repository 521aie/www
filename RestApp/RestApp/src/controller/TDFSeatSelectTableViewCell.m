//
//  TDFSeatSelectTableViewCell.m
//  RestApp
//
//  Created by Octree on 8/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSeatSelectTableViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>


@implementation TDFSeatSelectTableViewCell

@synthesize iconImageView       = _iconImageView,
titleLabel          = _titleLabel,
detailLabel         = _detailLabel,
selectImageView     = _selectImageView,
iconContainerView   = _iconContainerView,
typeLabel           = _typeLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configViews];
    }
    
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectImageView.image = [UIImage imageNamed:selected ? @"icon_select_filled" : @"icon_select_empty"];
}


#pragma mark - Method

- (void)configViews {
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:self.iconContainerView];
    [self addSubview:self.selectImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    
    [self.iconContainerView addSubview:self.iconImageView];
    [self.iconContainerView addSubview:self.typeLabel];
    
    @weakify(self);
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    [self.iconContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.left.equalTo(self.selectImageView.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(9);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(84);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.equalTo(self.iconContainerView.mas_top).with.offset(2);
        make.centerX.equalTo(self.iconContainerView.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.bottom.equalTo(self.iconContainerView.mas_bottom).with.offset(-5);
        make.left.equalTo(self.iconContainerView.mas_left).with.offset(5);
        make.right.equalTo(self.iconContainerView.mas_right).with.offset(-5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.leading.equalTo(self.iconContainerView.mas_trailing).with.offset(20);
        make.top.equalTo(self.mas_top).with.offset(25);
        make.width.mas_equalTo(150);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.width.mas_equalTo(150);
    }];
}

#pragma mark - Accessor

- (UIImageView *)selectImageView {

    if (!_iconImageView) {
        
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectImageView.image = [UIImage imageNamed:@"icon_select_empty"];
    }
    
    return _selectImageView;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    
    return _detailLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.image = [UIImage imageNamed:@"img_table_guests"];
    }
    
    return _iconImageView;
}

- (UIView *)iconContainerView {
    
    if (!_iconContainerView) {
        
        _iconContainerView = [[UIView alloc] init];
        _iconContainerView.backgroundColor = [UIColor clearColor];
        _iconContainerView.opaque = NO;
        _iconContainerView.layer.masksToBounds = YES;
        _iconContainerView.layer.cornerRadius = 6;
        _iconContainerView.layer.borderColor = [UIColor colorWithHeX:0xAFADA7].CGColor;
        _iconContainerView.layer.borderWidth = 1;
    }
    
    return _iconContainerView;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textColor = [UIColor colorWithHeX:0x333333];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _typeLabel;
}


@end
