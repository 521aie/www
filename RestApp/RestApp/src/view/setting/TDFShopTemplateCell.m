//
//  TDFShopTemplateCell
//  RestApp
//
//  Created by BK_G on 2017/1/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFShopTemplateCell.h"

@interface TDFShopTemplateCell ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation TDFShopTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configLayout];
        
        [self configConst];
    }
    return self;
}

- (void)configLayout {

    [self.contentView addSubview:self.lblName];
    
    [self.contentView addSubview:self.lblVal];
    
    [self.contentView addSubview:self.rightArrow];
    
    [self addSubview:self.lineView];

}

- (void)configConst {

    __weak typeof(self) ws = self;
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.contentView.mas_top);
        make.bottom.equalTo(ws.contentView.mas_bottom);
        make.left.equalTo(ws.contentView.mas_left).offset(10);
        make.right.equalTo(ws.lblVal.mas_left);
        
    }];
    
    [self.lblVal mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.lblName.mas_top);
        make.bottom.equalTo(ws.lblName.mas_bottom);
        make.left.equalTo(ws.contentView.mas_left).offset(SCREEN_WIDTH *2/3 - 20);
        make.right.equalTo(ws.rightArrow.mas_left);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.lblVal.mas_right);
        make.right.equalTo(ws.contentView.mas_right);
        make.top.equalTo(ws.contentView.mas_top);
        make.bottom.equalTo(ws.contentView.mas_bottom);
        make.width.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
        make.bottom.equalTo(ws.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)lblName {

    if (!_lblName) {
        
        _lblName = [[UILabel alloc]init];
        _lblName.font = [UIFont systemFontOfSize:13];
    }
    return _lblName;
}

- (UILabel *)lblVal {

    if (!_lblVal) {
        
        _lblVal = [[UILabel alloc]init];
        _lblVal.font = [UIFont systemFontOfSize:15];
        _lblVal.textAlignment = NSTextAlignmentRight;
        _lblVal.textColor = [UIColor colorWithRed:0 green:136/255.0 blue:204/255.0 alpha:1];
    }
    return _lblVal;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor blackColor];
    }
    
    return _lineView;
}

- (UIImageView *)rightArrow {

    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]init];
        
        _rightArrow.image = [UIImage imageNamed:@"ico_next"];
        
        _rightArrow.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightArrow;
}

@end
