//
//  TDFCenterTitleCell.m
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCenterTitleCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@implementation TDFCenterTitleCell

@synthesize titleLabel          =       _titleLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    [self configViews];
    }

    return self;
}

- (void)configViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:self.titleLabel];
    
    @weakify(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    return _titleLabel;
}

@end
