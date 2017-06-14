//
//  TDFRightUserCell.m
//  RestApp
//
//  Created by Cloud on 2017/4/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRightUserCell.h"
#import "TDFRightUserItem.h"
#import "UIImageView+WebCache.h"
#import "TDFNetworkEnvironmentController.h"

@interface TDFRightUserCell ()

@property (nonatomic ,strong) UIImageView *imgView;

@property (nonatomic ,strong) UIImageView *rightArrow;

@property (nonatomic ,strong) UILabel     *unameLabel;

@property (nonatomic ,strong) UILabel     *ucompanyLabel;

@property (nonatomic ,strong) UIView      *lineView;

@property (nonatomic ,strong) UIButton    *changeEnvBtn;

@property (nonatomic, strong) void (^clickedBlock)();

@end

@implementation TDFRightUserCell

- (void)cellDidLoad {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self configLayout];
}

- (void)configLayout {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.rightArrow];
    [self.contentView addSubview:self.unameLabel];
    [self.contentView addSubview:self.ucompanyLabel];
    [self.contentView addSubview:self.lineView];
    
    
#if DEBUG
    
    [self.contentView addSubview:self.changeEnvBtn];
    
#endif
    [self configContrains];
}

- (void)configContrains {
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(72);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.imgView.mas_centerY);
        make.left.equalTo(self.imgView.mas_right).offset(20);
    }];
    
    [self.unameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
        make.left.right.offset(0);
        make.centerX.equalTo(self.imgView.mas_centerX);
    }];
    
    [self.ucompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.unameLabel.mas_bottom);
        make.left.right.offset(0);
        make.centerX.equalTo(self.imgView.mas_centerX);
        make.bottom.equalTo(self.lineView.mas_top).with.offset(-20);
        make.height.equalTo(self.unameLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
#if DEBUG
    
    [self.changeEnvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(20);
        make.right.offset(0);
        make.width.equalTo(self.imgView.mas_width);
        make.bottom.equalTo(self.imgView.mas_top);
    }];
    
#endif
}

+ (CGFloat)heightForCellWithItem:(TDFRightUserItem *)item {
    
    
    return 190;
}

- (void)configCellWithItem:(TDFRightUserItem *)item {
    
    self.clickedBlock = item.changeEnv;
    
    if (item.icoUrl) {
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icoUrl] placeholderImage:[UIImage imageNamed:@"img_nopic_user.png"]];
    }else {
        
        self.imgView.image = [UIImage imageNamed:@"img_nopic_user.png"];
    }
    
    self.unameLabel.text = item.userName;
    self.ucompanyLabel.text = item.userCompany;
    
#if DEBUG
    
    TDFNetworkEnvironmentController *environmentController = [TDFNetworkEnvironmentController sharedInstance];
    TDFNetworkEnvironmentModel *model = environmentController.currentEnvironment;
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@环境", nil), model.evnironmentName];
    [self.changeEnvBtn setTitle:title forState:UIControlStateNormal];
    
#endif
}

#pragma mark - Getter

- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"business_arrow_icon_right"]];
    }
    return _rightArrow;
}

- (UIImageView *)imgView {
    
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_nopic_user"]];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 36;
//        _imgView.layer.borderWidth = 1;
//        _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _imgView;
}

- (UILabel *)unameLabel {
    
    if (!_unameLabel) {
        
        _unameLabel = [UILabel new];
        _unameLabel.textColor = [UIColor whiteColor];
        _unameLabel.font = [UIFont systemFontOfSize:17];
        _unameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unameLabel;
}

- (UILabel *)ucompanyLabel {
    
    if (!_ucompanyLabel) {
        
        _ucompanyLabel = [UILabel new];
        _ucompanyLabel.textColor = [UIColor whiteColor];
        _ucompanyLabel.font = [UIFont systemFontOfSize:11];
        _ucompanyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ucompanyLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        
        _lineView = [UIView new];
        
        _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (UIButton *)changeEnvBtn {
    
    if (!_changeEnvBtn) {
        
        _changeEnvBtn = [UIButton new];
        _changeEnvBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_changeEnvBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _changeEnvBtn.layer.borderColor = [UIColor redColor].CGColor;
        _changeEnvBtn.layer.borderWidth = 2;
        _changeEnvBtn.layer.cornerRadius = 5;
        _changeEnvBtn.layer.masksToBounds = YES;
        [_changeEnvBtn addTarget:self action:@selector(changeEnvDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeEnvBtn;
}

- (void)changeEnvDidClick {
    
    if (self.clickedBlock) {
        
        self.clickedBlock();
    }
}

@end
