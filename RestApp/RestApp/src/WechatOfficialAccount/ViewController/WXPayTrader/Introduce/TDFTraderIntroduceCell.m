//
//  TDFTraderIntroduceCell.m
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTraderIntroduceCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@implementation TDFTraderIntroduceCell

@synthesize iconImageView       =       _iconImageView,
            titleLabel          =       _titleLabel,
            detailLabel         =       _detailLabel;


#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configViews];
    }
    
    return self;
}


#pragma mark - Methods

- (void)configViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.mas_left).with.offset(25);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(20);
        make.top.equalTo(self.mas_top).with.offset(11);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}



#pragma mark - Accessor

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
    }
    
    return _iconImageView;
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


@end
