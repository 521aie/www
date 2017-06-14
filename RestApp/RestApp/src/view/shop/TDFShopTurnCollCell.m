//
//  TDFShopTurnCollCell.m
//  RestApp
//
//  Created by Cloud on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopTurnCollCell.h"

@interface TDFShopTurnCollCell ()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *detailLabel;

@property (nonatomic ,strong) UIView *leftLine;

@property (nonatomic ,strong) UIView *rightLine;


@end

@implementation TDFShopTurnCollCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {

        [self configLayout];
    }
    return self;
}

- (void)configWithItem:(TDFShopTurnItem *)item andIndex:(NSInteger )index {

    [self hideLeftAndRight:index%3==1?NO:YES];
    
    self.titleLabel.text = item.titleStr;
    
    self.detailLabel.attributedText = item.detail;
}

- (void)hideLeftAndRight:(BOOL )hide {

    self.leftLine.hidden = hide;
    self.rightLine.hidden = hide;
}

- (void)configLayout {
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.leftLine];
    [self.contentView addSubview:self.rightLine];

    __weak typeof(self) ws = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.offset(5);
        make.right.offset(-5);
        make.height.equalTo(ws.contentView.mas_height).multipliedBy(0.3);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(ws.titleLabel);
//        make.bottom.offset(-5);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.width.mas_equalTo(0.5);
        make.top.offset(5);
        make.bottom.equalTo(ws.detailLabel.mas_bottom);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(0);
        make.width.mas_equalTo(0.5);
        make.top.offset(5);
        make.bottom.equalTo(ws.detailLabel.mas_bottom);
    }];
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.text = @"应收";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {

    if (!_detailLabel) {
        
        _detailLabel = [UILabel new];
        _detailLabel.text = @"0.00";
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _detailLabel;
}


- (UIView *)leftLine {

    if (!_leftLine) {
        
        _leftLine = [UIView new];
        _leftLine.backgroundColor = [UIColor lightGrayColor];
        _leftLine.alpha = 0.3;
    }
    return _leftLine;
}

- (UIView *)rightLine {

    if (!_rightLine) {
        
        _rightLine = [UIView new];
        _rightLine.backgroundColor = [UIColor lightGrayColor];
        _rightLine.alpha = 0.3;
    }
    return _rightLine;
}

















@end

@implementation TDFShopTurnItem

- (instancetype)initWithTitle:(NSString *)title andDetail:(NSMutableAttributedString *)detail {

    self = [super init];
    
    if (self) {
        
        self.titleStr = title;
        
        self.detail = detail;
    }
    return self;
}

@end
