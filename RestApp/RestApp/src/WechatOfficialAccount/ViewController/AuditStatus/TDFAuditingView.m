//
//  TDFAuditingView.m
//  RestApp
//
//  Created by Octree on 10/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAuditingView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "WXOAConst.h"

@interface TDFAuditingView ()

@property (strong, nonatomic) UILabel *reasonLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation TDFAuditingView


#pragma mark - Life Cycle

- (void)configSubViews {
    [super configSubViews];
    
    [self addSubview:self.reasonLabel];
    [self addSubview:self.timeLabel];
    
    @weakify(self);
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

#pragma mark - Public Methods

- (CGSize)intrinsicContentSize {
    
//    CGSize size = [super intrinsicContentSize];
//    size.height += self.reasonLabel.intrinsicContentSize.height
//                 + self.timeLabel.intrinsicContentSize.height + 18;
    CGSize size =[self.reasonLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    size.width = SCREEN_WIDTH;
    size.height += 30;
    return size;
}

#pragma mark - Private Methods


#pragma mark - Accessor

- (UILabel *)reasonLabel {

    if (!_reasonLabel) {
        
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.text = self.model.detail;
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.font = [UIFont systemFontOfSize:14];
        _reasonLabel.textColor = [UIColor colorWithHeX:0xF58023];
        _reasonLabel.numberOfLines = 0;
    }
    
    return _reasonLabel;
}

- (UILabel *)timeLabel {

    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = WXOALocalizedFormat(@"WXOA_Trader_Apply_Date_Format", self.model.applyDateString);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHeX:0x666666];
    }
    
    return _timeLabel;
}

@end
