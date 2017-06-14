//
//  TDFFuncSectionHeader.m
//  RestApp
//
//  Created by Cloud on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFFuncSectionHeader.h"

@interface TDFFuncSectionHeader ()

@property (nonatomic ,strong) UIButton *selectBtn;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,copy) void(^callBack)(BOOL select);


@end

@implementation TDFFuncSectionHeader

- (instancetype)init {

    if (self = [super init]) {

        [self configlayout];
    }
    return self;
}

- (void)configlayout {

    [self addSubview:self.bgView];
    [self addSubview:self.selectBtn];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel.mas_top);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.selectBtn.mas_left).offset(-5);
        make.right.equalTo(self.titleLabel.mas_right).offset(30);
    }];
}

- (void)loadName:(NSString *)title andIsSelected:(BOOL )isSelected andSelectBlock:(void(^)(BOOL select))callback{
    
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    
    self.selectBtn.selected = isSelected;
    
    self.callBack = callback;
    
    [self layoutIfNeeded];
}

- (void)SectionBtnDidClick:(UIButton *)btn {

    btn.selected = !btn.selected;
    
    if (self.callBack) {
        
        self.callBack(btn.selected);
    }
}

#pragma mark - Getter

- (UIView *)bgView {

    if (!_bgView) {
        
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        
        _bgView.layer.cornerRadius = 12;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)selectBtn {

    if (!_selectBtn) {
        
        _selectBtn = [UIButton new];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(SectionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
