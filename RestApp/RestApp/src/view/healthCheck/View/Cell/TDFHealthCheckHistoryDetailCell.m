//
//  TDFHealthCheckHistoryDetailCell.m
//  RestApp
//
//  Created by happyo on 2017/5/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryDetailCell.h"
#import "TDFHealthCheckHistoryDetailItem.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"

@interface TDFHealthCheckHistoryDetailCell ()

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIView *titleBackView;

@property (nonatomic, strong) UIImageView *titleIcon;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UIImageView *statusIcon;

@property (nonatomic, strong) UILabel *statusLabel;

@end
@implementation TDFHealthCheckHistoryDetailCell

#pragma mark -- DHTTableViewCellDelegate --

- (void)cellDidLoad
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.alphaView];
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-1);
    }];
    
    [self addSubview:self.titleBackView];
    [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.alphaView).with.offset(15);
        make.centerY.equalTo(self.alphaView);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    
    [self addSubview:self.titleIcon];
    [self.titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleBackView);
        make.centerY.equalTo(self.titleBackView);
        make.width.equalTo(@21);
        make.height.equalTo(@21);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleBackView.mas_trailing).with.offset(10);
        make.centerY.equalTo(self.titleBackView);
        make.height.equalTo(@15);
        make.trailing.equalTo(self.alphaView.mas_centerX);
    }];
    
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.alphaView.mas_centerX);
        make.centerY.equalTo(self.alphaView);
        make.height.equalTo(@15);
    }];
    
    [self addSubview:self.statusIcon];
    [self.statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.alphaView).with.offset(-80);
        make.centerY.equalTo(self.alphaView);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    [self addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.statusIcon.mas_trailing).with.offset(5);
        make.centerY.equalTo(self.alphaView);
        make.height.equalTo(@13);
    }];
}

- (void)configCellWithItem:(TDFHealthCheckHistoryDetailItem *)item
{
    [self.titleIcon sd_setImageWithURL:[NSURL URLWithString:item.iconUrl]];
    
    self.titleLabel.text = item.title;
    
    self.valueLabel.text = item.value;
    
    self.statusLabel.text = item.levelDesc;
    
    [self updateLevelStatusWithLevelType:item.levelType];
}

- (void)updateLevelStatusWithLevelType:(TDFHealthCheckLevelType)levelType
{
    UIColor *levelColor = [UIColor whiteColor];
    UIImage *levelImage = [UIImage imageNamed:@""];
    
    switch (levelType) {
        case TDFHealthCheckLevelTypeNormal:
            levelColor = [UIColor colorWithHeX:0x07AD1F];
            levelImage = [UIImage imageNamed:@"health_level_normal_icon"];
            break;
        
        case TDFHealthCheckLevelTypeToBeImproved:
            levelColor = [UIColor colorWithHeX:0xFF8800];
            levelImage = [UIImage imageNamed:@"health_level_tobeImproved_icon"];
            break;
            
        case TDFHealthCheckLevelTypeNeedOptimize:
            levelColor = [UIColor colorWithHeX:0xCC0000];
            levelImage = [UIImage imageNamed:@"health_level_needOptimize_icon"];
            break;
            
        default:
            break;
    }
    
    self.valueLabel.textColor = levelColor;
    self.statusIcon.image = levelImage;
    self.titleBackView.backgroundColor = levelColor;
    self.statusLabel.textColor = levelColor;
}

+ (CGFloat)heightForCellWithItem:(TDFHealthCheckHistoryDetailItem *)item
{
    return 67;
}

#pragma mark -- Getters && Setters --

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectZero];
        _alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    
    return _alphaView;
}

- (UIImageView *)titleIcon
{
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _titleIcon.layer.cornerRadius = 10.5;
    }
    
    return _titleIcon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _titleLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _valueLabel;
}

- (UIView *)titleBackView
{
    if (!_titleBackView) {
        _titleBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleBackView.layer.cornerRadius = 18;
    }
    
    return _titleBackView;
}

- (UIImageView *)statusIcon
{
    if (!_statusIcon) {
        _statusIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _statusIcon;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return _statusLabel;
}

@end
