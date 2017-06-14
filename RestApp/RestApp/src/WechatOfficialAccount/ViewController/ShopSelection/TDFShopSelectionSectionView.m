//
//  TDFShopSelectionSectionView.m
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopSelectionSectionView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface TDFShopSelectionSectionView ()

@property (strong, nonatomic, readwrite) UIButton *selectionButton;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation TDFShopSelectionSectionView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self configViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configViews {

    @weakify(self);
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.center.equalTo(self);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(22);
    }];
    
    [self.containerView addSubview:self.selectionButton];
    [self.selectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerY.equalTo(self.containerView);
        make.left.equalTo(self.containerView).with.offset(2);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.center.equalTo(self.containerView);
    }];
}

- (void)selectionButtonTapped {
 
    !self.selectionBlock ?: self.selectionBlock();
}

- (UIButton *)selectionButton {

    if (!_selectionButton) {
        
        _selectionButton = [[UIButton alloc] init];
        [_selectionButton setImage:[UIImage imageNamed:@"icon_select_empty"] forState:UIControlStateNormal];
        [_selectionButton setImage:[UIImage imageNamed:@"icon_select_filled"] forState:UIControlStateSelected];
        [_selectionButton addTarget:self action:@selector(selectionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectionButton;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)containerView {

    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 11;
    }
    
    return _containerView;
}
@end
