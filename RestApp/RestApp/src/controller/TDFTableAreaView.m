//
//  TDFTableAreaView.m
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableAreaView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface TDFTableAreaView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TDFTableAreaView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {

    if (self = [super initWithFrame:frame]) {
    
        [self configViews];
        self.titleLabel.text = title;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configViews {

    [self addSubview:self.titleLabel];
    
    __typeof(self) wslef = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(wslef.mas_centerX);
        make.top.equalTo(wslef.mas_top).with.offset(11);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(22);
    }];
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
    
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.backgroundColor = [[UIColor colorWithHeX:0x999999] colorWithAlphaComponent:0.7];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 11;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

@end
