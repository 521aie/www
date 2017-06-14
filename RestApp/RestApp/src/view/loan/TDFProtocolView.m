//
//  TDFProtocolView.m
//  RestApp
//
//  Created by suckerl on 2017/6/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFProtocolView.h"
#import "UIColor+Hex.h"

@interface TDFProtocolView()
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UILabel *agreeLabel;
@property (nonatomic,strong) UILabel *agreementLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@end

@implementation TDFProtocolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self constructLayOut];
    }
    return self;
}

#pragma mark - click
- (void)btnClick:(UIButton*)btn {
    btn.selected = !btn.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(protocolViewSelBtnClick:)]) {
        [self.delegate protocolViewSelBtnClick:btn];
    }
    

}

- (void)agreementClick {
    if ([self.delegate respondsToSelector:@selector(protocolViewAgreementClick)]) {
        [self.delegate protocolViewAgreementClick];
    }
}


- (void)setupSubviews {
    [self addSubview:self.selectButton];
    [self addSubview:self.agreeLabel];
    [self addSubview:self.agreementLabel];
    [self addSubview:self.detailLabel];
}

- (void)constructLayOut {
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21);
        make.height.width.equalTo(@15);
        make.top.equalTo(self.mas_top);
    }];
    
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectButton.mas_right).offset(9);
        make.top.equalTo(_selectButton.mas_top);
        make.height.equalTo(_selectButton.mas_height)
        ;
        make.width.equalTo(@70);
    }];
    
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeLabel.mas_right);
        make.top.equalTo(_selectButton.mas_top);
        make.height.equalTo(_selectButton.mas_height)
        ;
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectButton.mas_bottom).offset(9);
        make.left.equalTo(_selectButton.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
#pragma mark - lazy
- (UIButton *)selectButton {
    if (_selectButton == nil) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"loanNotSel15"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"loanSel15"] forState:UIControlStateSelected];
        [_selectButton setSelected:false];
        [_selectButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UILabel *)agreeLabel {
    if (_agreeLabel == nil) {
        _agreeLabel = [[UILabel alloc] init];
        _agreeLabel.text = @"阅读并同意";
        _agreeLabel.textColor = [UIColor colorWithHexString:@"#686d9b"];
        _agreeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _agreeLabel;
}

- (UILabel *)agreementLabel {
    if (_agreementLabel == nil) {
        _agreementLabel = [[UILabel alloc] init];
        _agreementLabel.text = @"《用户服务协议》";
        _agreementLabel.textColor = [UIColor blackColor];
        _agreementLabel.font = [UIFont systemFontOfSize:13];
        _agreementLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementClick)];
        [_agreementLabel addGestureRecognizer:tap];
    }
    return _agreementLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#686d9b"];
        _detailLabel.text = @"同意在签订贷款协议后，为对方提供本店营业数据。";
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}

@end
