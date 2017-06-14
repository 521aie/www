//
//  TDFAuditSuccessView.m
//  RestApp
//
//  Created by Octree on 11/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditSuccessView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "WXOAConst.h"


@interface TDFAuditSuccessView ()

@property (strong, nonatomic) UILabel *promptLabel;

@end

@implementation TDFAuditSuccessView

#pragma mark - Life Cycle

- (void)configSubViews {
    [super configSubViews];
    
    [self addSubview:self.promptLabel];
    
    @weakify(self);
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
}

#pragma mark - Public Methods

- (CGSize)intrinsicContentSize {
    
    //    CGSize size = [super intrinsicContentSize];
    //    size.height += self.reasonLabel.intrinsicContentSize.height
    //                 + self.timeLabel.intrinsicContentSize.height + 18;
    CGSize size =[self.promptLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    size.width = SCREEN_WIDTH;
    return size;
}

#pragma mark - Private Methods

#pragma mark - Accessor

- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = WXOALocalizedFormat(@"WXOA_Audit_Success_Prompt", self.model.detail);
        _promptLabel.font = [UIFont systemFontOfSize:11];
        _promptLabel.textColor = [UIColor colorWithHeX:0x666666];
        _promptLabel.numberOfLines = 0;
    }
    
    return _promptLabel;
}


@end
