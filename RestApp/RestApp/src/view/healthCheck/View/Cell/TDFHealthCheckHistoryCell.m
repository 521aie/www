//
//  TDFHealthCheckHistoryCell.m
//  RestApp
//
//  Created by happyo on 2017/5/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckHistoryCell.h"
#import "TDFHealthCheckHistoryItem.h"
#import "UIColor+Hex.h"

@interface TDFHealthCheckHistoryCell ()

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UIView *compareView;

@property (nonatomic, strong) UIImageView *compareIcon;

@property (nonatomic, strong) UILabel *differScoreLabel;

@property (nonatomic, strong) UIImageView *rightArrowIcon;

@end
@implementation TDFHealthCheckHistoryCell

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
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.alphaView).with.offset(15);
        make.centerY.equalTo(self.alphaView);
        make.height.equalTo(@40);
        make.width.equalTo(@110);
    }];
    
    [self addSubview:self.rightArrowIcon];
    [self.rightArrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.alphaView).with.offset(-10);
        make.centerY.equalTo(self.alphaView);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    [self addSubview:self.compareView];
    [self.compareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.alphaView).with.offset(-30);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.alphaView);
//        make.width.equalTo(@130);
    }];
    
    [self.compareView addSubview:self.compareIcon];
    [self.compareIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.compareView).with.offset(-40);
        make.centerY.equalTo(self.compareView);
        make.height.equalTo(@11);
        make.width.equalTo(@6);
    }];
    
    [self.compareView addSubview:self.differScoreLabel];
    [self.differScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.compareIcon.mas_trailing).with.offset(5);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.compareView);
    }];
    
    [self.compareView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.compareIcon.mas_leading).with.offset(-30);
        make.centerY.equalTo(self.compareView);
        make.height.equalTo(@15);
        make.width.equalTo(@30);
    }];
    
    [self.compareView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.scoreLabel.mas_leading).with.offset(-10);
        make.centerY.equalTo(self.compareView);
        make.height.equalTo(@15);
//        make.width.equalTo(@30);
    }];
    
}

- (void)configCellWithItem:(TDFHealthCheckHistoryItem *)item
{
    self.titleLabel.text = item.title;
    
    self.scoreLabel.text = item.score;
    
    [self updateCompateViewWithDifferType:item.differType differScore:item.differScore];
}

- (void)updateCompateViewWithDifferType:(TDFHealthCheckDifferType)differType differScore:(NSString *)differScore
{
    switch (differType) {
        case TDFHealthCheckDifferTypeUnchanged:
            self.compareIcon.hidden = YES;
            self.differScoreLabel.text = @"-";
            self.differScoreLabel.textColor = [UIColor blackColor];
            break;
            
        case TDFHealthCheckDifferTypeUp:
            self.compareIcon.hidden = NO;
            self.compareIcon.image = [UIImage imageNamed:@"health_score_up_icon"];
            self.differScoreLabel.text = differScore;
            self.differScoreLabel.textColor = [UIColor colorWithHeX:0xCC0000];
            break;
            
        case TDFHealthCheckDifferTypeDown:
            self.compareIcon.hidden = NO;
            self.compareIcon.image = [UIImage imageNamed:@"health_score_down_icon"];
            self.differScoreLabel.text = differScore;
            self.differScoreLabel.textColor = [UIColor colorWithHeX:0x07AD1F];
            break;
            
        default:
            break;
    }
}

+ (CGFloat)heightForCellWithItem:(TDFHealthCheckHistoryItem *)item
{
    return 65;
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.textColor = [UIColor colorWithHeX:0x333333];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.text = @"得分";
    }
    
    return _descLabel;
}


- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scoreLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _scoreLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _scoreLabel;
}

- (UIImageView *)compareIcon
{
    if (!_compareIcon) {
        _compareIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _compareIcon;
}

- (UIView *)compareView
{
    if (!_compareView) {
        _compareView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _compareView;
}

- (UILabel *)differScoreLabel
{
    if (!_differScoreLabel) {
        _differScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _differScoreLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _differScoreLabel;
}

- (UIImageView *)rightArrowIcon
{
    if (!_rightArrowIcon) {
        _rightArrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightArrowIcon.image = [UIImage imageNamed:@"ico_arrow_right_gray"];
    }
    
    return _rightArrowIcon;
}

@end
