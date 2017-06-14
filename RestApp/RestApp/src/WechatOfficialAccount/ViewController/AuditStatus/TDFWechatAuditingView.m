//
//  TDFWechatAuditingView.m
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWechatAuditingView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "WXOAConst.h"
#import "TDFMarketingStore.h"
#import "Platform.h"

@interface TDFWechatAuditingView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *urgentButton;
@property (strong, nonatomic) UILabel *promptLabel;

@end

@implementation TDFWechatAuditingView

#pragma mark - Life Cycle

- (void)configSubViews {
    [super configSubViews];
    [self addSubview:self.imageView];
    [self addSubview:self.urgentButton];
    [self addSubview:self.promptLabel];
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.mas_top).with.offset(12);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(96);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.urgentButton mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(40);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.urgentButton.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

#pragma mark - Public Methods

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(SCREEN_WIDTH, 214);
}


#pragma mark - Private Methods

- (void)urgentButtonTapped {

    !self.urgentBlock ?: self.urgentBlock();
}

#pragma mark - Accessor

- (UILabel *)promptLabel {

    if (!_promptLabel) {
     
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = WXOALocalizedString(@"WXOA_Wechat_Audit_Prompt");
        _promptLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.numberOfLines = 0;
    }
    
    return _promptLabel;
}

- (UIButton *)urgentButton {

    if (!_urgentButton) {
        
        _urgentButton = [[UIButton alloc] init];
        [_urgentButton setTitle:WXOALocalizedString(@"WXOA_Wechat_Audit_Complete") forState:UIControlStateNormal];
        BOOL flag = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.managedByChain;
        _urgentButton.backgroundColor = [UIColor colorWithHeX:flag ? 0x999999 : 0xCC0000];
        _urgentButton.enabled = !flag;
        _urgentButton.titleLabel.textColor = [UIColor whiteColor];
        _urgentButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_urgentButton addTarget:self action:@selector(urgentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _urgentButton.layer.masksToBounds = YES;
        _urgentButton.layer.cornerRadius = 5;
    }
    
    return _urgentButton;
}

- (UIImageView *)imageView {

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxoa_wechat_auditing"]];
    }
    
    return _imageView;
}

@end
