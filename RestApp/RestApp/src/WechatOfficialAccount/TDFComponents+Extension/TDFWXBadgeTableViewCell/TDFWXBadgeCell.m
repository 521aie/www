//
//  TDFWXBadgeCell.m
//  RestApp
//
//  Created by Octree on 13/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXBadgeCell.h"
#import "TDFLabelFactory.h"
#import "TDFExpanableLabel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "TDFWXBadgeItem.h"

@interface TDFWXBadgeCell ()

@property (copy, nonatomic) NSArray *bottomBadgeLabels;
@property (strong, nonatomic) TDFExpanableLabel *statusBadgeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *indicatorImageView;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation TDFWXBadgeCell

#pragma mark - Life Cycle



#pragma mark - Public Method



#pragma mark - Private Method

- (void)configViews {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    
    [self.containerView addSubview:self.indicatorImageView];
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).with.offset(-10);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
    
    [self.containerView addSubview:self.statusBadgeLabel];
    [self.statusBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.indicatorImageView.mas_left).with.offset(-10);
        make.centerY.equalTo(self.containerView);
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.top.equalTo(self.containerView.mas_top).with.offset(23);
        make.right.equalTo(self.statusBadgeLabel.mas_right);
    }];

    MASViewAttribute *ref = self.containerView.mas_left;
    for (UILabel *label in self.bottomBadgeLabels) {
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ref).with.offset(10);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        }];
        ref = label.mas_right;
    }
}

- (TDFExpanableLabel *)generateBottomBadge {

    TDFExpanableLabel *label = [[TDFExpanableLabel alloc] init];
    UIColor *color = [UIColor colorWithHeX:0x07AD1F];
    label = [[TDFExpanableLabel alloc] init];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3;
    label.horizontalExpan = 6;
    label.verticalExpan = 4;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor colorWithHeX:0x07AD1F].CGColor;
    [self.containerView addSubview:label];
    label.hidden = YES;
    return label;
}

#pragma mark - DHTTableViewCellDelegate


- (void)cellDidLoad {

    [self configViews];
}

+ (CGFloat)heightForCellWithItem:(DHTTableViewItem *)item {

    return 65;
}

- (void)configCellWithItem:(TDFWXBadgeItem *)item {

    NSInteger count = item.badgeNames.count;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(count > 0 ? 10 : 23);
    }];
    self.titleLabel.text = item.title;
    switch (item.status) {
        case 0:
            self.statusBadgeLabel.text = @"未同步";
            self.statusBadgeLabel.backgroundColor = [UIColor colorWithHexString:@"#CC0000"];
            break;
        case 1:
            self.statusBadgeLabel.text = @"已同步";
            self.statusBadgeLabel.backgroundColor = [UIColor colorWithHexString:@"#07AD1F"];
            break;
        case 2:
            self.statusBadgeLabel.text = @"同步中";
            self.statusBadgeLabel.backgroundColor = [UIColor colorWithHexString:@"#F56D23"];
            break;
            
        default:
            break;
    }
    
    [self.bottomBadgeLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < item.badgeNames.count) {
            NSString *badgeName = item.badgeNames[idx];
            label.hidden = NO;
            label.text = badgeName;
        }else {
            label.hidden = YES;
        }
    }];

}

#pragma mark - Accessor

- (UIView *)containerView {

    if (!_containerView) {
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    
    return _containerView;
}

- (NSArray *)bottomBadgeLabels {
    
    if (!_bottomBadgeLabels) {
        
        _bottomBadgeLabels = @[
                               [self generateBottomBadge],
                               [self generateBottomBadge],
                               [self generateBottomBadge]
                               ];
    }
    return _bottomBadgeLabels;
}

- (TDFExpanableLabel *)statusBadgeLabel {
    
    if (!_statusBadgeLabel) {
        
        _statusBadgeLabel = [[TDFExpanableLabel alloc] init];
        _statusBadgeLabel.font = [UIFont systemFontOfSize:11];
        _statusBadgeLabel.textColor = [UIColor whiteColor];
        _statusBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _statusBadgeLabel.layer.masksToBounds = YES;
        _statusBadgeLabel.layer.cornerRadius = 3;
        _statusBadgeLabel.horizontalExpan = 6;
        _statusBadgeLabel.verticalExpan = 4;
    }
    return _statusBadgeLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIImageView *)indicatorImageView {
    
    if (!_indicatorImageView) {
        
        _indicatorImageView = [[UIImageView alloc] init];
        _indicatorImageView.image = [UIImage imageNamed:@"wxoa_disclosure_indicator"];
        _indicatorImageView.contentMode = UIViewContentModeRight;
    }
    return _indicatorImageView;
}

@end
