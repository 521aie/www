//
//  TDFChainMemberCell.m
//  RestApp
//
//  Created by chaiweiwei on 16/7/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFChainMemberCell.h"
#import "ColorHelper.h"

@implementation TDFChainMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.7;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH - 20, 44));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [ColorHelper getTipColor3];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
