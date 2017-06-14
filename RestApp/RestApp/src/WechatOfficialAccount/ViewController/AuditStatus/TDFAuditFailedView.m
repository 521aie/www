//
//  TDFAuditFailedView.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditFailedView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "WXOAConst.h"
#import "TDFMarketingStore.h"
#import "Platform.h"

@interface TDFAuditFailedView ()

@property (strong, nonatomic) UILabel *reasonLabel;
@property (strong, nonatomic) UIButton *retryButton;

@end


@implementation TDFAuditFailedView

#pragma mark - Life Cycle

- (void)configSubViews {
    [super configSubViews];
    
    [self addSubview:self.reasonLabel];
    [self addSubview:self.retryButton];
    
    @weakify(self);
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(50);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Public Methods

- (CGSize)intrinsicContentSize {
    
    //    CGSize size = [super intrinsicContentSize];
    //    size.height += self.reasonLabel.intrinsicContentSize.height
    //                 + self.timeLabel.intrinsicContentSize.height + 18;
    CGSize size =[self.reasonLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    size.width = SCREEN_WIDTH;
    size.height = 90 + size.height;
    return size;
}

#pragma mark - Private Methods

- (void)retryButtonTapped {

    !self.retryBlock ?: self.retryBlock();
}


#pragma mark - Accessor

- (UILabel *)reasonLabel {
    
    if (!_reasonLabel) {
        
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.text = WXOALocalizedFormat(@"WXOA_Fail_Format", self.model.detail);
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.font = [UIFont systemFontOfSize:14];
        _reasonLabel.textColor = [UIColor colorWithHeX:0xCC0000];
        _reasonLabel.numberOfLines = 0;
    }
    
    return _reasonLabel;
}

- (UIButton *)retryButton {

    if (!_retryButton) {
        _retryButton = [[UIButton alloc] init];
        BOOL flag = ![Platform Instance].isChain && [TDFMarketingStore sharedInstance].marketingModel.managedByChain;
        [_retryButton setTitle:WXOALocalizedString(@"WXOA_WXPay_Trader_Retry") forState:UIControlStateNormal];
        _retryButton.backgroundColor = [UIColor colorWithHeX:flag ? 0x999999 : 0xCC0000];
        _retryButton.enabled = !flag;
        _retryButton.titleLabel.textColor = [UIColor whiteColor];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_retryButton addTarget:self action:@selector(retryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _retryButton.layer.masksToBounds = YES;
        _retryButton.layer.cornerRadius = 5;
    }
    
    return _retryButton;
}

@end
