//
//  TDFKindPayBatchCell.m
//  RestApp
//
//  Created by chaiweiwei on 2017/2/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFKindPayBatchCell.h"

@implementation TDFKindPayBatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =[UIColor whiteColor];
        view.alpha =0.6;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        [self.contentView addSubview:self.titleLable];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(38);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.memoLable];
        [self.memoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.left.equalTo(self.titleLable.mas_right);
            make.centerY.equalTo(self.titleLable.mas_centerY);
        }];
        
        [self addSubview:self.selectIcon];
        [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.height.and.with.mas_equalTo(18);
        }];
    }
    return self;
}

- (UILabel *)titleLable {
    if(!_titleLable){
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    return _titleLable;
}

- (UILabel *)memoLable {
    if(!_memoLable){
        _memoLable = [[UILabel alloc] init];
        _memoLable.textAlignment = NSTextAlignmentRight;
        _memoLable.font = [UIFont systemFontOfSize:11];
        _memoLable.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    }
    return _memoLable;
}

- (UIImageView *)selectIcon {
    if(!_selectIcon) {
        _selectIcon = [[UIImageView alloc] init];
        _selectIcon.image = [UIImage imageNamed:@"icon_select_empty"];
    }
    return _selectIcon;
}

@end
