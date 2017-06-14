//
//  TDFAttributeLabelCell.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAttributeLabelCell.h"
#import "TDFAttributeLabelItem.h"
#import <TDFComponents/DHTTableViewCellProtocol.h>
#import <Masonry/Masonry.h>

@interface TDFAttributeLabelCell ()<DHTTableViewCellDelegate>

@property (strong, nonatomic) UILabel *label;

@end

@implementation TDFAttributeLabelCell

- (void)configViews {
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

#pragma mark - DHTTableViewCellDelegate


- (void)cellDidLoad {
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configViews];
}

+ (CGFloat)heightForCellWithItem:(TDFAttributeLabelItem *)item {
    
    if (!item.shouldShow) {
        return 0;
    }
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.attributedText = item.attributedString;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 0);
    return [label sizeThatFits:size].height + 28;
}

- (void)configCellWithItem:(TDFAttributeLabelItem *)item {
    
    self.label.attributedText = item.attributedString;
    self.hidden = !item.shouldShow;
}

#pragma mark - Accessor

- (UILabel *)label {

    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    
    return _label;
}

@end
