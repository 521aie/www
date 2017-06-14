//
//  TDFWXMarketingMenuCell.m
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXMarketingMenuCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface TDFWXMarketingMenuCell ()

@end

@implementation TDFWXMarketingMenuCell


@synthesize iconImageView       =       _iconImageView,
            titleLabel          =       _titleLabel,
            detailLabel         =       _detailLabel,
            badgeLabel          =       _badgeLabel,
            indicatorImageView  =       _indicatorImageView;

#pragma mark - Life Cycle
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configViews];
    }
    
    return self;
}

-(void)setViewalpha:(CGFloat)viewalpha
{
    self.alpha = viewalpha;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:viewalpha];
}
-(void)setIsShowindicatorImageView:(BOOL)isShowindicatorImageView
{
    self.indicatorImageView.hidden = isShowindicatorImageView;
}
#pragma mark - Methods

- (void)updateLayout {

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.titleLabel.text;
    [titleLabel sizeToFit];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:13];
    detailLabel.numberOfLines = 0;
    detailLabel.text = self.detailLabel.text;
    CGSize size = [detailLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 131, 0)];

    CGFloat margin = (88 - titleLabel.frame.size.height - size.height - 10) / 2;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(margin);
    }];
}

- (void)configViews {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.versionLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.badgeLabel];
    [self addSubview:self.indicatorImageView];
    
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(13);
        make.left.equalTo(self.iconImageView.mas_left).with.offset(40);
        make.top.equalTo(self.iconImageView.mas_top).with.offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(15);
    }];
    
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.bottom.equalTo(self.titleLabel.mas_bottom).with.offset(-2);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
    }];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.indicatorImageView.mas_left).with.offset(-15);
    }];
}



#pragma mark - Accessor

- (UIImageView *)iconImageView {

    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
    }
    
    return _iconImageView;
}

- (UILabel *) versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = [UIColor whiteColor];
        _versionLabel.font = [UIFont systemFontOfSize:8];
        _versionLabel.layer.masksToBounds = YES;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.layer.cornerRadius = 6;
    }
    return _versionLabel;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor colorWithHeX:0x666666];
        _detailLabel.numberOfLines = 0;
    }
    
    return _detailLabel;
}

- (TDFExpanableLabel *)badgeLabel {

    if (!_badgeLabel) {
        
        _badgeLabel = [[TDFExpanableLabel alloc] init];
        _badgeLabel.font = [UIFont systemFontOfSize:11];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 3;
        _badgeLabel.horizontalExpan = 6;
        _badgeLabel.verticalExpan = 4;
    }
    
    return _badgeLabel;
}

- (UIImageView *)indicatorImageView {

    if (!_indicatorImageView) {
        
        _indicatorImageView = [[UIImageView alloc] init];
        _indicatorImageView.image = [UIImage imageNamed:@"wxoa_disclosure_indicator"];
        _indicatorImageView.contentMode = UIViewContentModeRight;
    }
    
    return _indicatorImageView;
}
@end
