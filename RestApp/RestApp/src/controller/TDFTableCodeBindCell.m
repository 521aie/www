//
//  TDFTableCodeBindCell.m
//  RestApp
//
//  Created by Octree on 6/9/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableCodeBindCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface TDFTableCodeBindCell ()

@property (strong, nonatomic) UIView *backView;

@end

@implementation TDFTableCodeBindCell

@synthesize titleLabel = _titleLabel,
detailButton = _detailButton,
scanButton = _scanButton;

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
    
        [self configViews];
    }
    
    return self;
}


#pragma mark - Private Methods

- (void)configViews {

    
    __weak __typeof(self) wself = self;
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wself).with.insets(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.top.equalTo(wself.mas_top).with.offset(20);
        make.width.mas_equalTo(240);
    }];
    
    [self addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wself.mas_left).with.offset(10);
        make.top.equalTo(wself.titleLabel.mas_bottom).with.offset(15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:self.scanButton];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(wself.mas_right).with.offset(-10);
        make.centerY.equalTo(wself.mas_centerY);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(58);
    }];
}

#pragma mark - Accessor

- (UIView *)backView {

    if (!_backView) {
    
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    
    return _backView;
}


- (UIButton *)scanButton {

    if (!_scanButton) {
    
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setTitle:NSLocalizedString(@"扫码绑定", nil) forState:UIControlStateNormal];
        [_scanButton setImage:[UIImage imageNamed:@"qrcode_scan_small"] forState:UIControlStateNormal];
        
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_scanButton setTitleColor:[UIColor colorWithHeX:0x0088CC] forState:UIControlStateNormal];
        
        CGSize imageSize = _scanButton.imageView.image.size;
        _scanButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + 4), 0.0);
        
        
        CGSize titleSize = [_scanButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _scanButton.titleLabel.font}];
        _scanButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 4), 0.0, 0.0, - titleSize.width);
        
        CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
        _scanButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    }
    
    return _scanButton;
}

- (UIButton *)detailButton {

    if (!_detailButton) {
    
        _detailButton = [[UIButton alloc] init];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _detailButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _detailButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _detailButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [_detailButton setTitleColor:[UIColor colorWithHeX:0x07AD1F] forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor colorWithHeX:0xCC0000] forState:UIControlStateDisabled];
        [_detailButton setTitle:NSLocalizedString(@"未绑定", nil) forState:UIControlStateDisabled];
        [_detailButton setImage:[UIImage imageNamed:@"disclosure_indicator"] forState:UIControlStateNormal];
        [_detailButton setImage:[UIImage imageNamed:@"disclosure_indicator_empty"] forState:UIControlStateDisabled];
        _detailButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    return _detailButton;
}

- (UILabel *)titleLabel {

    if (!_titleLabel) {
    
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHeX:0x333333];
    }
    
    return _titleLabel;
}


@end
