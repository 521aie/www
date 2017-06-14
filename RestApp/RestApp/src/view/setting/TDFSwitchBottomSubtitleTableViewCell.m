//
//  TDFSwitchBottomSubtitleTableViewCell.m
//  RestApp
//
//  Created by chaiweiwei on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSwitchBottomSubtitleTableViewCell.h"

@implementation TDFSwitchBottomSubtitleTableViewCell

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
        
        [self.contentView addSubview:self.detailLable];
        
        [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.btnSwitch];
        [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self.detailLable.mas_centerY);
            make.height.equalTo(@(41));
            make.width.equalTo(@(51));
        }];
        
        [self.contentView addSubview:self.titleLable];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
        }];
        
        [self.contentView addSubview:self.tagLable];
        [self.tagLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.titleLable.mas_bottom).with.offset(8);
        }];
        
        UIView *lineview = [self createLineView];
        [self.contentView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.detailLable.mas_top);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [self.contentView addSubview:self.lblTip];
        [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(32));
            make.height.equalTo(@(12));
            make.top.equalTo(lineview.mas_bottom);
            make.leading.equalTo(self).with.offset(11);
        }];
    }
    return self;
}

- (void)setModel:(ShopVO *)model {
    _model = model;
    
    self.titleLable.text = model.shopName;
    NSString *subTitle;
    if(model.plateName.length > 0) {
        subTitle = [NSString stringWithFormat:@"%@,",model.plateName];
    }else {
        subTitle = @"";
    }
    
    if(model.joinMode == 1){
        subTitle = [NSString stringWithFormat:NSLocalizedString(@"%@直营", nil),subTitle];
    }else {
        subTitle = [NSString stringWithFormat:NSLocalizedString(@"%@加盟",nil),subTitle];
    }
    
    self.tagLable.text = subTitle;
    
    self.detailLable.text = NSLocalizedString(@"▪︎ 此门店的付款方式由总部管理", nil);
    self.btnSwitch.selected = model.isSelected;
    
    [self checkShouldShowTip];
}

- (void)switchValueChanged:(UIButton *)btnSwitch
{
    self.btnSwitch.selected = !btnSwitch.selected;
    self.model.isSelected = self.btnSwitch.selected;
    !self.filterBlock?:self.filterBlock(self.btnSwitch.selected);
    
    [self checkShouldShowTip];
}

- (void)checkShouldShowTip
{
    if (self.model.status == self.model.isSelected) {
        self.lblTip.hidden = YES;
    } else {
        self.lblTip.hidden = NO;
    }
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.8;
    return lineView;
}

- (UILabel *)titleLable {
    if(!_titleLable){
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textColor = RGBA(51, 51, 51, 1);
    }
    return _titleLable;
}


- (UILabel *)tagLable {
    if(!_tagLable){
        _tagLable = [[UILabel alloc] init];
        _tagLable.font = [UIFont systemFontOfSize:11];
        _tagLable.textColor = RGBA(102, 102, 102, 1);
    }
    return _tagLable;
}

- (UILabel *)detailLable {
    if(!_detailLable) {
        _detailLable = [[UILabel alloc] init];
        _detailLable.font = [UIFont systemFontOfSize:15];
        _detailLable.textColor = RGBA(51, 51, 51, 1);
    }
    return _detailLable;
}

- (UIButton *)btnSwitch
{
    if (!_btnSwitch) {
        _btnSwitch = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSwitch setImage:[UIImage imageNamed:@"ico_switch_on.png"] forState:UIControlStateSelected];
        [_btnSwitch setImage:[UIImage imageNamed:@"ico_switch_off.png"] forState:UIControlStateNormal];
    }
    
    return _btnSwitch;
}

- (UILabel *)lblTip
{
    if (!_lblTip) {
        _lblTip = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTip.layer.backgroundColor = [UIColor redColor].CGColor;
        _lblTip.textColor = [UIColor whiteColor];
        _lblTip.font = [UIFont systemFontOfSize:10];
        _lblTip.text = NSLocalizedString(@"未保存", nil);
        _lblTip.layer.cornerRadius = 2;
        _lblTip.hidden = YES;
    }
    
    return _lblTip;
}

@end
