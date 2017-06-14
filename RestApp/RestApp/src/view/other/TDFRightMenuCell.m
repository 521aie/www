//
//  TDFRightMenuCell.m
//  RestApp
//
//  Created by Cloud on 2017/4/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRightMenuCell.h"
#import "TDFRightMenuItem.h"

@interface TDFRightMenuCell ()

@property (nonatomic ,strong) UIImageView *iconView;

@property (nonatomic ,strong) UILabel     *titleLabel;

@property (nonatomic ,strong) UIView      *lineView;

@property (nonatomic ,strong) UILabel     *notiNumLabel;

@property (nonatomic ,strong) UIImageView *notiBgView;

@end

@implementation TDFRightMenuCell

- (void)cellDidLoad {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    [self configLayout];
}

- (void)configLayout {

    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.notiBgView];
    [self.contentView addSubview:self.notiNumLabel];
    [self.contentView addSubview:self.lineView];
    
    [self configContrains];
}

- (void)configContrains {

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(self.contentView.mas_height).offset(-20);
        make.width.equalTo(self.contentView.mas_height).offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.height.equalTo(self.iconView.mas_height);
    }];
    
    [self.notiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.centerY.equalTo(self.titleLabel.mas_centerY).offset(-10);
        make.height.width.mas_equalTo(8);
    }];
    
    [self.notiBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.notiNumLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.iconView.mas_left);
        make.right.offset(-20);
        make.bottom.offset(0);
        make.height.mas_equalTo(0.3);
    }];
}

+ (CGFloat)heightForCellWithItem:(TDFRightMenuItem *)item {

    return 44;
}

- (void)configCellWithItem:(TDFRightMenuItem *)item {

    self.iconView.image = item.iconImage;
    
    self.titleLabel.text = item.title;
    
//    item.num = 99;
    [self showbadgeOrNot:item.num];
}

- (void)showbadgeOrNot:(NSInteger )num {

    if (!num) {
        
        self.notiBgView.hidden = YES;
        self.notiNumLabel.hidden = YES;
        
        return;
    }
    
    self.notiBgView.hidden = NO;
    self.notiNumLabel.hidden = NO;
    
//    self.notiNumLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    self.notiNumLabel.text = nil;
    
    if (num>99) {
        
        self.notiNumLabel.text = @"99+";
        self.notiBgView.image = [UIImage imageNamed:@"notiNumIconThree.png"];
    }else {
    
        self.notiBgView.image = [UIImage imageNamed:@"notiNumIconOne.png"];
    }
}

#pragma mark Getter

- (UIImageView *)iconView {

    if (!_iconView) {
        
        _iconView = [UIImageView new];
        
    }
    return _iconView;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIView *)lineView {

    if (!_lineView) {
        
        _lineView = [UIView new];
        
        _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    
    return _lineView;
}

- (UILabel *)notiNumLabel {

    if (!_notiNumLabel) {
        
        _notiNumLabel = [UILabel new];
        _notiNumLabel.font = [UIFont systemFontOfSize:13];
        _notiNumLabel.textColor = [UIColor whiteColor];
        _notiNumLabel.textAlignment = NSTextAlignmentCenter;
        _notiNumLabel.hidden = YES;
    }
    return _notiNumLabel;
}

- (UIImageView *)notiBgView {

    if (!_notiBgView) {
        
        _notiBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notiNumIconOne.png"]];
        _notiBgView.contentMode = UIViewContentModeScaleAspectFit;
        _notiBgView.hidden = YES;
    }
    return _notiBgView;
}


@end
